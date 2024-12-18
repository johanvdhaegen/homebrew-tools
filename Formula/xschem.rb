class Xschem < Formula
  desc "Schematic editor for VLSI/Asic/Analog custom designs"
  homepage "https://github.com/StefanSchippers/xschem"
  url "https://github.com/StefanSchippers/xschem/archive/refs/tags/3.4.6.tar.gz"
  sha256 "25bd15ebc39798a513c1a788f656838463a8efbe2cbfe733a5f59608b3857195"
  license "GPL-2.0-or-later"
  head "https://github.com/StefanSchippers/xschem.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/xschem-3.4.6"
    sha256 arm64_sequoia: "c40cb058bf71e8d399f6b54f8bef4bf075d50cb5df700b9f2b1b1eb4487cfca1"
    sha256 arm64_sonoma:  "4588254aeb088e4dc4063f6243060f70564cc4da85d7a15eee336dc99bf9b27a"
    sha256 ventura:       "c051b150e63ee1826d9fe556e5a98797f9514556c577a3cb5b0f820802e3ecd4"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "libx11"
  depends_on "libxpm"
  depends_on :macos
  depends_on "tcl-tk-x11@8"

  def install
    args = [
      "--prefix=#{prefix}",
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xschem --version")
  end
end
