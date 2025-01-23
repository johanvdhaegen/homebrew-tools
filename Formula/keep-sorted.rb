class KeepSorted < Formula
  desc "Language-agnostic formatter that sorts lines between two markers"
  homepage "https://github.com/google/keep-sorted"
  url "https://github.com/google/keep-sorted/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "28a8290da4908999712896ed0a94a0e26f290f22b565f290a0782220379a033c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/keep-sorted-0.6.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "126f83ac460d98190241cd31b0df4b2399d5ffcde0e10ac96abfdf851b9a4551"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "843c571f1b6e4283604981d543eb373a513c11f51d8b5c1dd8a974851c9b04da"
    sha256 cellar: :any_skip_relocation, ventura:       "fbeeb4db3f69cc6bb179d902bc5c897a624d377148895158665af6a4d16d3f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa08dcef714ecdd91efbdd5766f9297b5c00f81ac9304bd2dd3013251f71bb5b"
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
