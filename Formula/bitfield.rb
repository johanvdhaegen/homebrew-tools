class Bitfield < Formula
  desc "Renderer for bitfield diagrams"
  homepage "https://github.com/wavedrom/bitfield"
  url "https://registry.npmjs.org/bit-field/-/bit-field-1.9.0.tgz"
  sha256 "e90346a3c7d3b6d03b55b86c3ffa5c51ca00880212433943b1f12906b8dcc194"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args, "--dev"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.json").write <<~EOS
      [
          {"name": "IPO",   "bits": 8, "attr": "RO"},
          {                  "bits": 7},
          {"name": "BRK",   "bits": 5, "attr": "RW", "type": 4},
          {"name": "CPK",   "bits": 3, "attr": 2, "rotate": -45},
          {"name": "BPS",   "bits": 3, "attr": "42"},
          {"name": "Clear", "bits": 3},
          {"bits": 3}
      ]
    EOS

    assert_match version.to_s, shell_output("#{bin}/bitfield --version")
    assert_match(/^<svg /,
                 shell_output("#{bin}/bitfield --input #{testpath}/test.json"))
  end
end
