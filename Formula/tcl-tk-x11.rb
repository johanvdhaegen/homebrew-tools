class TclTkX11 < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl-lang.org"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.15/tcl8.6.15-src.tar.gz"
  mirror "https://fossies.org/linux/misc/tcl8.6.15-src.tar.gz"
  sha256 "861e159753f2e2fbd6ec1484103715b0be56be3357522b858d3cbb5f893ffef1"
  license "TCL"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:tcl|tk).?v?(\d+(?:\.\d+)+)[._-]src\.t}i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/tcl-tk-x11-8.6.15"
    sha256 arm64_sonoma: "52c1f92a2e08fcdf120ffa3350ddef13c161511aa5d4001ba6f6988e288514fd"
    sha256 ventura:      "6a8c964ea845a7ac2177b4ddb6f397a0026729050f9cd49a5fe2269f6238a01d"
    sha256 x86_64_linux: "e35cbcf63148d776960c28e037ad6eb02d6ea199e801b28a8aa68d4af6dcd181"
  end

  keg_only "it conflicts with tcl-tk"

  depends_on "freetype" => :build
  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  resource "critcl" do
    url "https://github.com/andreas-kupries/critcl/archive/refs/tags/3.2.tar.gz"
    sha256 "20061944e28dda4ab2098b8f77682cab77973f8961f6fa60b95bcc09a546789e"
  end

  resource "tcllib" do
    url "https://downloads.sourceforge.net/project/tcllib/tcllib/1.21/tcllib-1.21.tar.xz"
    sha256 "10c7749e30fdd6092251930e8a1aa289b193a3b7f1abf17fee1d4fa89814762f"
  end

  resource "tcltls" do
    url "https://core.tcl-lang.org/tcltls/uv/tcltls-1.7.22.tar.gz"
    sha256 "e84e2b7a275ec82c4aaa9d1b1f9786dbe4358c815e917539ffe7f667ff4bc3b4"
  end

  resource "tk" do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.15/tk8.6.15-src.tar.gz"
    mirror "https://fossies.org/linux/misc/tk8.6.15-src.tar.gz"
    sha256 "550969f35379f952b3020f3ab7b9dd5bfd11c1ef7c9b7c6a75f5c49aca793fec"
  end

  def install
    odie "tk resource needs to be updated" if version != resource("tk").version

    args = %W[
      --prefix=#{prefix}
      --includedir=#{include}/tcl-tk
      --mandir=#{man}
      --enable-threads
      --enable-64bit
    ]

    ENV["TCL_PACKAGE_PATH"] = "#{HOMEBREW_PREFIX}/lib"
    cd "unix" do
      system "./configure", *args
      system "make"
      system "make", "install"
      system "make", "install-private-headers"
      ln_s bin/"tclsh#{version.to_f}", bin/"tclsh"
    end

    # Let tk finds our new tclsh
    ENV.prepend_path "PATH", bin

    resource("tk").stage do
      args << "--with-x"
      cd "unix" do
        system "./configure", *args, "--with-tcl=#{lib}"
        system "make"
        system "make", "install"
        system "make", "install-private-headers"
        ln_s bin/"wish#{version.to_f}", bin/"wish"
      end
    end

    resource("critcl").stage do
      system bin/"tclsh", "build.tcl", "install"
    end

    resource("tcllib").stage do
      system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
      system "make", "install"
      system "make", "critcl"
      cp_r "modules/tcllibc", "#{lib}/"
      ln_s "#{lib}/tcllibc/macosx-x86_64-clang", "#{lib}/tcllibc/macosx-x86_64" if OS.mac?
    end

    resource("tcltls").stage do
      inreplace "configure" do |s|
        s.gsub! " -flat_namespace -undefined suppress ",
                " -undefined dynamic_lookup "
        s.gsub! " -Wl,-flat_namespace -Wl,-undefined,suppress ",
                " -Wl,-undefined,dynamic_lookup "
      end
      system "./configure", "--with-ssl=openssl",
                            "--with-openssl-dir=#{Formula["openssl@3"].opt_prefix}",
                            "--prefix=#{prefix}",
                            "--mandir=#{man}"
      system "make", "install"
    end

    # Rename all section 3 man pages in the Debian/Ubuntu style, to avoid conflicts
    man3.glob("*.3") { |file| file.rename("#{file}tcl") }

    # Use the sqlite-analyzer formula instead
    # https://github.com/Homebrew/homebrew-core/pull/82698
    rm bin/"sqlite3_analyzer"
  end

  test do
    assert_match "#{HOMEBREW_PREFIX}/lib", pipe_output("#{bin}/tclsh", "puts $auto_path\n")
    assert_equal "honk", pipe_output("#{bin}/tclsh", "puts honk\n").chomp
  end
end
