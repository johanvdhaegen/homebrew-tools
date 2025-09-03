class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/45/ngspice-45.tar.gz"
  sha256 "f1aad8abac2828a7b71da66411de8e406524e75f3066e46755439c490442d734"
  license :cannot_represent

  head "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/ngspice-45"
    sha256 arm64_sequoia: "37ba61ea9e09c85b01b8175ebb5c06eb833d5ff07f0b0905cf8f670838dcb6d9"
    sha256 arm64_sonoma:  "b849ae866678022d0e72491bec9e872ebe29526e12ca761344b6c1ad27e91ffe"
    sha256 ventura:       "473be9380578269768879b41dccfde179115ecd2d57139c6de2e4d77fe1ad039"
    sha256 arm64_linux:   "37b19ae1de2682f1760fcf9044eeccf60544e447439fa0737c572bad1b43d86d"
    sha256 x86_64_linux:  "9557d47db0abf8829d4ad7dfef39671d028378895336b42357370fb1643958fe"
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
      --enable-osdi
      --enable-cider
      --enable-xspice
      --disable-openmp
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
