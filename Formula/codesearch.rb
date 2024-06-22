class Codesearch < Formula
  desc "Fast, indexed regexp search over large file trees"
  homepage "https://github.com/google/codesearch/"
  url "https://github.com/google/codesearch.git",
      tag: "v1.2.0"
  license "BSD-3-Clause"

  head "https://github.com/google/codesearch.git", branch: "master"

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
    assert_predicate testpath/".csearchindex", :exist?,
                     "Failed to create codesearch index"
    assert_match(/test\.py:def foo/, shell_output("#{bin}/csearch foo"))
  end
end
