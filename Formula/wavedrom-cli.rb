require "language/node"

class WavedromCli < Formula
  desc "Digital timing diagram (waveform) rendering command-line interface"
  homepage "https://github.com/wavedrom/cli"
  url "https://registry.npmjs.org/wavedrom-cli/-/wavedrom-cli-3.2.0.tgz"
  sha256 "38098ac16eb4a7cbf8db4535a0cc9911819a8b8cc9255604c58d912d29fcd2d6"
  license "MIT"
  revision 2

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/wavedrom-cli-3.2.0_2"
    sha256 cellar: :any,                 arm64_sonoma: "7a41ddc091f1fa1bf05cb5119881fcb89e02378a7e17181feb265a2f43aaf600"
    sha256 cellar: :any,                 ventura:      "3df423fe94efa9d9ddce3b150303eba70b0822605c91988410fc45e5c278a8db"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e10b0a684376115b849b35779726d9a4f1d47e7efea4e14beea5f014fe81554e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.json").write <<~EOS
      { signal: [{ name: "Alfa", wave: "01.zx=ud.23.456789" }] }
    EOS
    system "#{bin}/wavedrom-cli", "-i", "test.json", "-s", "test.svg"
    assert_match(/^<svg /, (testpath/"test.svg").read)
  end
end
