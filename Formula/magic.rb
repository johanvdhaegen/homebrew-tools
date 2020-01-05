class Magic < Formula
  desc "VLSI layout tool"
  homepage "http://opencircuitdesign.com/magic"
  url "http://opencircuitdesign.com/magic/archive/magic-8.2.177.tgz"
  sha256 "fd47fa503eaab69a81edeb906583f6619da77bd7c7bb2f5bbf43522566086cce"

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
