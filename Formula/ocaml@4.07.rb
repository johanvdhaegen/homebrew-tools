# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
class OcamlAT407 < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "https://caml.inria.fr/pub/distrib/ocaml-4.07/ocaml-4.07.1.tar.xz"
  sha256 "dfe48b1da31da9c82d77612582fae74c80e8d1ac650e1c24f5ac9059e48307b8"
  license "LGPL-2.1"

  pour_bottle? do
    # The ocaml compilers embed prefix information in weird ways that the default
    # brew detection doesn't find, and so needs to be explicitly blacklisted.
    reason "The bottle needs to be installed into /usr/local."
    satisfy { HOMEBREW_PREFIX.to_s == "/usr/local" }
  end

  keg_only :versioned_formula

  patch :DATA

  def install
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores

    # the ./configure in this package is NOT a GNU autoconf script!
    args = [
      "-prefix",
      "#{HOMEBREW_PREFIX}/opt/ocaml@4.07",
      "-with-debug-runtime",
      "-mandir",
      man.to_s,
      "-no-graph",
    ]
    system "./configure", *args
    system "make", "world.opt"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("echo 'let x = 1 ;;' | #{bin}/ocaml 2>&1")
    assert_match "val x : int = 1", output
    assert_match HOMEBREW_PREFIX.to_s, shell_output("#{bin}/ocamlc -where")
  end
end
__END__
diff --git a/configure b/configure
--- a/configure
+++ b/configure
@@ -454,8 +454,11 @@ case "$ocamlversion" in
        *) gcc_warnings="-Wall";;
 esac

+origcc="$cc"
+
 case "$ccfamily" in
   clang-*)
+    cc="$cc -Wno-implicit-function-declaration";
     common_cflags="-O2 -fno-strict-aliasing -fwrapv";
     internal_cflags="$gcc_warnings";;
   gcc-[012]-*)
@@ -2054,7 +2057,7 @@ fi

 cclibs="$cclibs $mathlib"

-config CC "$cc"
+config CC "$origcc"
 config CPP "$cpp"
 config CFLAGS "$common_cflags $internal_cflags"
 config CPPFLAGS "$common_cppflags $internal_cppflags"
