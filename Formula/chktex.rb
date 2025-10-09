class Chktex < Formula
  desc "LaTeX semantic checker"
  homepage "https://www.nongnu.org/chktex/"
  license "GPL-2.0-or-later"
  revision 1

  stable do
    url "https://download.savannah.gnu.org/releases/chktex/chktex-1.7.9.tar.gz"
    sha256 "df6ee31632a4f4a8e18849b804657e27e3d96deb3f237edbd25656415eb31195"
    patch :p2, :DATA
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/chktex-1.7.9"
    sha256 arm64_sonoma: "a61466eab12726a3be5b40f8a892b27935300259b07156bfc979757104c2d147"
    sha256 ventura:      "0fe5525448342749762a167d1955a0e35474d62fcbaae67b664c409f80dd1743"
  end

  head do
    url "https://git.savannah.nongnu.org/git/chktex.git", branch: "master"
    patch :DATA
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :macos # TODO: fix build failure on linux
  depends_on "pcre" => :recommended

  def install
    ENV.prepend_path "PATH", "/Library/TeX/texbin"
    args = %W[
      --prefix=#{prefix}
    ]
    args << "--#{build.with?("pcre")?"enable":"disable"}-pcre"

    cd "chktex" if build.head?
    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \documentclass{article}
      \begin{document}
      Hello World!
      \end{document}
    EOS
    system bin/"chktex", "test.tex"
  end
end

__END__
--- a/chktex/ChkTeX.tex.in  2016-02-02 21:18:36.000000000 -0800
+++ b/chktex/ChkTeX.tex.in  2018-12-25 06:16:16.000000000 -0800
@@ -37,6 +37,7 @@

 \documentclass[a4paper]{article}
 %latex
+\usepackage[latin1]{inputenc}
 \usepackage{array, tabularx, verbatim, multicol}
 \usepackage[T1]{fontenc}
 \nonfrenchspacing
--- a/chktex/Makefile.in  2022-10-17 17:17:58.000000000 -0700
+++ b/chktex/Makefile.in  2022-10-21 16:21:34.812499668 -0700
@@ -161,7 +161,7 @@
 chktex: $(OBJS)
 	$(CC) $(LDFLAGS) -o chktex $(OBJS) $(LIBS)
 
-install: chktex ChkTeX.dvi
+install: chktex chktexrc
 	$(MKDIR_P) $(DESTDIR)$(bindir)
 	for program in chktex $(BUILT_SCRIPTS); do \
 		$(INSTALL_PROGRAM) $$program $(DESTDIR)$(bindir); \
--- a/chktex/tests/run-tests.sh  2022-10-17 17:17:58.000000000 -0700
+++ b/chktex/tests/run-tests.sh  2022-10-21 18:57:28.113400011 -0700
@@ -132,6 +132,6 @@
 # Command line options
 echo "Checking command line RC settings..."
 (${builddir}/chktex -d 4 -STabSize=7 </dev/null 2>&1 \
-     | grep -A1 TabSize | grep -E '\t7$' >/dev/null) \
+     | grep -A1 TabSize | grep -E '[[:space:]]7$' >/dev/null) \
     || (echo Setting TabSize from command line failed; exit 1)
 echo ">>> OK!"
