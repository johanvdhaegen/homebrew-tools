class TclTkX11 < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl-lang.org"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.13/tcl8.6.13-src.tar.gz"
  mirror "https://fossies.org/linux/misc/tcl8.6.13-src.tar.gz"
  sha256 "43a1fae7412f61ff11de2cfd05d28cfc3a73762f354a417c62370a54e2caf066"
  license "TCL"
  revision 3

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:tcl|tk).?v?(\d+(?:\.\d+)+)[._-]src\.t}i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/tcl-tk-x11-8.6.13_3"
    sha256 ventura:      "49d1e3ec712f5065c529d252b2458afe17e407dd649a74029a4976dfed803dd2"
    sha256 monterey:     "5682f4e6497f0f286bb9cd883fcee07c9310901cba41c25c13e50a10bce5e0aa"
    sha256 x86_64_linux: "21ac22a2a1ba97d808954b2ecf06cb36972710d3fb33644a40b056d459024aa1"
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
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.13/tk8.6.13-src.tar.gz"
    mirror "https://fossies.org/linux/misc/tk8.6.13-src.tar.gz"
    sha256 "2e65fa069a23365440a3c56c556b8673b5e32a283800d8d9b257e3f584ce0675"

    # Bugfix for ttk::ThemeChanged errors; will be in Tk 8.6.14
    # See https://core.tcl-lang.org/tk/info/310c74ecf4
    patch :p0 do
      url "https://raw.githubusercontent.com/macports/macports-ports/db4f8f774193/x11/tk/files/fix-themechanged-error.patch"
      sha256 "2a75496dc597dec9d25401ab002f290be74d4acd5566793c5114e75a154c280a"
    end

    # Bugfix for KVO crash; will be in Tk 8.6.14
    # See https://core.tcl-lang.org/tk/info/ef5d3e29a4
    patch :p0 do
      url "https://raw.githubusercontent.com/macports/macports-ports/6a93695d61d3/x11/tk/files/fix-kvo-crash.diff"
      sha256 "ec9a9234b4a326e5621fe78e078c29aa4784b6dc88c59a43d828639ebae0af41"
    end
  end

  def install
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
