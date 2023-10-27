class Xschem < Formula
  desc "Schematic editor for VLSI/Asic/Analog custom designs"
  homepage "https://github.com/StefanSchippers/xschem"
  url "https://github.com/StefanSchippers/xschem/archive/refs/tags/3.4.4.tar.gz"
  sha256 "ce0e93a13ff5d77c0deb5234101573a85af622dad3fcb0e786de36943bbb3c79"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/xschem-3.4.3"
    sha256 ventura:  "909ae84c0c7e8088a246d65eaa92c0b24e2bb8cc77b4bf19bd533b58ad2c2c93"
    sha256 monterey: "c2609f5c5c10c812415b173ae35d2cdc2bbc369e70a5a9c59d21d01f75e4d254"
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
