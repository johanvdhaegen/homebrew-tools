class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/41/ngspice-41.tar.gz"
  sha256 "1ce219395d2f50c33eb223a1403f8318b168f1e6d1015a7db9dbf439408de8c4"
  license :cannot_represent
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/ngspice-41_1"
    sha256 ventura:      "6d25215854b6cd4f0b7688d961d86b2bddabb353fc8a55016cfda90321879b2f"
    sha256 monterey:     "7ccad4809d12ffcddcbeae231493011981dd394a1101d72b68f703589498c70d"
    sha256 x86_64_linux: "bb1e4d0c2180411be3e608bbdb56d4fb9ebbe6169c49de241ded3739431d31a9"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"
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
