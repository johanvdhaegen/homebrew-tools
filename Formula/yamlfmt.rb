class Yamlfmt < Formula
  desc "Extensible command-line tool or library to format yaml files"
  homepage "https://github.com/google/yamlfmt"
  url "https://github.com/google/yamlfmt.git",
      tag:      "v0.9.0",
      revision: "3a03733ec9d76beb574b0aeeae44b3e06c87ef04"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/yamlfmt-0.9.0"
    sha256 cellar: :any_skip_relocation, monterey:     "cda55aa0f679e2fb92baa55e1fb6ddabd80e8dc3cb8a913caa0512451cd923ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5e6e7a69bdbf162b56afd25742b09d8ba615481f83c806042bc66064c57c7dc3"
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
