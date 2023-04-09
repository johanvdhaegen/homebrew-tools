class Yamlfmt < Formula
  desc "Extensible command-line tool or library to format yaml files"
  homepage "https://github.com/google/yamlfmt"
  url "https://github.com/google/yamlfmt.git",
      tag:      "v0.9.0",
      revision: "3a03733ec9d76beb574b0aeeae44b3e06c87ef04"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/yamlfmt-0.8.0"
    sha256 cellar: :any_skip_relocation, monterey:     "d8603121a870344cd73141b9465b6331a34836f147bdb6b1aa74036ddbe07870"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1310f0109da46078a0cbbbbba27926fcf8ebe78e794a272220d4f867531328d6"
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
