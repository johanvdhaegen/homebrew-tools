class Dpic < Formula
  desc "Implementation of the pic language"
  homepage "https://ece.uwaterloo.ca/~aplevich/dpic"
  url "https://ece.uwaterloo.ca/~aplevich/dpic/dpic-2022.12.01.tar.gz"
  sha256 "041b9e13bb5c61707c3d5cb77b2686fbf679c4de8a8d048897b0c6655058ee14"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*dpic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/dpic-2022.12.01"
    sha256 cellar: :any_skip_relocation, big_sur:      "203b32ad31247195649b0f4989ffc67e03d4d7e9a1b15ebbc163de8ace15990c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f5572ce3d4d4ce9fb27241b18d7c77e7bf59a01dff801f8f264b870bb8120ecb"
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
        "$-\;$" below rjust
      .PE
    EOS
    output = shell_output("#{bin}/dpic test.pic")
    assert_match "\\begin{picture}", output
  end
end
