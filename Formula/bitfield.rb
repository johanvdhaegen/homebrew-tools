class Bitfield < Formula
  desc "Renderer for bitfield diagrams"
  homepage "https://github.com/wavedrom/bitfield"
  url "https://registry.npmjs.org/bit-field/-/bit-field-1.9.0.tgz"
  sha256 "e90346a3c7d3b6d03b55b86c3ffa5c51ca00880212433943b1f12906b8dcc194"
  license "MIT"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/bitfield-1.9.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f2e1ae7b9c9d1181c5cd204d04c0f1df78fff23e347868931352f2b903b86d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d953de523ff1141c75300d771565f4be1b93e31ccc7a035835a9104222fd266"
    sha256 cellar: :any_skip_relocation, ventura:       "5c6233a3a21b13917ea68fe981030082ac2165c93471687b7fe64b898f9eb17d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c58568431d8853c96e91ca2e41e79227919036ca50f645874398c5c596269f54"
  end

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
