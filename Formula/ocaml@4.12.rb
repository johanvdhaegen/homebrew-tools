# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
class OcamlAT412 < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "https://caml.inria.fr/pub/distrib/ocaml-4.12/ocaml-4.12.1.tar.xz"
  sha256 "6e4aab9e182c1587c3439adff0b32c9ffc658a8808851e90d7d51b8cab9572c9"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 1

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/ocaml@4.12-4.12.1_1"
    sha256 monterey:     "27820adbe5e13f12f186c5cd8acfd4bbe4e15f49b52758d042b923fea6a33967"
    sha256 x86_64_linux: "f924f9f0667415e807c8acc2e01f5e1bb23a7cd72d53c8c25cb713b8f6a2dc82"
  end

  # The ocaml compilers embed prefix information in weird ways that the default
  # brew detection doesn't find, and so needs to be explicitly blocked.
  pour_bottle? only_if: :default_prefix

  keg_only :versioned_formula

  # Fix -flat_namespace
  patch :DATA

  def install
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores

    # the ./configure in this package is NOT a GNU autoconf script!
    args = %W[
      --prefix=#{HOMEBREW_PREFIX}/opt/ocaml@4.12
      --enable-debug-runtime
      --mandir=#{man}
    ]
    system "./configure", *args
    system "make", "world.opt"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    output = shell_output("echo 'let x = 1 ;;' | #{bin}/ocaml 2>&1")
    assert_match "val x : int = 1", output
    assert_match HOMEBREW_PREFIX.to_s, shell_output("#{bin}/ocamlc -where")
  end
end

__END__
diff -ur ocaml-4.12.1_orig/configure ocaml-4.12.1/configure
--- ocaml-4.12.1_orig/configure	2021-09-23 06:35:08.000000000 -0700
+++ ocaml-4.12.1/configure	2022-02-05 10:16:21.386478344 -0800
@@ -7634,16 +7634,11 @@
       _lt_dar_allow_undefined='$wl-undefined ${wl}suppress' ;;
     darwin1.*)
       _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-    darwin*) # darwin 5.x on
-      # if running on 10.5 or later, the deployment target defaults
-      # to the OS version, if on x86, and 10.4, the deployment
-      # target defaults to 10.4. Don't you love it?
-      case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
-	10.0,*86*-darwin8*|10.0,*-darwin[91]*)
-	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
-	10.[012][,.]*)
+    darwin*)
+      case ${MACOSX_DEPLOYMENT_TARGET},$host in
+	10.[012],*|,*powerpc*)
 	  _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-	10.*)
+	*)
 	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
       esac
     ;;
@@ -13651,7 +13646,7 @@
 if test x"$enable_shared" != "xno"; then :
   case $host in #(
   *-apple-darwin*) :
-    mksharedlib="$CC -shared -flat_namespace -undefined suppress \
+    mksharedlib="$CC -shared -undefined dynamic_lookup \
                    -Wl,-no_compact_unwind"
       shared_libraries_supported=true ;; #(
   *-*-mingw32) :


From 1eeb0e7fe595f5f9e1ea1edbdf785ff3b49feeeb Mon Sep 17 00:00:00 2001
From: Xavier Leroy <xavierleroy@users.noreply.github.com>
Date: Fri, 5 Mar 2021 19:14:07 +0100
Subject: [PATCH] Dynamically allocate the alternate signal stack

In Glibc 2.34 and later, SIGSTKSZ may not be a compile-time constant.
It is no longer possible to statically allocate the alternate signal
stack for the main thread, as we've been doing for the last 25 years.

This commit implements dynamic allocation of the alternate signal stack
even for the main thread.  It reuses the code already in place to allocate
the alternate signal stack for other threads.

The alternate signal stack is freed when the main OCaml code / an OCaml thread
stops.

