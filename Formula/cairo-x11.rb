class CairoX11 < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/cairo-1.16.0.tar.xz"
  sha256 "5e7b29b3f113ef870d1e3ecf8adf21f923396401604bda16d44be45e66052331"
  license "LGPL-2.1"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)cairo[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t}i)
  end

  head do
    url "https://anongit.freedesktop.org/git/cairo.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only "conflicts with cairo"

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "libpng"
  depends_on "lzo"
  depends_on "pixman"
  depends_on x11: :recommended

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-gobject=yes
      --enable-svg=yes
      --enable-tee=yes
      --enable-quartz-image
    ]

    if build.with? "x11"
      args << "--enable-xcb=yes" << "--enable-xlib=yes" << "--enable-xlib-xrender=yes"
    else
      args << "--enable-xcb=no" << "--enable-xlib=no" << "--enable-xlib-xrender=no"
    end

    if build.head?
      ENV["NOCONFIGURE"] = "1"
      system "./autogen.sh"
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cairo.h>

      int main(int argc, char *argv[]) {

        cairo_surface_t *surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 600, 400);
        cairo_t *context = cairo_create(surface);

        return 0;
      }
    EOS
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libpng = Formula["libpng"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/cairo
      -I#{libpng.opt_include}/libpng16
      -I#{pixman.opt_include}/pixman-1
      -L#{lib}
      -lcairo
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
