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
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/dpic-2023.02.01"
    sha256 cellar: :any_skip_relocation, monterey:     "1c682caec9adc887cbc02e161085b84f375de05a486bc681632a85f6f8a4c685"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e52ba971c235240a71aaa2b22a370861b06782f80db141d3e8768747fe9e520c"
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
