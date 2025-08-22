class Xschem < Formula
  desc "Schematic editor for VLSI/Asic/Analog custom designs"
  homepage "https://github.com/StefanSchippers/xschem"
  url "https://github.com/StefanSchippers/xschem/archive/refs/tags/3.4.7.tar.gz"
  sha256 "8f6c7165c38f528b6cbae8f9fae72cde3b765652df90597011a5f7b5e7fdb273"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/StefanSchippers/xschem.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/xschem-3.4.7"
    sha256 arm64_sequoia: "65a5464ac0252c12f4591a572882310da4d89107ff9a6637a2ca19f71881f6c6"
    sha256 arm64_sonoma:  "2c8a60ff7a93e2b6e167a04aabf74e6e5e08a71e9b967110c4430ed86daab9f4"
    sha256 ventura:       "77dad864d5b42f51e53dd784b86c52edc34318eee4459ec6f743f22beea0a6ce"
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
