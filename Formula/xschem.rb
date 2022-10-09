class Xschem < Formula
  desc "Schematic editor for VLSI/Asic/Analog custom designs"
  homepage "https://github.com/StefanSchippers/xschem"
  url "http://repo.hu/projects/xschem/releases/xschem-3.1.0.tar.bz2"
  sha256 "dfa4002493de680b54881c3de3609d19420442fed0c2fef5f7c3f81f5bdf9013"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://repo.hu/projects/xschem/releases/"
    regex(/xschem-v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/xschem-3.1.0"
    sha256 big_sur:      "0071da012b217cf630cd8f25331e8793f4724cd65cc5577c754098c5313556fe"
    sha256 x86_64_linux: "b9093934626d327b76ae59cf3a2f090a32ec7abd77fc96af2262beb3c3152d20"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "libx11"
  depends_on "libxpm"
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
