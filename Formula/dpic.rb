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
