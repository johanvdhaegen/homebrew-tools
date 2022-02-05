# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
class OcamlAT411 < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "https://caml.inria.fr/pub/distrib/ocaml-4.11/ocaml-4.11.2.tar.xz"
  sha256 "3f51049e3da05fa1401c964ae385e9f5f7ac45045556cf363fc78d3de7cb7cd4"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/ocaml@4.11-4.11.2"
    sha256 big_sur:      "7c45848c646d0e04132047d89cdd4b58b9e913cdc6a75dab447ea7b7b00c69fe"
    sha256 x86_64_linux: "99bcb9ed9c5b9f75af05bf505f6cd499391163bbe7b98b3ee710cf9efcaf3cb2"
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
      --prefix=#{HOMEBREW_PREFIX}/opt/ocaml@4.11
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
diff -ur ocaml-4.11.2_orig/configure ocaml-4.11.2/configure
--- a/configure	2021-02-24 01:33:54.000000000 -0800
+++ b/configure	2022-01-22 23:52:32.300644571 -0800
@@ -7606,16 +7606,11 @@
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
@@ -13481,7 +13476,7 @@
 if test x"$enable_shared" != "xno"; then :
   case $host in #(
   *-apple-darwin*) :
-    mksharedlib="$CC -shared -flat_namespace -undefined suppress \
+    mksharedlib="$CC -shared -undefined dynamic_lookup \
                    -Wl,-no_compact_unwind"
       shared_libraries_supported=true ;; #(
   *-*-mingw32) :
