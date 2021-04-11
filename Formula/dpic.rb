class Dpic < Formula
  desc "Implementation of the pic language"
  homepage "https://ece.uwaterloo.ca/~aplevich/dpic"
  url "https://ece.uwaterloo.ca/~aplevich/dpic/dpic-2021.04.10.tar.gz"
  sha256 "53cf301ddeec784ec2c452db7a3b600a13086a316f3e16b30190a41d30306e54"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*dpic[._-]v?(\d+(?:\.\d+)+)\.tar\.gz/i)
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
