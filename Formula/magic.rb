class Magic < Formula
  desc "VLSI layout tool"
  homepage "http://opencircuitdesign.com/magic"
  url "http://opencircuitdesign.com/magic/archive/magic-8.3.162.tgz"
  sha256 "ad3aac09349009ff0a1bf1fb52d312103b1931cbb6e66f3e73a36d6fbfe745f2"
  license "ISC"

  livecheck do
    url "http://opencircuitdesign.com/magic/archive/"
    regex(/href=.*magic[._-]v?(\d+(?:\.\d+)+)\.tgz"/i)
  end

  depends_on "pkg-config" => :build
  depends_on "cairo-x11"
  depends_on "libx11"
  depends_on "readline"
  depends_on "tcl-tk-x11"

  def install
    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--with-tcl=#{Formula["tcl-tk-x11"].opt_prefix}",
      "--with-tk=#{Formula["tcl-tk-x11"].opt_prefix}",
      "--with-cairo=#{Formula["cairo-x11"].opt_prefix}",
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
