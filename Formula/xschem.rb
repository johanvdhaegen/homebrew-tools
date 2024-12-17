class Xschem < Formula
  desc "Schematic editor for VLSI/Asic/Analog custom designs"
  homepage "https://github.com/StefanSchippers/xschem"
  url "https://github.com/StefanSchippers/xschem/archive/refs/tags/3.4.5.tar.gz"
  sha256 "f164e3532b008e9f78ce3ad2617a31ee9590c55c359ae6683cbec1569973cd2d"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/xschem-3.4.5"
    sha256 arm64_sonoma: "74a9a6038455f99c7503df50baf7b5278452e91c1cd0f8e6d04763a94a0c761d"
    sha256 ventura:      "a7b178d12bd8fa17bfb9aaa7988eabbb051249e4f76286b15ceb312a8e725cb8"
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
