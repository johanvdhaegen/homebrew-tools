class EmacsCocoaAT30 < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://github.com/emacs-mirror/emacs.git",
      branch:   "emacs-30",
      revision: "afee71273b7041377148fbcfb554db5b45bcb3c9"
  version "30.0.20240826"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/emacs-cocoa@30-30.0.20240826"
    sha256 arm64_sonoma: "66a3c452b6f9bc64c1e1e26d12ef18fe30b01001a0e67b86da877d32d8e5a3d9"
    sha256 ventura:      "44e89380023f02471a2e624226ba169c8d98a80ca07e4fbfc9428e1e2cdc52dc"
  end

  keg_only :versioned_formula

  option "with-ctags", "Don't remove the ctags executable that emacs provides"
  option "without-modules", "Build without dynamic modules support"
  option "without-xwidgets", "Build without Xwidgets support"
  option "without-native-compilation", "Build without native compilation"

  depends_on "autoconf" => :build
  depends_on "gnu-sed" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "giflib"
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on :macos
  depends_on "sqlite"
  depends_on "zlib"
  depends_on "librsvg" => :recommended
  depends_on "libpthread-stubs" => :build if build.with? "librsvg"
  depends_on "little-cms2" => :recommended
  depends_on "tree-sitter" => :recommended
  depends_on "webp" => :recommended
  depends_on "dbus" => :optional
  depends_on "imagemagick" => :optional
  depends_on "mailutils" => :optional

  if build.with? "native-compilation"
    depends_on "libgccjit"
    depends_on "gcc" => :build
  end

  uses_from_macos "libxml2"

  def install
    args = %W[
      --disable-silent-rules
      --enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp
      --infodir=#{info}/emacs
      --prefix=#{prefix}
      --without-x
      --with-ns
      --disable-ns-self-contained
      --with-gnutls
      --with-sqlite3="#{Formula["sqlite"].opt_prefix}"
      --with-xml2
      --with-jpeg
      --with-png
    ]

    args << "--with-rsvg#{build.with?("librsvg") ? "" : "=no"}"
    args << "--with-webp#{build.with?("webp") ? "" : "=no"}"
    args << "--with-lcms2#{build.with?("little-cms2") ? "" : "=no"}"
    args << "--without-pop" if build.with? "mailutils"
    args << "--with-imagemagick#{build.with?("imagemagick") ? "" : "=no"}"
    args << "--with-tree-sitter#{build.with?("tree-sitter") ? "" : "=no"}"
    args << "--with-dbus#{build.with?("dbus") ? "" : "=no"}"
    args << "--with-modules#{build.with?("modules") ? "" : "=no"}"
    args << "--with-xwidgets#{build.with?("xwidgets") ? "" : "=no"}"
    args << "--with-native-compilation" \
            "#{build.with?("native-compilation")?"=aot":"=no"}"

    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
    if build.with?("native-compilation")
      ENV.append "CFLAGS", "-I#{Formula["libgccjit"].opt_include}"
      ENV.append "LIBS", "-L#{Formula["libgccjit"].opt_lib}/gcc/#{Formula["libgccjit"].version.major}"
    end
    system "./autogen.sh"

    File.write "lisp/site-load.el", <<~EOS
      (setq exec-path (delete nil
        (mapcar
          (lambda (elt)
            (unless (string-match-p "Homebrew/shims" elt) elt))
          exec-path)))
    EOS

    system "./configure", *args
    system "make"
    system "make", "install"

    prefix.install "nextstep/Emacs.app"
    if build.with?("native-compilation")
      # add link to `native-lisp` directory Emacs.app seems to expect
      emacs_config = File.read("src/config.h")
      emacs_version = emacs_config.match(/#define PACKAGE_VERSION "(.*)"/)[1]
      Dir.chdir("#{prefix}/Emacs.app/Contents") do
        ln_s "../../lib/emacs/#{emacs_version}/native-lisp", "native-lisp"
      end
    end

    # Replace the symlink with one that avoids starting Cocoa.
    (bin/"emacs").unlink # Kill the existing symlink
    (bin/"emacs").write <<~EOS
      #!/bin/bash
      exec #{prefix}/Emacs.app/Contents/MacOS/Emacs "$@"
    EOS

    # Remove default site-lisp subdirs.el file.
    (share/"emacs/site-lisp/subdirs.el").unlink

    # Follow MacPorts and don't install ctags from Emacs. This allows Vim
    # and Emacs and ctags to play together without violence.
    return if build.with? "ctags"

    (bin/"ctags").unlink
    (man1/"ctags.1.gz").unlink
  end

  def caveats
    <<~EOS
      Emacs.app has been installed in:
        #{prefix}
      To link the application to the default App location:
        ln -s #{prefix}/Emacs.app /Applications
    EOS
  end

  service do
    run [opt_bin/"emacs", "--fg-daemon"]
    keep_alive true
    error_log_path var/"log/emacs.log"
    log_path var/"log/emacs.log"
  end

  test do
    assert_equal "4", shell_output("#{bin}/emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end
