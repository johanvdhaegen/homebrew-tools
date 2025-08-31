class Xschem < Formula
  desc "Schematic editor for VLSI/Asic/Analog custom designs"
  homepage "https://github.com/StefanSchippers/xschem"
  url "https://github.com/StefanSchippers/xschem/archive/refs/tags/3.4.7.tar.gz"
  sha256 "8f6c7165c38f528b6cbae8f9fae72cde3b765652df90597011a5f7b5e7fdb273"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/StefanSchippers/xschem.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/xschem-3.4.7_1"
    sha256 arm64_sequoia: "2093dddd59e7f35114dccc4b81d252874dae87b72f7af1cbdd0308ce546d2ffd"
    sha256 arm64_sonoma:  "41a75d5a09f0fc626ac948dade4bda2b3f764ca2d5ad77d3519b6ebec245a309"
    sha256 ventura:       "943c91d5cfadba76dc1987480aa778ae21dc7cf57c08a31c3b94ab6be3588059"
    sha256 arm64_linux:   "d38d035d5d38cd303e7b4a7860e38ddb33518af19992a147e7737e926e25a6a7"
    sha256 x86_64_linux:  "7c79ff168d74688d735d99f1e9e15271a4f68cec3c79e8a700dc8cfd451c16b4"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "jpeg-turbo"
  depends_on "libx11"
  depends_on "libxpm"
  depends_on "tcl-tk-x11@8"
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_macos do
    depends_on "libxcb"
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "/arg/tcl-version=8.6",
      "/arg/tk-version=8.6",
      "--prefix/libs/script/tcl=#{Formula["tcl-tk-x11@8"].opt_prefix}",
      "--prefix/libs/script/tk=#{Formula["tcl-tk-x11@8"].opt_prefix}",
      "--CFLAGS=-I#{Formula["tcl-tk-x11@8"].opt_include}/tcl-tk",
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xschem --version")
  end
end
