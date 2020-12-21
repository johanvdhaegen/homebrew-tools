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

  patch :DATA

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

# patch: https://github.com/emacs-mirror/emacs/commit/3b3274a85c2f5df21d76d82e0d7740005aa84fdf#diff-f808b0589744f83f41d9f581e8b07001145598d2a2aa07fd40c1d20ee35df762
# patch: https://github.com/emacs-mirror/emacs/commit/ae3c510696f02f01d03052f070e5ce65b4018a45#diff-a4e552f81dc7ab801e372bf878a3a7a31457bfc9fd07ded924853ea71a472e90
__END__
From 3b3274a85c2f5df21d76d82e0d7740005aa84fdf Mon Sep 17 00:00:00 2001
From: Stefan Monnier <monnier@iro.umontreal.ca>
Date: Fri, 16 Oct 2020 14:03:59 -0400
Subject: [PATCH] * lisp/progmodes/python.el: Teach f-strings to `font-lock`

(python--f-string-p, python--font-lock-f-strings): New functions.
(python-font-lock-keywords-maximum-decoration): Use them.
---
 lisp/progmodes/python.el | 55 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 3 deletions(-)

diff --git a/lisp/progmodes/python.el b/lisp/progmodes/python.el
index 76baa4469c7..d1871c93a78 100644
--- a/lisp/progmodes/python.el
+++ b/lisp/progmodes/python.el
@@ -520,6 +520,52 @@ The type returned can be `comment', `string' or `paren'."
         font-lock-string-face)
     font-lock-comment-face))
 
