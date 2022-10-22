class Chktex < Formula
  desc "LaTeX semantic checker"
  homepage "https://www.nongnu.org/chktex/"
  license "GPL-2.0-or-later"

  stable do
    url "https://download.savannah.gnu.org/releases/chktex/chktex-1.7.8.tar.gz"
    sha256 "5286f7844f0771ac0711c7313cf5e0421ed509dc626f9b43b4f4257fb1591ea8"
    patch :p2, :DATA
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/chktex-1.7.8"
    sha256                               big_sur:      "eeb04516067bf5e2d7fecd7c7d8b5a7363cb33f91509b5cc7e836fda9bd6abc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2c91f0639ddd85fa232907b4117e0253d99914b73da8900eab8360638c596c2b"
  end

  head do
    url "https://git.savannah.nongnu.org/git/chktex.git", branch: "master"
    patch :DATA
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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
