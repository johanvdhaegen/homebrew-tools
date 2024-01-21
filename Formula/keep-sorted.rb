class KeepSorted < Formula
  desc "Language-agnostic formatter that sorts lines between two markers"
  homepage "https://github.com/google/keep-sorted"
  url "https://github.com/google/keep-sorted/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "5f9ce09498ce8135749506a19f327332312d6aeb68cd4b30fe290a77b4ab1a4b"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"test.txt").write <<~EOS
      # keep-sorted start
      bravo
      delta
      foxtrot
      alpha
      charlie
      echo
      # keep-sorted end
    EOS
    (testpath/"test_fixed.txt").write <<~EOS
      # keep-sorted start
      alpha
      bravo
      charlie
      delta
      echo
      foxtrot
      # keep-sorted end
    EOS

    system bin/"keep-sorted", "--mode=lint", "test_fixed.txt"
    assert_match "out of order",
                 shell_output("#{bin}/keep-sorted --mode=lint test.txt 2>&1", 1)
    system bin/"keep-sorted", "test.txt"
    assert compare_file(testpath/"test.txt", testpath/"test_fixed.txt")
  end
end
