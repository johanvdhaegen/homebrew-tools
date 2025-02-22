class Codesearch < Formula
  desc "Fast, indexed regexp search over large file trees"
  homepage "https://github.com/google/codesearch/"
  url "https://github.com/google/codesearch.git",
      tag: "v1.2.0"
  license "BSD-3-Clause"
  revision 1

  head "https://github.com/google/codesearch.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/codesearch-1.2.0_1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aa563d7a1ee14c8c3146fbe4d0ef9e0bb9e4c6adf35bd489a00e83f8e7b85df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba2d1cd895b8ea469fc93a96dd66d28fcb73f4851bc01f72ee3739db6d426f85"
    sha256 cellar: :any_skip_relocation, ventura:       "e35e6fab7892b9491a1c5dcb2fe21f726362833764ef2c61be794119a78dc74d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1667a621d8b9b2bf3e6e1fcc69bead406dcbfece4b5b48f1cd894e156c18fad"
  end

  depends_on "go" => :build

  def install
    %w[cindex csearch cgrep].each do |cmd|
      system "go", "build", "-o", "bin/#{cmd}", "cmd/#{cmd}/#{cmd}.go"
    end
    bin.install Dir["bin/*"]
  end

  test do
    (testpath/"test.py").write <<~EOS
      def foo():
        pass
    EOS
    ENV["CSEARCHINDEX"]= testpath/".csearchindex"
    system "#{bin}/cindex", "."
    assert_path_exists testpath/".csearchindex",
                       "Failed to create codesearch index"
    assert_match(/test\.py:def foo/, shell_output("#{bin}/csearch foo"))
  end
end
