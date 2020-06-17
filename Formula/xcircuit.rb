class Xcircuit < Formula
  desc "Program for drawing electrical circuit schematic diagrams"
  homepage "http://opencircuitdesign.com/xcircuit"
  url "http://opencircuitdesign.com/xcircuit/archive/xcircuit-3.10.26.tgz"
  sha256 "7ae9567c8affdf0178cec35d0e99044aa244737f9ed6a710caf9df175eae8970"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo-x11"
  depends_on "tcl-tk-x11"
  depends_on :x11
  depends_on "ghostscript" => :recommended

  def install
    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--with-tcl=#{Formula["tcl-tk-x11"].opt_prefix}",
      "--with-tk=#{Formula["tcl-tk-x11"].opt_prefix}",
      "--with-ngspice=ngspice",
    ]
    if build.with? "ghostscript"
      args << "--with-gs=#{Formula["ghostscript"].opt_prefix}"
    end
    args << "--with-cairo=#{Formula["cairo-x11"].opt_prefix}"
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
