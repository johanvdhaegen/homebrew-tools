class Xschem < Formula
  desc "Schematic editor for VLSI/Asic/Analog custom designs"
  homepage "https://github.com/StefanSchippers/xschem"
  url "https://github.com/StefanSchippers/xschem/archive/refs/tags/3.4.6.tar.gz"
  sha256 "25bd15ebc39798a513c1a788f656838463a8efbe2cbfe733a5f59608b3857195"
  license "GPL-2.0-or-later"
  head "https://github.com/StefanSchippers/xschem.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/xschem-3.4.5_1"
    sha256 arm64_sequoia: "fd2c93172362e04919aeb8e1fa8aca1505f323232e4da51a88ff1c9664087d0e"
    sha256 arm64_sonoma:  "16c8b3ccddb27eb40ba2e9d664b3dfe563f1ea2717e4d11cbee100851d32d0bc"
    sha256 ventura:       "93da5e91e147715c31e051df1a2664b375c8b2aa3e5f46e94528e1b419f8bdeb"
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
