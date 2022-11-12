class Yamlfmt < Formula
  desc "Extensible command-line tool or library to format yaml files"
  homepage "https://github.com/google/yamlfmt"
  url "https://github.com/google/yamlfmt.git",
      tag:      "v0.6.0",
      revision: "811c65058125f094d4d5d886253f9a3c92b5a81d"
  license "Apache-2.0"

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
