class KeepSorted < Formula
  desc "Language-agnostic formatter that sorts lines between two markers"
  homepage "https://github.com/google/keep-sorted"
  url "https://github.com/google/keep-sorted/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "28a8290da4908999712896ed0a94a0e26f290f22b565f290a0782220379a033c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/keep-sorted-0.5.1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "f2eb9f84ba0462d344ddb4bf526688999b8b489d253eb50b22bc1521357b8974"
    sha256 cellar: :any_skip_relocation, ventura:      "2f5e63c54fdd09d6cfc5560742a255a5e4cb3088923c8658be0b2cecc6a06f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1235ae1b2dde9c3fe31dd0ef42b9195e1087c271aecdcea8ff9d17be01a9e262"
  end

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
