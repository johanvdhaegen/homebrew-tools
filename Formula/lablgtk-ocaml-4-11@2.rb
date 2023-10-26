class LablgtkOcaml411AT2 < Formula
  desc "Objective Caml interface to gtk+"
  homepage "http://lablgtk.forge.ocamlcore.org"
  url "https://github.com/garrigue/lablgtk/archive/refs/tags/2.18.12.tar.gz"
  sha256 "43b2640b6b6d6ba352fa0c4265695d6e0b5acb8eb1da17290493e99ae6879b18"
  license "LGPL-2.1-only"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/lablgtk-ocaml-4-11@2-2.18.12"
    sha256 cellar: :any, monterey: "765362129034aa2226930c52c3c92b3968e01a7f909dfc4844073841b95eb16a"
  end

  keg_only "conflicts with lablgtk"

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtksourceview"
  depends_on "librsvg"
  depends_on "ocaml@4.11"

  def install
    system "./configure", "--bindir=#{bin}",
                          "--libdir=#{lib}",
                          "--mandir=#{man}",
                          "--with-libdir=#{lib}/ocaml"
    ENV.deparallelize
    system "make", "world"
    system "make", "old-install"
  end

  test do
    (testpath/"test.ml").write <<~EOS
      let _ =
        GtkMain.Main.init ()
    EOS
    ENV["CAML_LD_LIBRARY_PATH"] = "#{lib}/ocaml/stublibs"
    system "#{Formula["ocaml@4.11"].opt_bin}/ocamlc",
      "-I", "#{opt_lib}/ocaml/lablgtk2", "lablgtk.cma", "gtkInit.cmo",
      "test.ml", "-o", "test",
      "-cclib", "-latk-1.0",
      "-cclib", "-lcairo",
      "-cclib", "-lgdk-quartz-2.0",
      "-cclib", "-lgdk_pixbuf-2.0",
      "-cclib", "-lgio-2.0",
      "-cclib", "-lglib-2.0",
      "-cclib", "-lgobject-2.0",
      "-cclib", "-lgtk-quartz-2.0",
      "-cclib", "-lgtksourceview-2.0",
      "-cclib", "-lintl",
      "-cclib", "-lpango-1.0",
      "-cclib", "-lpangocairo-1.0"
    system "./test"
  end
end