+(defun python--f-string-p (ppss)
+  "Return non-nil if the pos where PPSS was found is inside an f-string."
+  (and (nth 3 ppss)
+       (let ((spos (1- (nth 8 ppss))))
+         (and (memq (char-after spos) '(?f ?F))
+              (or (< (point-min) spos)
+                  (not (memq (char-syntax (char-before spos)) '(?w ?_))))))))
+
+(defun python--font-lock-f-strings (limit)
+  "Mark {...} holes as being code.
+Remove the (presumably `font-lock-string-face') `face' property from
+the {...} holes that appear within f-strings."
+  ;; FIXME: This will fail to properly highlight strings appearing
+  ;; within the {...} of an f-string.
+  ;; We could presumably fix it by running
+  ;; `font-lock-fontify-syntactically-region' (as is done in
+  ;; `sm-c--cpp-fontify-syntactically', for example) after removing
+  ;; the `face' property, but I'm not sure it's worth the effort and
+  ;; the risks.
+  (let ((ppss (syntax-ppss)))
+    (while
+        (progn
+          (while (and (not (python--f-string-p ppss))
+                      (re-search-forward "\\<f['\"]" limit 'move))
+            (setq ppss (syntax-ppss)))
+          (< (point) limit))
+      (cl-assert (python--f-string-p ppss))
+      (let ((send (save-excursion
+                   (goto-char (nth 8 ppss))
+                   (condition-case nil
+                       (progn (let ((forward-sexp-function nil))
+                                (forward-sexp 1))
+                              (min limit (1- (point))))
+                     (scan-error limit)))))
+        (while (re-search-forward "{" send t)
+          (if (eq ?\{ (char-after))
+              (forward-char 1)          ;Just skip over {{
+            (let ((beg (match-beginning 0))
+                  (end (condition-case nil
+                           (progn (up-list 1) (min send (point)))
+                         (scan-error send))))
+              (goto-char end)
+              (put-text-property beg end 'face nil))))
+        (goto-char (min limit (1+ send)))
+        (setq ppss (syntax-ppss))))))
+
 (defvar python-font-lock-keywords-level-1
   `((,(rx symbol-start "def" (1+ space) (group (1+ (or word ?_))))
      (1 font-lock-function-name-face))
@@ -586,7 +641,8 @@ This is the medium decoration level, including everything in
 builtins.")
 
 (defvar python-font-lock-keywords-maximum-decoration
-  `(,@python-font-lock-keywords-level-2
+  `((python--font-lock-f-strings)
+    ,@python-font-lock-keywords-level-2
     ;; Constants
     (,(rx symbol-start
           (or
@@ -575,7 +622,8 @@ builtins.")
            ;; copyright, license, credits, quit and exit are added by the site
            ;; module and they are not intended to be used in programs
            "copyright" "credits" "exit" "license" "quit")
-          symbol-end) . font-lock-constant-face)
+          symbol-end)
+     . font-lock-constant-face)
     ;; Decorators.
     (,(rx line-start (* (any " \t")) (group "@" (1+ (or word ?_))
                                             (0+ "." (1+ (or word ?_)))))
@@ -628,7 +676,8 @@ builtins.")
            ;; OS specific
            "VMSError" "WindowsError"
            )
-          symbol-end) . font-lock-type-face)
+          symbol-end)
+     . font-lock-type-face)
     ;; assignments
     ;; support for a = b = c = 5
     (,(lambda (limit)

From ae3c510696f02f01d03052f070e5ce65b4018a45 Mon Sep 17 00:00:00 2001
From: Michal Nazarewicz <mina86@mina86.com>
Date: Mon, 4 May 2020 19:08:10 +0100
Subject: [PATCH] =?UTF-8?q?cc-mode:=20extend=20regexp=20used=20by=20?=
 =?UTF-8?q?=E2=80=98c-or-c++-mode=E2=80=99?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

* lisp/progmodes/cc-mode (c-or-c++-mode--regexp): Expand the regexp to
match some more C++-only constructs and recognise a few more standard
C++ header files.  Also make sure identifiers start with non-digit.
(c-or-c++-mode): Add `(interactive)` declaration.

* test/lisp/progmodes/cc-mode-tests.el (c-or-c++-mode): Add test case
for the newly recognised constructs.
---
 lisp/progmodes/cc-mode.el            | 21 +++++++++++++++------
 test/lisp/progmodes/cc-mode-tests.el | 12 ++++++++++--
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/lisp/progmodes/cc-mode.el b/lisp/progmodes/cc-mode.el
index f92d3efdeb7..e3a924efb06 100644
--- a/lisp/progmodes/cc-mode.el
+++ b/lisp/progmodes/cc-mode.el
@@ -2521,13 +2521,21 @@ Key bindings:
 
 (defconst c-or-c++-mode--regexp
   (eval-when-compile
-    (let ((id "[a-zA-Z0-9_]+") (ws "[ \t\r]+") (ws-maybe "[ \t\r]*"))
+    (let ((id "[a-zA-Z_][a-zA-Z0-9_]*") (ws "[ \t\r]+") (ws-maybe "[ \t\r]*")
+          (headers '("string" "string_view" "iostream" "map" "unordered_map"
+                     "set" "unordered_set" "vector" "tuple")))
       (concat "^" ws-maybe "\\(?:"
-                    "using"     ws "\\(?:namespace" ws "std;\\|std::\\)"
-              "\\|" "namespace" "\\(:?" ws id "\\)?" ws-maybe "{"
-              "\\|" "class"     ws id ws-maybe "[:{\n]"
-              "\\|" "template"  ws-maybe "<.*>"
-              "\\|" "#include"  ws-maybe "<\\(?:string\\|iostream\\|map\\)>"
+                    "using"     ws "\\(?:namespace" ws
+                                     "\\|" id "::"
+                                     "\\|" id ws-maybe "=\\)"
+              "\\|" "\\(?:inline" ws "\\)?namespace"
+                    "\\(:?" ws "\\(?:" id "::\\)*" id "\\)?" ws-maybe "{"
+              "\\|" "class"     ws id
+                    "\\(?:" ws "final" "\\)?" ws-maybe "[:{;\n]"
+              "\\|" "struct"     ws id "\\(?:" ws "final" ws-maybe "[:{\n]"
+                                         "\\|" ws-maybe ":\\)"
+              "\\|" "template"  ws-maybe "<.*?>"
+              "\\|" "#include"  ws-maybe "<" (regexp-opt headers) ">"
               "\\)")))
   "A regexp applied to C header files to check if they are really C++.")
 
@@ -2543,6 +2551,7 @@ should be used.
 This function attempts to use file contents to determine whether
 the code is C or C++ and based on that chooses whether to enable
 `c-mode' or `c++-mode'."
+  (interactive)
   (if (save-excursion
         (save-restriction
           (save-match-data
diff --git a/test/lisp/progmodes/cc-mode-tests.el b/test/lisp/progmodes/cc-mode-tests.el
index ad7a52b40d9..64d52a952b6 100644
--- a/test/lisp/progmodes/cc-mode-tests.el
+++ b/test/lisp/progmodes/cc-mode-tests.el
@@ -40,7 +40,7 @@
                         (insert content)
                         (setq mode nil)
                         (c-or-c++-mode)
-                        (unless(eq expected mode)
+                        (unless (eq expected mode)
                           (ert-fail
                            (format "expected %s but got %s when testing '%s'"
                                    expected mode content)))))
@@ -53,11 +53,18 @@
               (funcall do-test (concat " * " content) 'c-mode))
             '("using \t namespace \t std;"
               "using \t std::string;"
+              "using Foo = Bar;"
               "namespace \t {"
               "namespace \t foo \t {"
-              "class \t Blah_42 \t {"
+              "namespace \t foo::bar \t {"
+              "inline namespace \t foo \t {"
+              "inline namespace \t foo::bar \t {"
               "class \t Blah_42 \t \n"
+              "class \t Blah_42;"
+              "class \t Blah_42 \t final {"
+              "struct \t Blah_42 \t final {"
               "class \t _42_Blah:public Foo {"
+              "struct \t _42_Blah:public Foo {"
               "template \t < class T >"
               "template< class T >"
               "#include <string>"
@@ -67,6 +74,7 @@
       (mapc (lambda (content) (funcall do-test content 'c-mode))
             '("struct \t Blah_42 \t {"
               "struct template {"
+              "struct Blah;"
               "#include <string.h>")))))
 
 (ert-deftest c-mode-macro-comment ()
