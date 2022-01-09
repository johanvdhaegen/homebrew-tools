class Inkscape < Formula
  include Language::Python::Virtualenv

  desc "Professional vector graphics editor"
  homepage "https://inkscape.org/"
  url "https://gitlab.com/inkscape/inkscape.git",
      tag:      "INKSCAPE_1_1_1",
      revision: "3bf5ae0d25c673abe152dedf4789a2d6f0cc60ff"
  head "https://gitlab.com/inkscape/inkscape.git", branch: "master"

  depends_on "automake" => :build
  depends_on "boost-build" => :build
  depends_on "cmake" => :build
  depends_on "double-conversion" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "aspell"
  depends_on "bdw-gc"
  depends_on "boost"
  depends_on "cairomm"
  depends_on "fontconfig"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glibmm"
  depends_on "graphicsmagick"
  depends_on "gsl"
  depends_on "gtk+3"
  depends_on "gtk-mac-integration"
  depends_on "gtkmm3"
  depends_on "gtkspell3"
  depends_on "harfbuzz"
  depends_on "hicolor-icon-theme"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libsigc++@2"
  depends_on "libsoup@2"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "little-cms"
  depends_on "numpy"
  depends_on "pango"
  depends_on "poppler"
  depends_on "potrace"
  depends_on "pygobject3"
  depends_on "python@3.9"
  depends_on "readline"
  depends_on "jemalloc" => :optional
  depends_on "libcdr" => :optional
  depends_on "libomp" => :optional
  depends_on "libvisio" => :optional
  depends_on "libwpg" => :optional

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/fe/4c/a4dbb4e389f75e69dbfb623462dfe0d0e652107a95481d40084830d29b37/lxml-4.6.4.tar.gz"
    sha256 "daf9bd1fee31f1c7a5928b3e1059e09a8d683ea58fb3ffc773b6c88cb8d1399c"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/a1/69/daeee6d8f22c997e522cdbeb59641c4d31ab120aba0f2c799500f7456b7e/beautifulsoup4-4.10.0.tar.gz"
    sha256 "c23ad23c521d818955a4151a67d81580319d4bf548d3d49f4223ae041ff98891"
  end

  resource "cachecontrol" do
    url "https://files.pythonhosted.org/packages/d0/74/3748ee1144234a525d84c4905002a5f39795d265bcdecca74142a8df5206/CacheControl-0.12.10.tar.gz"
    sha256 "d8aca75b82eec92d84b5d6eb8c8f66ea16f09d2adb09dbca27fe2d5fc8d3732d"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/70/54/37630f6eb2c214cdee2ae56b7287394c8aa2f3bafb8b4eb8c3791aae7a14/cssselect-1.1.0.tar.gz"
    sha256 "f95f8dedd925fd8f54edb3d2dfb44c190d9d18512377d3c1e2388d16126879bc"
  end

  resource "gtkme" do
    url "https://files.pythonhosted.org/packages/cc/75/762ace4771cc23a350e6fe26edc85a062e935b359eaeb63bc6c1192dbb28/gtkme-1.5.3.tar.gz"
    sha256 "3485209db7dc1e36cf7ec1f7085d81cb0a3ca30addb22d70a83a0cc4e6bed94e"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "charset_normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "scour" do
    url "https://files.pythonhosted.org/packages/75/19/f519ef8aa2f379935a44212c5744e2b3a46173bf04e0110fb7f4af4028c9/scour-0.38.2.tar.gz"
    sha256 "6881ec26660c130c5ecd996ac6f6b03939dd574198f50773f2508b81a68e0daf"
  end

  resource "inkscape-extension-manager" do
    url "https://files.pythonhosted.org/packages/ed/d1/c6048bc503bfd0e2df7881493eeeeb5eab340db4419a99923d8cb6d7866e/inkscape-extensions-manager-0.9.9.tar.gz"
    sha256 "1f42e66d8c245b4e6a6706e03ab541c7a6b72509dc37751a045da46dd1370fc8"
  end

  patch :DATA

  def install
    ENV.cxx11
    ENV.append "LDFLAGS", "-liconv"

    libomp = Formula["libomp"]
    args = []
    if build.with?("openmp")
      args << "-DOpenMP_C_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_CXX_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
      args << "-DOpenMP_CXX_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.dylib"
    else
      args << "-DWITH_OPENMP=OFF"
    end
    args << "-DWITH_DBUS=OFF"
    args << ("-DWITH_JEMALLOC=" + (build.with?("jemalloc") ? "ON" : "OFF"))
    args << "-DWITH_LIBWPG=OFF" if build.without? "libwpg"
    args << "-DWITH_LIBVISIO=OFF" if build.without? "libvisio"
    args << "-DWITH_LIBCDR=OFF" if build.without? "libcdr"

    # install under libexec
    cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] }
    cmake_args << "-DCMAKE_INSTALL_PREFIX=#{libexec}"
    mkdir buildpath/"build" do
      system "cmake", "..", *cmake_args, *args
      system "make"
      system "make", "install"
    end

    # create wrapper scripts for inkscape binaries
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PATH: "#{libexec}/bin:$PATH")

    # set up python virtualenv for inkscape extensions
    pyver = Language::Python.major_minor_version("python3")
    ENV.prepend_create_path "PYTHONPATH",
                            libexec/"lib/python#{pyver}/site-packages"
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    # move extension manager script to site packages
    mv libexec/"manage_extensions.inx",
       libexec/"lib/python#{pyver}/site-packages"
    mv libexec/"manage_extensions.py",
       libexec/"lib/python#{pyver}/site-packages"
  end

  test do
    system "#{bin}/inkscape", "--debug-info"
  end
