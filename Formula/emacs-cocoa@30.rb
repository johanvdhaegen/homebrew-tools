class EmacsCocoaAT30 < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://github.com/emacs-mirror/emacs.git",
      branch:   "emacs-30",
      revision: "948c4f7f64fb9e662dfcccc609b2e02269c7ebe8"
  version "30.2.20251212"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/emacs-cocoa@30-30.2.20251212_1"
    sha256 arm64_tahoe:   "ce058c8291f5cffb537fa97ce969264759dda3886fa8c86de9829f99be253b0a"
    sha256 arm64_sequoia: "df11c1c301928b8df7f0acc4d98a2eddb86903d36f169d5a6cbd0cf3fb605167"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "gnu-sed" => :build
  depends_on "m4" => :build
  depends_on "make" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "cairo" # indirect linkage
  depends_on "gcc"
  depends_on "gdk-pixbuf" # indirect linkage
  depends_on "gettext" # indirect linkage
  depends_on "giflib"
  depends_on "glib" # indirect linkage
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jpeg-turbo"
  depends_on "libgccjit"
  depends_on "libpng"
  depends_on "libpthread-stubs"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on :macos
  depends_on "sqlite"
  depends_on "tree-sitter@0.25"
  depends_on "webp"
  depends_on "zlib"

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
      --with-rsvg
      --with-webp
      --with-lcms2
      --with-tree-sitter
      --with-modules
      --with-xwidgets
      --with-native-compilation=aot
    ]

    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
    ENV.prepend_path "PATH", Formula["make"].opt_libexec/"gnubin"
    ENV.append "CFLAGS", "-I#{Formula["sqlite"].opt_include}"
    ENV.append "LDFLAGS", "-L#{Formula["sqlite"].opt_lib}"
    ENV.append "CFLAGS", "-I#{Formula["libgccjit"].opt_include}"
    ENV.append "LIBS", "-L#{Formula["libgccjit"].opt_lib}/gcc/#{Formula["libgccjit"].version.major}"
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
    # add link to `native-lisp` directory Emacs.app seems to expect
    emacs_config = File.read("src/config.h")
    emacs_version = emacs_config.match(/#define PACKAGE_VERSION "(.*)"/)[1]
    Dir.chdir("#{prefix}/Emacs.app/Contents") do
      ln_s "../../lib/emacs/#{emacs_version}/native-lisp", "native-lisp"
    end

    # Add PATH to plist environment to enable native compilation out of the box;
    # explicitly add homebrew paths, in case brew is called directly;
    # but remove any homebrew shims paths
    path = PATH.new(ORIGINAL_PATHS)
    path.prepend(HOMEBREW_PREFIX/"bin", HOMEBREW_PREFIX/"sbin")
    path = path.reject { |p| p.start_with?(HOMEBREW_SHIMS_PATH) }
    plist = "#{prefix}/Emacs.app/contents/Info.plist"
    plist_buddy = "/usr/libexec/PlistBuddy"

    puts "Adding the following PATH value to #{plist}:"
    path.each_entry { |p| puts "  " + p }

    system "#{plist_buddy} -c 'Add :LSEnvironment dict' '#{plist}'"
    system "#{plist_buddy} -c 'Add :LSEnvironment:PATH string' '#{plist}'"
    system "#{plist_buddy} -c 'Set :LSEnvironment:PATH #{path}' '#{plist}'"
    system "#{plist_buddy} -c 'Print :LSEnvironment' '#{plist}'"
    system "touch '#{prefix}/Emacs.app'"

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

  def post_install
    # Sign to ensure proper execution of the app bundle
    system "/usr/bin/codesign --force --deep --sign - '#{prefix}/Emacs.app'" if OS.mac? && Hardware::CPU.arm?
  end

  def caveats
    <<~EOS
      Emacs.app has been installed in:
        #{prefix}
      To link the application to the default App location:
        ln -s #{prefix}/Emacs.app /Applications
      or:
        osascript -e 'tell application "Finder" to make alias file to posix file "#{prefix}/Emacs.app" at POSIX file "/Applications" with properties {name:"Emacs.app"}'
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
