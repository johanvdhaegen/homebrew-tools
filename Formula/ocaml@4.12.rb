# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
class OcamlAT412 < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "https://caml.inria.fr/pub/distrib/ocaml-4.12/ocaml-4.12.0.tar.xz"
  sha256 "39ee9db8dc1e3eb65473dd81a71fabab7cc253dbd7b85e9f9b5b28271319bec3"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/ocaml@4.12-4.12.0"
    sha256 big_sur:      "bd424dbcc0c2fa70b9a17322b8e2cfdd3a7ce1cb595bbe86a6ddcc563392bd74"
    sha256 x86_64_linux: "6d8924b1fbd9e59f44e2764def9b663f3ddeed74448ef620bfa2ac17470b086d"
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
diff -ur ocaml-4.12.0_orig/configure ocaml-4.12.0/configure
--- ocaml-4.12.0_orig/configure	2021-02-24 03:15:39.000000000 -0800
+++ ocaml-4.12.0/configure	2022-02-05 09:38:01.374574007 -0800
@@ -7627,16 +7627,11 @@
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
@@ -13644,7 +13639,7 @@
 if test x"$enable_shared" != "xno"; then :
   case $host in #(
   *-apple-darwin*) :
-    mksharedlib="$CC -shared -flat_namespace -undefined suppress \
+    mksharedlib="$CC -shared -undefined dynamic_lookup \
                    -Wl,-no_compact_unwind"
       shared_libraries_supported=true ;; #(
   *-*-mingw32) :
