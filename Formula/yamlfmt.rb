class Yamlfmt < Formula
  desc "Extensible command-line tool or library to format yaml files"
  homepage "https://github.com/google/yamlfmt"
  url "https://github.com/google/yamlfmt.git",
      tag:      "v0.6.0",
      revision: "811c65058125f094d4d5d886253f9a3c92b5a81d"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/yamlfmt-0.6.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "2519dbfa26e22d8e5817b19d1b8031b71149f0877cea1bf8f7fea8cb91298498"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "79a07960fd4cd8858093cf30c38734725a0902158aa9762a0b8258f0c54ae4d6"
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
