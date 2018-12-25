class Chktex < Formula
  desc "LaTeX semantic checker"
  homepage "https://www.nongnu.org/chktex/"
  url "https://download.savannah.gnu.org/releases/chktex/chktex-1.7.6.tar.gz"
  sha256 "8ac0e5ca213b2012d44c28f9e4feb9783df44750eb0c30a237d81ff58ef34c8d"

  head do
    url "https://git.savannah.nongnu.org/git/chktex.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  if build.head?
    patch :DATA
  else
    patch :p2, :DATA
  end

  def install
    ENV.prepend_path "PATH", "/Library/TeX/texbin"
    cd "chktex" if build.head?
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
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
