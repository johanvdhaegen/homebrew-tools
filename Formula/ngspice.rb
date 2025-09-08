class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/45.2/ngspice-45.2.tar.gz"
  sha256 "ba8345f4c3774714c10f33d7da850d361cec7d14b3a295d0dc9fd96f7423812d"
  license :cannot_represent

  head "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/ngspice-45.2"
    sha256 arm64_sequoia: "6e578b9e023fe3106fb4123a93d871db87b85283dc81cc69fd94fb98c607758e"
    sha256 arm64_sonoma:  "87b010282cb1e19b6b297ef94963d6af5f769503c29b8822617f29151ced57c3"
    sha256 ventura:       "4938fb736bbf3c77c7650b8ea7f7a835f538509898b699a74383cfa37aa5819f"
    sha256 arm64_linux:   "b067ea5d1da5333586a1d23cdac62563c3a0684a7e1817d413de44402c47c63a"
    sha256 x86_64_linux:  "349404c846a7b9a413056e6cd3e9008e0dc205255e1062f935cb70d85e8b4b53"
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
