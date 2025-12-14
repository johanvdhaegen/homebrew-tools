class EmacsCarbonAT30 < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://github.com/jdtsmith/emacs-mac.git",
      branch:   "emacs-mac-30_1_exp",
      revision: "a9f6592fe275774e6c14e3058a4f3488f9914e5e"
  version "30.2.20251206"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/emacs-carbon@30-30.2.20251206"
    sha256 arm64_tahoe:   "6bfd2f0b03ee0ac72974b416944a49381e3fb7b4fcd6b4791dab7bf45d519da9"
    sha256 arm64_sequoia: "ed18058f601ee560c6a8751461e75d01cc34d055e6b0846f16abae6e22b75dbc"
    sha256 arm64_sonoma:  "d7902d9a9a4661cfdc66ac3e54007adcdd377ba86ee84850f9828dcabd2953f4"
  end

  keg_only :versioned_formula

  option "with-ctags", "Don't remove the ctags executable that emacs provides"
  option "without-modules", "Build without dynamic modules support"
  option "without-xwidgets", "Build without Xwidgets support"
  option "without-native-compilation", "Build without native compilation"

  depends_on "autoconf" => :build
  depends_on "gnu-sed" => :build
  depends_on "m4" => :build
  depends_on "make" => :build
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
  depends_on "tree-sitter@0.25" => :recommended
  depends_on "webp" => :recommended
  depends_on "dbus" => :optional
  depends_on "imagemagick" => :optional
  depends_on "mailutils" => :optional

  if build.with? "native-compilation"
    depends_on "gcc"
    depends_on "libgccjit"
  end

  uses_from_macos "libxml2"

  def install
    args = %W[
      --disable-silent-rules
      --enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp
      --infodir=#{info}/emacs
      --prefix=#{prefix}
      --with-mac
      --with-gnutls
      --with-sqlite3="#{Formula["sqlite"].opt_prefix}"
      --with-xml2
      --with-jpeg
      --with-png
    ]

    args << "--with-rsvg#{"=no" if build.without?("librsvg")}"
    args << "--with-webp#{"=no" if build.without?("webp")}"
    args << "--with-lcms2#{"=no" if build.without?("little-cms2")}"
    args << "--without-pop" if build.with? "mailutils"
    args << "--with-imagemagick#{"=no" if build.without?("imagemagick")}"
    args << "--with-tree-sitter#{"=no" if build.without?("tree-sitter")}"
    args << "--with-dbus#{"=no" if build.without?("dbus")}"
    args << "--with-modules#{"=no" if build.without?("modules")}"
    args << "--with-xwidgets#{"=no" if build.without?("xwidgets")}"
    args << "--with-native-compilation" \
            "#{build.with?("native-compilation")?"=aot":"=no"}"

    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
    ENV.prepend_path "PATH", Formula["make"].opt_libexec/"gnubin"
    ENV.append "CFLAGS", "-I#{Formula["sqlite"].opt_include}"
    ENV.append "LDFLAGS", "-L#{Formula["sqlite"].opt_lib}"
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

    prefix.install "mac/Emacs.app"
    if build.with?("native-compilation")
      # add link to `native-lisp` directory Emacs.app seems to expect
      emacs_config = File.read("src/config.h")
      emacs_version = emacs_config.match(/#define PACKAGE_VERSION "(.*)"/)[1]
      Dir.chdir("#{prefix}/Emacs.app/Contents") do
        ln_s "../../lib/emacs/#{emacs_version}/native-lisp", "native-lisp"
      end
    end

    # Add PATH to plist environment to enable native compilation out of the box;
    # explicitly add homebrew paths, in case brew is called directly;
    # but remove any homebrew shims paths
    path = PATH.new(ORIGINAL_PATHS)
    path.prepend(HOMEBREW_PREFIX/"bin", HOMEBREW_PREFIX/"sbin")
    path = path.reject { |p| p.start_with?(HOMEBREW_SHIMS_PATH) }
    plist = "#{prefix}/Emacs.app/Contents/Info.plist"
    plist_buddy = "/usr/libexec/PlistBuddy"

    puts "Adding the following PATH value to #{plist}:"
    path.each_entry { |p| puts "  " + p }

    system "#{plist_buddy} -c 'Add :LSEnvironment dict' '#{plist}'"
    system "#{plist_buddy} -c 'Add :LSEnvironment:PATH string' '#{plist}'"
    system "#{plist_buddy} -c 'Set :LSEnvironment:PATH #{path}' '#{plist}'"
    system "#{plist_buddy} -c 'Print :LSEnvironment' '#{plist}'"
    system "touch '#{prefix}/Emacs.app'"

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
