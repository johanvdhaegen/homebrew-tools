class Yamlfmt < Formula
  desc "Extensible command-line tool or library to format yaml files"
  homepage "https://github.com/google/yamlfmt"
  url "https://github.com/google/yamlfmt.git",
      tag:      "v0.5.0",
      revision: "f0be560f35be8966cbcc84451d11f025973df8a6"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/yamlfmt-0.5.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "757d32d87026e6aa74a1eb1f8d838d012b81f9383415facb56c2153121c9f6ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ebb6babf730e703f43fd60ad849a8b06aa3dd8652d803973d6d2535cb676007e"
  end

  head do
    url "https://github.com/google/yamlfmt.git", branch: "main"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yamlfmt"
  end

  test do
    (testpath/"test.yml").write <<~EOS
      foo:
          bar
    EOS
    system bin/"yamlfmt", "test.yml"
    assert_equal "foo: bar", (testpath/"test.yml").read.chomp
  end
end
