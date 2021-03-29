class TclTkX11 < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl-lang.org"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.11/tcl8.6.11-src.tar.gz"
  mirror "https://fossies.org/linux/misc/tcl8.6.11-src.tar.gz"
  sha256 "8c0486668586672c5693d7d95817cb05a18c5ecca2f40e2836b9578064088258"
  license "ISC"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:tcl|tk).?v?(\d+(?:\.\d+)+)[._-]src\.t}i)
  end

  keg_only :provided_by_macos

  depends_on "freetype" => :build
  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  resource "critcl" do
    url "https://github.com/andreas-kupries/critcl/archive/3.1.18.1.tar.gz"
    sha256 "51bc4b099ecf59ba3bada874fc8e1611279dfd30ad4d4074257084763c49fd86"
  end

  resource "tcllib" do
    url "https://downloads.sourceforge.net/project/tcllib/tcllib/1.20/tcllib-1.20.tar.xz"
    sha256 "199e8ec7ee26220e8463bc84dd55c44965fc8ef4d4ac6e4684b2b1c03b1bd5b9"
  end

  resource "tcltls" do
    url "https://core.tcl-lang.org/tcltls/uv/tcltls-1.7.22.tar.gz"
    sha256 "e84e2b7a275ec82c4aaa9d1b1f9786dbe4358c815e917539ffe7f667ff4bc3b4"
  end

  resource "tk" do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.11/tk8.6.11.1-src.tar.gz"
    mirror "https://fossies.org/linux/misc/tk8.6.11.1-src.tar.gz"
    sha256 "006cab171beeca6a968b6d617588538176f27be232a2b334a0e96173e89909be"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-threads
      --enable-64bit
    ]

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
      on_macos do
        ENV["SDKROOT"] = MacOS.sdk_path
      end
      system "make", "critcl"
      cp_r "modules/tcllibc", "#{lib}/"
      on_macos do
        ln_s "#{lib}/tcllibc/macosx-x86_64-clang", "#{lib}/tcllibc/macosx-x86_64"
      end
    end

    resource("tcltls").stage do
      system "./configure", "--with-ssl=openssl",
                            "--with-openssl-dir=#{Formula["openssl@1.1"].opt_prefix}",
                            "--prefix=#{prefix}",
                            "--mandir=#{man}"
      system "make", "install"
    end
  end

  test do
    assert_equal "honk", pipe_output("#{bin}/tclsh", "puts honk\n").chomp
  end
end
