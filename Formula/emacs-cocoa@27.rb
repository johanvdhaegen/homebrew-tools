class EmacsCocoaAT27 < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftp.gnu.org/gnu/emacs/emacs-27.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-27.1.tar.xz"
  sha256 "4a4c128f915fc937d61edfc273c98106711b540c9be3cd5d2e2b9b5b2f172e41"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  head do
    url "https://github.com/emacs-mirror/emacs.git", branch: "emacs-27"

    depends_on "autoconf" => :build
    depends_on "gnu-sed" => :build
    depends_on "texinfo" => :build
  end

  keg_only :versioned_formula

  option "with-ctags", "Don't remove the ctags executable that emacs provides"
  option "without-modules", "Build without dynamic modules support"

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "imagemagick" => :recommended
  depends_on "jansson" => :recommended
  depends_on "librsvg" => :recommended
  depends_on "little-cms2" => :recommended
  depends_on "dbus" => :optional
  depends_on "mailutils" => :optional

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
      --with-xml2
      --with-jpeg
      --with-png
    ]

    args << "--with-rsvg#{build.with?("librsvg") ? "" : "=no"}"
    args << "--with-lcms2#{build.with?("little-cms2") ? "" : "=no"}"
    args << "--without-pop" if build.with? "mailutils"
    args << "--with-imagemagick#{build.with?("imagemagick") ? "" : "=no"}"
    args << "--with-json#{build.with?("jansson") ? "" : "=no"}"
    args << "--with-dbus#{build.with?("dbus") ? "" : "=no"}"
    args << "--with-modules#{build.with?("modules") ? "" : "=no"}"

    if build.head?
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    prefix.install "nextstep/Emacs.app"

    # Replace the symlink with one that avoids starting Cocoa.
    (bin/"emacs").unlink # Kill the existing symlink
    (bin/"emacs").write <<~EOS
      #!/bin/bash
      exec #{prefix}/Emacs.app/Contents/MacOS/Emacs "$@"
    EOS

    # Follow MacPorts and don't install ctags from Emacs. This allows Vim
    # and Emacs and ctags to play together without violence.
    return if build.with? "ctags"

    (bin/"ctags").unlink
    (man1/"ctags.1.gz").unlink
  end

  plist_options manual: "emacs"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/emacs</string>
          <string>--fg-daemon</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_equal "4", shell_output("#{bin}/emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end
