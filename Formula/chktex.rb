class Chktex < Formula
  desc "LaTeX semantic checker"
  homepage "http://www.nongnu.org/chktex/"
  url "https://download.savannah.gnu.org/releases/chktex/chktex-1.7.6.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/chktex/chktex_1.7.6.orig.tar.gz"
  sha256 "8ac0e5ca213b2012d44c28f9e4feb9783df44750eb0c30a237d81ff58ef34c8d"

  head do
    url "svn://svn.sv.gnu.org/chktex/trunk/chktex"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on :tex

  def install
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
