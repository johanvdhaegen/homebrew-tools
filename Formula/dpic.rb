class Dpic < Formula
  desc "Implementation of the pic language"
  homepage "https://ece.uwaterloo.ca/~aplevich/dpic"
  url "https://ece.uwaterloo.ca/~aplevich/dpic/dpic-2024.01.01.tar.gz"
  sha256 "161901ac9af86d7305512ba1b5649404fb4c803a0fab062627cc3c5895ad872f"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*dpic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/dpic-2024.01.01_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "7de6c367ea68b9eb0f049a380f8cd25bc09c351702ca6e3e49033fd3046ce2e0"
    sha256 cellar: :any_skip_relocation, ventura:      "0980f9766dba9e59ebf7e08e1c01773676b41b0bfc976a14a5f6476e62365bd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7424a8af05d4202f6eae178412e02725ea6eefd5ecda040f9e9f4ebdeeda2a1c"
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
