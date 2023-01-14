class Yamlfmt < Formula
  desc "Extensible command-line tool or library to format yaml files"
  homepage "https://github.com/google/yamlfmt"
  url "https://github.com/google/yamlfmt.git",
      tag:      "v0.7.1",
      revision: "e1c97a1b3ffd0f3cfb37685b6a046d5f6963f2d8"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/yamlfmt-0.7.1"
    sha256 cellar: :any_skip_relocation, monterey:     "0954005607b55a3a2caac276f6c7daa4c9104557012f3b02699a26d86195f0ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1cdb963bb8c71c78154ddfe3b1eefe4ac01b13e12fbfbc1493cb97999fb9ca39"
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
