class Xcircuit < Formula
  desc "Program for drawing electrical circuit schematic diagrams"
  homepage "http://opencircuitdesign.com/xcircuit"
  url "http://opencircuitdesign.com/xcircuit/archive/xcircuit-3.10.30.tgz"
  sha256 "b2f63cba605e79cc2a08714bf3888f7be7174384ed724db3c70f8bf25c36f554"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url "http://opencircuitdesign.com/xcircuit/archive/"
    regex(/href=.*xcircuit[._-]v?(\d+(?:\.\d+)+)\.tgz"/i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/xcircuit-3.10.30_2"
    sha256 monterey:     "bbe68cc1a81543488b52973c827d3c4b780ccd4f63f50484ce6f8f095a6334b7"
    sha256 x86_64_linux: "82790a015bf629937f5677aa087438d77284a2f4f4522ac806aaf1e7f965ad89"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "libx11"
  depends_on "libxt"
  depends_on "tcl-tk-x11"
  depends_on "ghostscript" => :recommended

  def install
    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--with-tcl=#{Formula["tcl-tk-x11"].opt_prefix}",
      "--with-tk=#{Formula["tcl-tk-x11"].opt_prefix}",
      "--with-ngspice=ngspice",
    ]
    args << "--with-gs=#{Formula["ghostscript"].opt_prefix}" if build.with? "ghostscript"
    args << "--with-cairo=#{Formula["cairo"].opt_prefix}"
    ENV.append "CFLAGS", "-Wno-error=return-type"

    system "aclocal"
    system "autoconf"
    system "automake"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/xcircuit", "--version"
  end
end