(partial back-port of PR#10266 and PR#10726)
---
 otherlibs/systhreads/st_stubs.c |  2 +
 runtime/fail_nat.c              |  7 ++-
 runtime/signals_nat.c           | 87 ++++++++++++++++++++++++++++-----
 runtime/startup_nat.c           |  7 ++-
 runtime/sys.c                   |  5 ++
 5 files changed, 95 insertions(+), 13 deletions(-)

diff --git a/otherlibs/systhreads/st_stubs.c b/otherlibs/systhreads/st_stubs.c
index ff18cd01d9a..a10f0db17ca 100644
--- a/otherlibs/systhreads/st_stubs.c
+++ b/otherlibs/systhreads/st_stubs.c
@@ -132,6 +132,7 @@ static st_retcode caml_threadstatus_wait (value);
 #ifdef NATIVE_CODE
 extern struct longjmp_buffer caml_termination_jmpbuf;
 extern void (*caml_termination_hook)(void);
+extern int caml_stop_stack_overflow_detection(void);
 #endif
 
 /* Hook for scanning the stacks of the other threads */
@@ -539,6 +540,7 @@ static ST_THREAD_FUNCTION caml_thread_start(void * arg)
     caml_thread_stop();
 #ifdef NATIVE_CODE
   }
+  caml_stop_stack_overflow_detection();
 #endif
   /* The thread now stops running */
   return 0;
diff --git a/runtime/fail_nat.c b/runtime/fail_nat.c
index 352206f9a26..3ed4c638dbc 100644
--- a/runtime/fail_nat.c
+++ b/runtime/fail_nat.c
@@ -32,6 +32,8 @@
 #include "caml/roots.h"
 #include "caml/callback.h"
 
+extern void caml_terminate_signals(void);
+
 /* The globals holding predefined exceptions */
 
 typedef value caml_generated_constant[1];
@@ -70,7 +72,10 @@ void caml_raise(value v)
   if (Is_exception_result(v))
     v = Extract_exception(v);
 
