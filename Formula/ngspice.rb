class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/41/ngspice-41.tar.gz"
  sha256 "1ce219395d2f50c33eb223a1403f8318b168f1e6d1015a7db9dbf439408de8c4"
  license :cannot_represent

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/ngspice-41"
    sha256 ventura:      "dc8833efb67f34d46054a91326124207a4f9efccfbab51bfecf99f37e3e6fe15"
    sha256 monterey:     "e91c2f71aaef1b2fdcebba323909d8885e012f469fd78165f9c359e4b99e403d"
    sha256 x86_64_linux: "a22e3b3155ab6e51fabea1087f65ce2fc6d0833e8c00d47f68af15cdf381c6c1"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"
  end

  keg_only "conflicts with ngspice"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "fftw"
  depends_on "readline"
  depends_on "tcl-tk"

  uses_from_macos "bison" => :build

  def install
    system "./autogen.sh"

    args = %w[
      --with-readline=yes
      --enable-xspice
      --enable-cider
      --enable-pss
      --without-x
    ]

    system "./configure", *std_configure_args, *args
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
  end
end
