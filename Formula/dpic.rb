class Dpic < Formula
  desc "Implementation of the pic language"
  homepage "https://ece.uwaterloo.ca/~aplevich/dpic"
  url "https://ece.uwaterloo.ca/~aplevich/dpic/dpic-2023.06.01.tar.gz"
  sha256 "eec20648732cc44b0ef5bee7bad63a701c52e7d9ab4f76dea4d343422d8bf97e"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*dpic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/dpic-2023.06.01"
    sha256 cellar: :any_skip_relocation, ventura:      "9c7e9ebbf7455d0476fefb40117813b3040454ac3b92426e02bf578bd42c5814"
    sha256 cellar: :any_skip_relocation, monterey:     "ed7b1d78637bac48f2715249d2034c181f609df763f79d466f03b8e710f6093f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ee89347898e45c0ac69026bc2d40a3ff90d8baeaafacadf286350c51bbf1f3d2"
  end

  def install
    ENV.append_path "PATH", "/Library/TeX/texbin"
    system "make", "DESTDIR=/", "PREFIX=#{prefix}", "MANDIR=#{man1}", "DOCDIR=#{doc}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dpic -h 2>&1", 1)
    (testpath/"test.pic").write <<~EOS
      .PS
        arrow "$u$" above
      S: circle rad 10/72.27  # 10 pt
        line right 0.35
      G: box "$G(s)$"
        arrow "$y$" above
        line down G.ht from last arrow then left last arrow.c.x-S.x
        arrow to S.s
        "$-\\;$" below rjust
      .PE
    EOS
    output = shell_output("#{bin}/dpic test.pic")
    assert_match "\\begin{picture}", output
  end
end