-  if (Caml_state->exception_pointer == NULL) caml_fatal_uncaught_exception(v);
+  if (Caml_state->exception_pointer == NULL) {
+    caml_terminate_signals();
+    caml_fatal_uncaught_exception(v);
+  }
 
   while (Caml_state->local_roots != NULL &&
          (char *) Caml_state->local_roots < Caml_state->exception_pointer) {
diff --git a/runtime/signals_nat.c b/runtime/signals_nat.c
index 8b64ab45263..e8aff023ff8 100644
--- a/runtime/signals_nat.c
+++ b/runtime/signals_nat.c
@@ -181,8 +181,6 @@ DECLARE_SIGNAL_HANDLER(trap_handler)
 #error "CONTEXT_SP is required if HAS_STACK_OVERFLOW_DETECTION is defined"
 #endif
 
-static char sig_alt_stack[SIGSTKSZ];
-
 /* Code compiled with ocamlopt never accesses more than
    EXTRA_STACK bytes below the stack pointer. */
 #define EXTRA_STACK 256
@@ -252,6 +250,10 @@ DECLARE_SIGNAL_HANDLER(segv_handler)
 
 /* Initialization of signal stuff */
 
+#ifdef HAS_STACK_OVERFLOW_DETECTION
+static int setup_stack_overflow_detection(void);
+#endif
+
 void caml_init_signals(void)
 {
   /* Bound-check trap handling */
@@ -276,28 +278,91 @@ void caml_init_signals(void)
 #endif
 
 #ifdef HAS_STACK_OVERFLOW_DETECTION
-  {
-    stack_t stk;
+  if (setup_stack_overflow_detection() != -1) {
     struct sigaction act;
-    stk.ss_sp = sig_alt_stack;
-    stk.ss_size = SIGSTKSZ;
-    stk.ss_flags = 0;
     SET_SIGACT(act, segv_handler);
     act.sa_flags |= SA_ONSTACK | SA_NODEFER;
     sigemptyset(&act.sa_mask);
-    if (sigaltstack(&stk, NULL) == 0) { sigaction(SIGSEGV, &act, NULL); }
+    sigaction(SIGSEGV, &act, NULL);
   }
 #endif
 }
 
-CAMLexport void caml_setup_stack_overflow_detection(void)
+/* Termination of signal stuff */
+
+#if defined(TARGET_power) || defined(TARGET_s390x) \
+    || defined(HAS_STACK_OVERFLOW_DETECTION)
+static void set_signal_default(int signum)
 {
+  struct sigaction act;
+  sigemptyset(&act.sa_mask);
+  act.sa_handler = SIG_DFL;
+  act.sa_flags = 0;
+  sigaction(signum, &act, NULL);
+}
+#endif
+
+int caml_stop_stack_overflow_detection(void);
+
+void caml_terminate_signals(void)
+{
+#if defined(TARGET_power)
+  set_signal_default(SIGTRAP);
+#endif
+
+#if defined(TARGET_s390x)
+  set_signal_default(SIGFPE);
+#endif
+
 #ifdef HAS_STACK_OVERFLOW_DETECTION
+  set_signal_default(SIGSEGV);
+  caml_stop_stack_overflow_detection();
+#endif
+}
+
+/* Allocate and select an alternate stack for handling signals,
+   especially SIGSEGV signals.
+   Each thread needs its own alternate stack.
+   The alternate stack used to be statically-allocated for the main thread,
+   but this is incompatible with Glibc 2.34 and newer, where SIGSTKSZ
+   may not be a compile-time constant (issue #10250). */
+
+#ifdef HAS_STACK_OVERFLOW_DETECTION
+static int setup_stack_overflow_detection(void)
+{
   stack_t stk;
   stk.ss_sp = malloc(SIGSTKSZ);
+  if (stk.ss_sp == NULL) return -1;
   stk.ss_size = SIGSTKSZ;
   stk.ss_flags = 0;
-  if (stk.ss_sp)
-    sigaltstack(&stk, NULL);
+  if (sigaltstack(&stk, NULL) == -1) {
+    free(stk.ss_sp);
+    return -1;
+  }
+  /* Success (or stack overflow detection not available) */
+  return 0;
+}
+#endif
+
+CAMLexport void caml_setup_stack_overflow_detection(void)
+{
+#ifdef HAS_STACK_OVERFLOW_DETECTION
+  setup_stack_overflow_detection();
+#endif
+}
+
+CAMLexport int caml_stop_stack_overflow_detection(void)
+{
+#ifdef HAS_STACK_OVERFLOW_DETECTION
+  stack_t oldstk, stk;
+  stk.ss_flags = SS_DISABLE;
+  if (sigaltstack(&stk, &oldstk) == -1) return -1;
+  /* If caml_setup_stack_overflow_detection failed, we are not using
+     an alternate signal stack.  SS_DISABLE will be set in oldstk,
+     and there is nothing to free in this case. */
+  if (! (oldstk.ss_flags & SS_DISABLE)) free(oldstk.ss_sp);
+  return 0;
+#else
+  return 0;
 #endif
 }
diff --git a/runtime/startup_nat.c b/runtime/startup_nat.c
index 722f834b1ca..cf8d0278b9f 100644
--- a/runtime/startup_nat.c
+++ b/runtime/startup_nat.c
@@ -92,6 +92,7 @@ void (*caml_termination_hook)(void *) = NULL;
 
 extern value caml_start_program (caml_domain_state*);
 extern void caml_init_signals (void);
+extern void caml_terminate_signals(void);
 #ifdef _WIN32
 extern void caml_win32_overflow_detection (void);
 #endif
@@ -106,6 +107,7 @@ extern void caml_install_invalid_parameter_handler();
 value caml_startup_common(char_os **argv, int pooling)
 {
   char_os * exe_name, * proc_self_exe;
+  value res;
   char tos;
 
   /* Initialize the domain */
@@ -152,10 +154,13 @@ value caml_startup_common(char_os **argv, int pooling)
     exe_name = caml_search_exe_in_path(exe_name);
   caml_sys_init(exe_name, argv);
   if (sigsetjmp(caml_termination_jmpbuf.buf, 0)) {
+    caml_terminate_signals();
     if (caml_termination_hook != NULL) caml_termination_hook(NULL);
     return Val_unit;
   }
-  return caml_start_program(Caml_state);
+  res = caml_start_program(Caml_state);
+  caml_terminate_signals();
+  return res;
 }
 
 value caml_startup_exn(char_os **argv)
diff --git a/runtime/sys.c b/runtime/sys.c
index 909a75f6588..ecc1cf50f29 100644
--- a/runtime/sys.c
+++ b/runtime/sys.c
@@ -112,6 +112,8 @@ static void caml_sys_check_path(value name)
   }
 }
 
+extern void caml_terminate_signals(void);
+
 CAMLprim value caml_sys_exit(value retcode_v)
 {
   int retcode = Int_val(retcode_v);
@@ -159,6 +161,9 @@ CAMLprim value caml_sys_exit(value retcode_v)
     caml_shutdown();
 #ifdef _WIN32
   caml_restore_win32_terminal();
+#endif
+#ifdef NATIVE_CODE
+  caml_terminate_signals();
 #endif
   exit(retcode);
 }
