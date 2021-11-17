class Inkscape < Formula
  include Language::Python::Virtualenv

  desc "Professional vector graphics editor"
  homepage "https://inkscape.org/"
  url "https://gitlab.com/inkscape/inkscape.git",
      tag:      "INKSCAPE_1_1_1",
      revision: "3bf5ae0d25c673abe152dedf4789a2d6f0cc60ff"
  head "https://gitlab.com/inkscape/inkscape.git", branch: "master"

  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "boost-build" => :build
  depends_on "cmake" => :build
  depends_on "double-conversion" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "aspell"
  depends_on "bdw-gc"
  depends_on "cairomm"
  depends_on "fontconfig"
  depends_on "gdk-pixbuf"
  depends_on "gdl"
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
  depends_on "libsoup"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "little-cms"
  depends_on "numpy"
  depends_on "pango"
  depends_on "poppler"
  depends_on "potrace"
  depends_on "python@3.8"
  depends_on "jemalloc" => :optional
  depends_on "libcdr" => :optional
  depends_on "libomp" => :optional
  depends_on "libvisio" => :optional
  depends_on "libwpg" => :optional

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/39/2b/0a66d5436f237aff76b91e68b4d8c041d145ad0a2cdeefe2c42f76ba2857/lxml-4.5.0.tar.gz"
    sha256 "8620ce80f50d023d414183bf90cc2576c2837b88e00bea3f33ad2630133bbb60"
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
    rm libexec/"lib/python#{pyver}/no-global-site-packages.txt"
  end

  test do
    system "#{bin}/inkscape", "-x"
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

