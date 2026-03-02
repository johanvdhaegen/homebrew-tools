class Chktex < Formula
  desc "LaTeX semantic checker"
  homepage "https://www.nongnu.org/chktex/"
  license "GPL-2.0-or-later"

  stable do
    url "https://download.savannah.gnu.org/releases/chktex/chktex-1.7.10.tar.gz"
    sha256 "cea81a1cde2f151db2b5d2adf2271becfd3c0c1f40eca5cf45b52beeb4a636f9"
    patch :p2, :DATA
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/chktex-1.7.10"
    sha256                               arm64_tahoe:   "044e4ba07db81a9773be0c86159f5dae13a3262b2edfe3be746e4ebc8a0849b4"
    sha256                               arm64_sequoia: "1ca44ea3e349605ed44a8855fd50c57c543f1064d8c34d43b48ada052c23c7ed"
    sha256                               arm64_linux:   "f654cd70e31ae36be6026bd09e9ce37b8e0d6d7e5d0a79ef2871a76eed48fbae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e89447bbf3c4a67998f84c209721211a2db41e30a0681a7228c96314e3c0f15"
  end

  head do
    url "https://git.savannah.nongnu.org/git/chktex.git", branch: "master"
    patch :DATA
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pcre"

  def install
    ENV.prepend_path "PATH", "/Library/TeX/texbin"
    args = %W[
      --prefix=#{prefix}
      --enable-pcre
    ]

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
