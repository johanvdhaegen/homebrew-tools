class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/47/ngspice-47.tar.gz"
  sha256 "894e649651f1838a14095e5a5439e7d3aa63e87ede14d283173fda4fcdef675f"
  license :cannot_represent

  head "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/ngspice-47"
    sha256 arm64_tahoe:   "e0ac3d5457007e9f2637d633350fd19420cc984824990e41cdef10deb76d5e12"
    sha256 arm64_sequoia: "d08d67f21165fbf510bf88676b3be3b9ade446778b9d2240a35f22a37429656b"
    sha256 arm64_linux:   "09230079917c8f86b1ea02e1d1bf9f7665d4d4ff445e6e3dfc544087392c0281"
    sha256 x86_64_linux:  "3dd176a8aa2eee39c6aa18a244c0fc1d4bd13ed96308c2b283f8dbc4b341cb42"
  end

  keg_only "conflicts with ngspice"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "fftw"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  # Disable the broken macOS memory check. upstream commit ref, https://sourceforge.net/p/ngspice/ngspice/ci/96404e993984065f9104d724672bcdcafd7f356f/
  patch :DATA

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

__END__
diff --git a/src/frontend/outitf.c b/src/frontend/outitf.c
index a9e47df..56883b0 100644
--- a/src/frontend/outitf.c
+++ b/src/frontend/outitf.c
@@ -556,6 +556,7 @@ OUTpD_memory(runDesc *run, IFvalue *refValue, IFvalue *valuePtr)
 {
     int i, n = run->numData;
 
+#ifndef __APPLE__
     if (!cp_getvar("no_mem_check", CP_BOOL, NULL, 0)) {
         /* Estimate the required memory */
         size_t memrequ = (size_t)n * vlength2delta(0) * sizeof(double);
@@ -569,6 +570,7 @@ OUTpD_memory(runDesc *run, IFvalue *refValue, IFvalue *valuePtr)
             controlled_exit(1);
         }
     }
+#endif
 
     for (i = 0; i < n; i++) {
