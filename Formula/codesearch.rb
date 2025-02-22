class Codesearch < Formula
  desc "Fast, indexed regexp search over large file trees"
  homepage "https://github.com/google/codesearch/"
  url "https://github.com/google/codesearch.git",
      tag: "v1.2.0"
  license "BSD-3-Clause"
  revision 1

  head "https://github.com/google/codesearch.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/codesearch-1.2.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "079cfb2c2d379722a9aea4355bc5f1181f6d7c93b442e9e31dd041c60f6a5588"
    sha256 cellar: :any_skip_relocation, ventura:      "0f599cb9fe778af83a46b90f53c9957ccb9f88b2339e95bf31967d66140f1139"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fadd090d19808062d80acbf9fda1c497e2e3401e8c5aa3e4c8f290bb34b13fb1"
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
