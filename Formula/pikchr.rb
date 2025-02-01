class Pikchr < Formula
  desc "PIC-like markup language for diagrams in technical documentation"
  homepage "https://pikchr.org/"
  url "https://github.com/drhsqlite/pikchr/archive/refs/tags/version-1.0.0.tar.gz"
  sha256 "55b469fbcc0ebc1b72483760a73a9ba90491fb3b03ac56fefeb71316f8007aae"
  license "0BSD"
  head "https://github.com/drhsqlite/pikchr.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/pikchr-1.0.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93866302c68a748b1fc734c1381d44f3c42f18fb3bbd67a51a28b304b0bb1d0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd07147ad75c68cdf46f5832d9ae59350dc2afcad221013b0224c2e6e1efafb5"
    sha256 cellar: :any_skip_relocation, ventura:       "e22779c869b70155eb251da74e103140280d53811d9cc11dd7ac5b516caec9a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e269d9b87d46bc9957a09995f139b3e86a440b7127566e60b9b0453308bd5992"
  end

  def install
    system "make", "all", "CC=#{ENV.cc}"
    bin.install "pikchr"
  end

  test do
    (testpath/"test.pikchr").write <<~EOS
      box
    EOS
    assert_equal "<svg", shell_output("#{bin}/pikchr --svg-only test.pikchr")[0, 4]
  end
end
