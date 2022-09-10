class Magic < Formula
  desc "VLSI layout tool"
  homepage "http://opencircuitdesign.com/magic"
  url "http://opencircuitdesign.com/magic/archive/magic-8.3.323.tgz"
  sha256 "f6ce100708324bdbde20e504100425839e9d0eef634233f5018dffa61961c719"
  license "ISC"

  livecheck do
    url "http://opencircuitdesign.com/magic/archive/"
    regex(/href=.*magic[._-]v?(\d+(?:\.\d+)+)\.tgz"/i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/magic-8.3.323"
    sha256 big_sur: "5a83b5b77b85c712b729be35c2f02217bfff58991ce2b7a0c0c66c5f2a3f4ced"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "libx11"
  depends_on "readline"
  depends_on "tcl-tk-x11"

  def install
    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--with-tcl=#{Formula["tcl-tk-x11"].opt_prefix}",
      "--with-tk=#{Formula["tcl-tk-x11"].opt_prefix}",
      "--with-cairo=#{Formula["cairo"].opt_prefix}",
    ]
    ENV.append "CFLAGS", "-Wno-error=return-type"

    cd "scripts" do
      system "./configure", *args
    end
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/magic --version")
  end
end
