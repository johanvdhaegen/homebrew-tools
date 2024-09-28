class KeepSorted < Formula
  desc "Language-agnostic formatter that sorts lines between two markers"
  homepage "https://github.com/google/keep-sorted"
  url "https://github.com/google/keep-sorted/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "8eee061af908fd971911118975e4a2870afff385b3aea9948cc9b221849a9436"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/keep-sorted-0.4.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "9b4aee1243bff64651800cee24581362d88f7d4d44a4e1f68ba96a7858a5a17f"
    sha256 cellar: :any_skip_relocation, ventura:      "ac1e3961f5d5170fde55cf3ad2b8e15b08c143c10804337e3dd0d767fed464ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "372c363dcb9788c64cd6b1f601e2bdf1db9c6cf9e11e01dacfd3720182817df6"
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
