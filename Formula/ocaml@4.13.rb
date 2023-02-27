# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
class OcamlAT413 < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "https://caml.inria.fr/pub/distrib/ocaml-4.13/ocaml-4.13.1.tar.xz"
  sha256 "931d78dfad5bf938800c7a00eb647a27bbfe465a96a8eaae858ecbdb22e6fde8"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 1

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/ocaml@4.13-4.13.1"
    sha256 big_sur:      "eae55ebcab9e5b0ee8fa5560d048a2e1407e2871b64a921fc973f94cd48fd304"
    sha256 x86_64_linux: "53a6d0fc87eb597f5f644f70a9cd9d7481af1539120ab76958ee165a17ca5d21"
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
      --prefix=#{HOMEBREW_PREFIX}/opt/ocaml@4.13
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
diff -ur ocaml-4.13.1_orig/configure ocaml-4.13.1/configure
--- ocaml-4.13.1_orig/configure	2021-09-30 08:40:11.000000000 -0700
+++ ocaml-4.13.1/configure	2022-02-05 14:29:02.761253298 -0800
@@ -7681,16 +7681,11 @@
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
@@ -14030,7 +14025,7 @@
   case $host in #(
   *-apple-darwin*) :
     mksharedlib="$CC -shared \
-                   -flat_namespace -undefined suppress -Wl,-no_compact_unwind \
+                   -undefined dynamic_lookup -Wl,-no_compact_unwind \
                    \$(LDFLAGS)"
       shared_libraries_supported=true ;; #(
   *-*-mingw32) :
