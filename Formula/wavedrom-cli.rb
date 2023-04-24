require "language/node"

class WavedromCli < Formula
  desc "Digital timing diagram (waveform) rendering command-line interface"
  homepage "https://github.com/wavedrom/cli"
  url "https://registry.npmjs.org/wavedrom-cli/-/wavedrom-cli-3.1.1.tgz"
  sha256 "7f627331241cb5560164885fc48db4ae7d1ccb8cea8f12ca00e4eb3ae07e21fa"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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