end

__END__
diff --git a/CMakeScripts/DefineDependsandFlags.cmake b/CMakeScripts/DefineDependsandFlags.cmake
--- a/CMakeScripts/DefineDependsandFlags.cmake
+++ b/CMakeScripts/DefineDependsandFlags.cmake
@@ -369,11 +369,11 @@ list(APPEND INKSCAPE_LIBS ${SIGC++_LDFLAGS})
 list(APPEND INKSCAPE_CXX_FLAGS ${SIGC++_CFLAGS_OTHER})
 
 # Some linkers, like gold, don't find symbols recursively. So we have to link against X11 explicitly
-find_package(X11)
-if(X11_FOUND)
-    list(APPEND INKSCAPE_INCS_SYS ${X11_INCLUDE_DIRS})
-    list(APPEND INKSCAPE_LIBS ${X11_LIBRARIES})
-endif(X11_FOUND)
+#find_package(X11)
+#if(X11_FOUND)
+#    list(APPEND INKSCAPE_INCS_SYS ${X11_INCLUDE_DIRS})
+#    list(APPEND INKSCAPE_LIBS ${X11_LIBRARIES})
+#endif(X11_FOUND)
 
 # end Dependencies
 
From ebc4de4bfe34d6c5f2e27da47f5d62e4de0394fd Mon Sep 17 00:00:00 2001
From: Evangelos Foutras <evangelos@foutrelis.com>
Date: Mon, 1 Nov 2021 21:45:38 +0200
Subject: [PATCH] Fix build with poppler 21.11.0

GfxFont::tag is now of type std::string instead of GooString *.
(cherry picked from commit 5724c21b9cb7b6176a7b36ca24068b148c817e82)
---
 src/extension/internal/pdfinput/pdf-parser.cpp | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/extension/internal/pdfinput/pdf-parser.cpp b/src/extension/internal/pdfinput/pdf-parser.cpp
index e3d04d544b..feecefa043 100644
--- a/src/extension/internal/pdfinput/pdf-parser.cpp
+++ b/src/extension/internal/pdfinput/pdf-parser.cpp
@@ -2169,7 +2169,11 @@ void PdfParser::opSetFont(Object args[], int /*numArgs*/)
   }
   if (printCommands) {
     printf("  font: tag=%s name='%s' %g\n",
+#if POPPLER_CHECK_VERSION(21,11,0)
+	   font->getTag().c_str(),
+#else
 	   font->getTag()->getCString(),
+#endif
 	   font->getName() ? font->getName()->getCString() : "???",
 	   args[1].getNum());
     fflush(stdout);
-- 
GitLab

