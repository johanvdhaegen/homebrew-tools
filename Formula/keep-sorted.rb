class KeepSorted < Formula
  desc "Language-agnostic formatter that sorts lines between two markers"
  homepage "https://github.com/google/keep-sorted"
  url "https://github.com/google/keep-sorted/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "8eee061af908fd971911118975e4a2870afff385b3aea9948cc9b221849a9436"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/keep-sorted-0.5.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "303c8233b5c24bfccc9cc7d13b283ce68ec8dbe6b041adebfb72e04d2242c9fa"
    sha256 cellar: :any_skip_relocation, ventura:      "590b2fbc7d66c65e205612e4a249e4e0437b353cd951132556c4f5906518a658"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "68fb6a9be4ff91704b76bd7b8ddc183411d40d0f0b6aed689fd7a52bde12e274"
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
