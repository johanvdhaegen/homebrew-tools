# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
class OcamlAT405 < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "https://caml.inria.fr/pub/distrib/ocaml-4.05/ocaml-4.05.0.tar.xz"
  sha256 "04a527ba14b4d7d1b2ea7b2ae21aefecfa8d304399db94f35a96df1459e02ef9"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }

  # The ocaml compilers embed prefix information in weird ways that the default
  # brew detection doesn't find, and so needs to be explicitly blocked.
  pour_bottle? only_if: :default_prefix

  keg_only :versioned_formula

  patch :DATA

  def install
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores

    # the ./configure in this package is NOT a GNU autoconf script!
    args = [
      "-prefix",
      "#{HOMEBREW_PREFIX}/opt/ocaml@4.05",
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
@@ -382,8 +382,11 @@
        *) gcc_warnings="-Wall";;
 esac

+origcc="$cc"
+
 case "$ccfamily" in
   clang-*)
+    bytecc="$cc -Wno-implicit-function-declaration";
     bytecccompopts="-O2 -fno-strict-aliasing -fwrapv";
     byteccprivatecompopts="$gcc_warnings";;
   gcc-[012]-*)
@@ -2006,7 +2009,7 @@

 cclibs="$cclibs $mathlib"

-echo "BYTECC=$bytecc $bytecccompopts" >> Makefile
+echo "BYTECC=$origcc $bytecccompopts" >> Makefile
 echo "BYTECODE_C_COMPILER=$bytecc $bytecccompopts $sharedcccompopts" \
   >> Makefile
 echo "BYTECCCOMPOPTS=$byteccprivatecompopts" >> Makefile
