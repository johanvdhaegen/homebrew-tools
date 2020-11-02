class EmacsCocoaAT26 < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftp.gnu.org/gnu/emacs/emacs-26.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-26.3.tar.xz"
  sha256 "4d90e6751ad8967822c6e092db07466b9d383ef1653feb2f95c93e7de66d3485"

  head do
    url "https://github.com/emacs-mirror/emacs.git"

    depends_on "autoconf" => :build
    depends_on "gnu-sed" => :build
    depends_on "texinfo" => :build
  end

  option "with-cocoa", "Build a Cocoa version of emacs"
  option "with-ctags", "Don't remove the ctags executable that emacs provides"
  option "without-libxml2", "Don't build with libxml2 support"
  option "without-modules", "Don't build with dynamic modules support"

  deprecated_option "cocoa" => "with-cocoa"
  deprecated_option "keep-ctags" => "with-ctags"
  deprecated_option "with-d-bus" => "with-dbus"
  deprecated_option "imagemagick" => "imagemagick@6"

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "cairo" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "dbus" => :optional
  # Emacs does not support ImageMagick 7:
  # Reported on 2017-03-04: https://debbugs.gnu.org/cgi/bugreport.cgi?bug=25967
  depends_on "imagemagick@6" => :optional
  depends_on "librsvg" => :optional
  depends_on "mailutils" => :optional

  stable do
    patch :DATA
  end

  keg_only :versioned_formula

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp
      --infodir=#{info}/emacs
      --prefix=#{prefix}
      --with-gnutls
      --without-x
    ]

    if build.with? "libxml2"
      args << "--with-xml2"
    else
      args << "--without-xml2"
    end

    if build.with? "dbus"
      args << "--with-dbus"
    else
      args << "--without-dbus"
    end

    # Note that if ./configure is passed --with-imagemagick but can't find the
    # library it does not fail but imagemagick support will not be available.
    # See: https://debbugs.gnu.org/cgi/bugreport.cgi?bug=24455
    if build.with? "imagemagick@6"
      args << "--with-imagemagick"
    else
      args << "--without-imagemagick"
    end

    args << "--with-cairo" if build.with? "cairo"
    args << "--with-modules" if build.with? "modules"
    args << "--without-jpeg" if build.without? "jpeg"
    args << "--without-lcms2" if build.without? "lcms2"
    args << "--without-png" if build.without? "libpng"
    args << "--without-rsvg" if build.without? "librsvg"
    args << "--without-tiff" if build.without? "libtiff"
    args << "--without-pop" if build.with? "mailutils"

    if build.head?
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      system "./autogen.sh"
    end

    if build.with? "cocoa"
      args << "--with-ns" << "--disable-ns-self-contained"
    else
      args << "--without-ns"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    if build.with? "cocoa"
      prefix.install "nextstep/Emacs.app"

      # Replace the symlink with one that avoids starting Cocoa.
      (bin/"emacs").unlink # Kill the existing symlink
      (bin/"emacs").write <<~EOS
        #!/bin/bash
        exec #{prefix}/Emacs.app/Contents/MacOS/Emacs "$@"
      EOS
    end

    # Follow MacPorts and don't install ctags from Emacs. This allows Vim
    # and Emacs and ctags to play together without violence.
    if build.without? "ctags"
      (bin/"ctags").unlink
      (man1/"ctags.1.gz").unlink
    end
  end

  def caveats
    if build.with? "cocoa" then <<~EOS
      Please try the Cask for a better-supported Cocoa version:
        brew cask install emacs
    EOS
    end
  end

  plist_options :manual => "emacs"

  def plist; <<~EOS
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

__END__
diff --git a/patches/emacs-26/fix-unexec.patch b/patches/emacs-26/fix-unexec.patch
new file mode 100644
index 0000000..53afeac
diff --git a/src/unexmacosx.c b/src/unexmacosx.c
index 8d132417e8..59cbe3c18b 100644
--- a/src/unexmacosx.c
+++ b/src/unexmacosx.c
@@ -503,22 +503,34 @@ unexec_regions_sort_compare (const void *a, const void *b)
 static void
 unexec_regions_merge (void)
 {
-  int i, n;
-  unexec_region_info r;
-  vm_size_t padsize;
-
   qsort (unexec_regions, num_unexec_regions, sizeof (unexec_regions[0]),
 	 &unexec_regions_sort_compare);
-  n = 0;
-  r = unexec_regions[0];
-  padsize = r.range.address & (pagesize - 1);
-  if (padsize)
+
+  /* Align each region start address to a page boundary.  */
+  for (unexec_region_info *cur = unexec_regions;
+       cur < unexec_regions + num_unexec_regions; cur++)
     {
-      r.range.address -= padsize;
-      r.range.size += padsize;
-      r.filesize += padsize;
+      vm_size_t padsize = cur->range.address & (pagesize - 1);
+      if (padsize)
+	{
+	  cur->range.address -= padsize;
+	  cur->range.size += padsize;
+	  cur->filesize += padsize;
+
+	  unexec_region_info *prev = cur == unexec_regions ? NULL : cur - 1;
+	  if (prev
+	      && prev->range.address + prev->range.size > cur->range.address)
+	    {
+	      prev->range.size = cur->range.address - prev->range.address;
+	      if (prev->filesize > prev->range.size)
+		prev->filesize = prev->range.size;
+	    }
+	}
     }
-  for (i = 1; i < num_unexec_regions; i++)
+
+  int n = 0;
+  unexec_region_info r = unexec_regions[0];
+  for (int i = 1; i < num_unexec_regions; i++)
     {
       if (r.range.address + r.range.size == unexec_regions[i].range.address
 	  && r.range.size - r.filesize < 2 * pagesize)
@@ -530,17 +542,6 @@ unexec_regions_merge (void)
 	{
 	  unexec_regions[n++] = r;
 	  r = unexec_regions[i];
-	  padsize = r.range.address & (pagesize - 1);
-	  if (padsize)
-	    {
-	      if ((unexec_regions[n-1].range.address
-		   + unexec_regions[n-1].range.size) == r.range.address)
-		unexec_regions[n-1].range.size -= padsize;
-
-	      r.range.address -= padsize;
-	      r.range.size += padsize;
-	      r.filesize += padsize;
-	    }
 	}
     }
   unexec_regions[n++] = r;
