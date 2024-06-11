class Xschem < Formula
  desc "Schematic editor for VLSI/Asic/Analog custom designs"
  homepage "https://github.com/StefanSchippers/xschem"
  url "https://github.com/StefanSchippers/xschem/archive/refs/tags/3.4.5.tar.gz"
  sha256 "f164e3532b008e9f78ce3ad2617a31ee9590c55c359ae6683cbec1569973cd2d"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/xschem-3.4.4"
    sha256 ventura:  "177cf4fde8f13347f43e4d9f73acc4fe1eb149d8f912c07bfb2a6d7b19bdf60f"
    sha256 monterey: "72a2511eea938f9520e43bb5910915941a299342498174557d53f538ab0e5d8f"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "libx11"
  depends_on "libxpm"
  depends_on :macos
  depends_on "tcl-tk-x11"

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
