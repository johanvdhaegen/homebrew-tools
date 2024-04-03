class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/42/ngspice-42.tar.gz"
  sha256 "737fe3846ab2333a250dfadf1ed6ebe1860af1d8a5ff5e7803c772cc4256e50a"
  license :cannot_represent
  revision 1

  head "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/ngspice-42_1"
    sha256 arm64_sonoma: "47ccf457608659f0a4fd634d5a71c67cb519abd586466208321d0fb26544efb8"
    sha256 ventura:      "fb9cf782950ed6deb875862061afe154ef99b60ebcfa7d9788fbabed4367fa9f"
    sha256 x86_64_linux: "641e021c63c3cef20595c083574b448c6975e1a1b5791c1711d9c43bb1e6eace"
  end

  keg_only "conflicts with ngspice"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "fftw"
  depends_on "readline"

  uses_from_macos "bison" => :build

  def install
    system "./autogen.sh"

    args = %w[
      --disable-debug
      --enable-xspice
      --enable-cider
      --enable-pss
      --without-x
    ]
    args_cmd_line = %w[
      --with-readline=yes
    ]
    args_shared = %w[
      --with-ngshared
    ]

    system "./configure", *std_configure_args, *args, *args_shared
    system "make", "install"
    system "make", "clean"
    system "./configure", *std_configure_args, *args, *args_cmd_line
    system "make", "install"
  end

  test do
    (testpath/"test.cir").write <<~EOS
      RC test circuit
      v1 1 0 1
      r1 1 2 1
      c1 2 0 1 ic=0
      .tran 100u 100m uic
      .control
      run
      quit
      .endc
      .end
    EOS
    system "#{bin}/ngspice", "test.cir"

    (testpath/"test.cpp").write <<~EOS
      #include <cstdlib>
      #include <ngspice/sharedspice.h>
      int ng_exit(int status, bool immediate, bool quitexit, int ident, void *userdata) {
        return status;
      }
      int main() {
        return ngSpice_Init(NULL, NULL, ng_exit, NULL, NULL, NULL, NULL);
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lngspice", "-o", "test"
    system "./test"
  end
end
