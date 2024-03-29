# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
class OcamlAT409 < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "https://caml.inria.fr/pub/distrib/ocaml-4.09/ocaml-4.09.1.tar.xz"
  sha256 "9ae2299a318495af57fa6c082347bfd41f46b67b2c0a3fb37a69a84b0b2805ab"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 1

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/ocaml@4.09-4.09.1_1"
    sha256 monterey:     "7a5144a70a474506beaee4c9e97ac318a4a286f74851f545dc08cef5b8a5ca40"
    sha256 x86_64_linux: "6b5a41531379c51ee033b2d61fa672abfccab2d310b3a6fa594e4b995b8b7b03"
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
      --prefix=#{HOMEBREW_PREFIX}/opt/ocaml@4.09
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
diff -ur ocaml-4.09.0_orig/configure ocaml-4.09.0/configure
--- a/configure	2019-09-19 00:23:44.000000000 -0700
+++ b/configure	2021-11-18 06:27:42.836955679 -0800
@@ -7484,16 +7484,11 @@
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
@@ -13286,7 +13281,7 @@
 if test x"$enable_shared" != "xno"; then :
   case $host in #(
   *-apple-darwin*) :
-    mksharedlib="$CC -shared -flat_namespace -undefined suppress \
+    mksharedlib="$CC -shared -undefined dynamic_lookup \
                    -Wl,-no_compact_unwind"
       shared_libraries_supported=true ;; #(
   *-*-mingw32) :


From 8eed2e441222588dc385a98ae8bd6f5820eb0223 Mon Sep 17 00:00:00 2001
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
 runtime/fail_nat.c    |  7 ++++-
 runtime/signals_nat.c | 64 +++++++++++++++++++++++++++++++++++++------
 runtime/startup_nat.c |  7 ++++-
 runtime/sys.c         |  5 ++++
 4 files changed, 72 insertions(+), 11 deletions(-)

diff --git a/runtime/fail_nat.c b/runtime/fail_nat.c
index e1f687d379e..cbf7633ee9e 100644
--- a/runtime/fail_nat.c
+++ b/runtime/fail_nat.c
@@ -31,6 +31,8 @@
 #include "caml/roots.h"
 #include "caml/callback.h"
 
+extern void caml_terminate_signals(void);
+
 /* The globals holding predefined exceptions */
 
 typedef value caml_generated_constant[1];
@@ -60,7 +62,10 @@ char * caml_exception_pointer = NULL;
 void caml_raise(value v)
 {
   Unlock_exn();
-  if (caml_exception_pointer == NULL) caml_fatal_uncaught_exception(v);
+  if (caml_exception_pointer == NULL) {
+    caml_terminate_signals();
+    caml_fatal_uncaught_exception(v);
+  }
 
   while (caml_local_roots != NULL &&
          (char *) caml_local_roots < caml_exception_pointer) {
diff --git a/runtime/signals_nat.c b/runtime/signals_nat.c
index 29a5f49e625..351b575a08e 100644
--- a/runtime/signals_nat.c
+++ b/runtime/signals_nat.c
@@ -182,7 +182,6 @@ DECLARE_SIGNAL_HANDLER(trap_handler)
 #ifdef HAS_STACK_OVERFLOW_DETECTION
 
 static char * system_stack_top;
-static char sig_alt_stack[SIGSTKSZ];
 
 #if defined(SYS_linux)
 /* PR#4746: recent Linux kernels with support for stack randomization
@@ -275,14 +274,61 @@ void caml_init_signals(void)
   {
     stack_t stk;
     struct sigaction act;
-    stk.ss_sp = sig_alt_stack;
-    stk.ss_size = SIGSTKSZ;
-    stk.ss_flags = 0;
-    SET_SIGACT(act, segv_handler);
-    act.sa_flags |= SA_ONSTACK | SA_NODEFER;
-    sigemptyset(&act.sa_mask);
-    system_stack_top = (char *) &act;
-    if (sigaltstack(&stk, NULL) == 0) { sigaction(SIGSEGV, &act, NULL); }
+    /* Allocate and select an alternate stack for handling signals,
+       especially SIGSEGV signals.
+       The alternate stack used to be statically-allocated for the main thread,
+       but this is incompatible with Glibc 2.34 and newer, where SIGSTKSZ
+       may not be a compile-time constant. */
+    stk.ss_sp = malloc(SIGSTKSZ);
+    if (stk.ss_sp != NULL) {
+      stk.ss_size = SIGSTKSZ;
+      stk.ss_flags = 0;
+      SET_SIGACT(act, segv_handler);
+      act.sa_flags |= SA_ONSTACK | SA_NODEFER;
+      sigemptyset(&act.sa_mask);
+      system_stack_top = (char *) &act;
+      if (sigaltstack(&stk, NULL) == 0)
+        sigaction(SIGSEGV, &act, NULL);
+      else
+        free(stk.ss_sp);
+    }
+  }
+#endif
+}
+
+/* Termination of signal stuff */
+
+#if defined(TARGET_power) || defined(TARGET_s390x) \
+    || defined(HAS_STACK_OVERFLOW_DETECTION)
+static void set_signal_default(int signum)
+{
+  struct sigaction act;
+  sigemptyset(&act.sa_mask);
+  act.sa_handler = SIG_DFL;
+  act.sa_flags = 0;
+  sigaction(signum, &act, NULL);
+}
+#endif
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
+#ifdef HAS_STACK_OVERFLOW_DETECTION
+  set_signal_default(SIGSEGV);
+  stack_t oldstk, stk;
+  stk.ss_flags = SS_DISABLE;
+  if (sigaltstack(&stk, &oldstk) == 0) {
+    /* If caml_init_signals failed, we are not using an alternate signal stack.
+       SS_DISABLE will be set in oldstk, and there is nothing to free in this
+       case. */
+    if (! (oldstk.ss_flags & SS_DISABLE)) free(oldstk.ss_sp);
   }
 #endif
 }
diff --git a/runtime/startup_nat.c b/runtime/startup_nat.c
index 7eca5fa5581..f52bec980b6 100644
--- a/runtime/startup_nat.c
+++ b/runtime/startup_nat.c
@@ -92,6 +92,7 @@ void (*caml_termination_hook)(void *) = NULL;
 extern value caml_start_program (void);
 extern void caml_init_ieee_floats (void);
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
 
   /* Determine options */
@@ -153,10 +155,13 @@ value caml_startup_common(char_os **argv, int pooling)
     exe_name = caml_search_exe_in_path(exe_name);
   caml_sys_init(exe_name, argv);
   if (sigsetjmp(caml_termination_jmpbuf.buf, 0)) {
+    caml_terminate_signals();
     if (caml_termination_hook != NULL) caml_termination_hook(NULL);
     return Val_unit;
   }
-  return caml_start_program();
+  res = caml_start_program();
+  caml_terminate_signals();
+  return res;
 }
 
 value caml_startup_exn(char_os **argv)
diff --git a/runtime/sys.c b/runtime/sys.c
index 226d596cdff..9e201354e1e 100644
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
@@ -155,6 +157,9 @@ CAMLprim value caml_sys_exit(value retcode_v)
     caml_shutdown();
 #ifdef _WIN32
   caml_restore_win32_terminal();
+#endif
+#ifdef NATIVE_CODE
+  caml_terminate_signals();
 #endif
   exit(retcode);
 }
