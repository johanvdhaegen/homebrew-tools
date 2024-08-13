require "language/node"

class WavedromCli < Formula
  desc "Digital timing diagram (waveform) rendering command-line interface"
  homepage "https://github.com/wavedrom/cli"
  url "https://registry.npmjs.org/wavedrom-cli/-/wavedrom-cli-3.2.0.tgz"
  sha256 "38098ac16eb4a7cbf8db4535a0cc9911819a8b8cc9255604c58d912d29fcd2d6"
  license "MIT"
  revision 1

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/wavedrom-cli-3.2.0_1"
    sha256 cellar: :any, arm64_sonoma: "0dfd86504977a81568d2e01d4c1b8d318a02902fc160230983ee111a09ada383"
    sha256 cellar: :any, ventura:      "a1181137fb1448ce64a46bd2c0de5e752d41b453a8ff69a540dafcbf323ec73b"
  end

  depends_on :macos # TODO: fix build failure on linux
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/#{name}/node_modules"
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    if OS.linux?
      %w[@resvg/resvg-js].each do |mod|
        node_modules.glob("#{mod}-linux-#{arch}-musl/*.linux-#{arch}-musl.node")
                    .map(&:unlink)
                    .empty? && raise("Unable to find #{mod} musl library to delete.")
      end
    end
  end

  test do
    (testpath/"test.json").write <<~EOS
      { signal: [{ name: "Alfa", wave: "01.zx=ud.23.456789" }] }
    EOS
    system "#{bin}/wavedrom-cli", "-i", "test.json", "-s", "test.svg"
    assert_match(/^<svg /, (testpath/"test.svg").read)
  end
end
