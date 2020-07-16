class Magic < Formula
  desc "VLSI layout tool"
  homepage "http://opencircuitdesign.com/magic"
  url "http://opencircuitdesign.com/magic/archive/magic-8.3.32.tgz"
  sha256 "4aff163ce617a235e2985fab5a0db6d7ec325bb7fc9f817af25a981ec1e34fa9"
  license "ISC"

  depends_on "pkg-config" => :build
  depends_on "cairo-x11"
  depends_on "readline"
  depends_on "tcl-tk-x11"
  depends_on :x11

  def install
    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--with-tcl=#{Formula["tcl-tk-x11"].opt_prefix}",
      "--with-tk=#{Formula["tcl-tk-x11"].opt_prefix}",
    ]
    args << "--with-cairo=#{Formula["cairo-x11"].opt_prefix}"
    ENV.append "CFLAGS", "-Wno-error=return-type"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/magic --version")
  end
end
