class UnisonAT2484 < Formula
  desc "Unison file synchronizer"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://www.seas.upenn.edu/~bcpierce/unison/download/releases/unison-2.48.4/unison-2.48.4.tar.gz"
  sha256 "30aa53cd671d673580104f04be3cf81ac1e20a2e8baaf7274498739d59e99de8"

  keg_only :versioned_formula

  option "with-gtk+", "Build a GTK2 GUI"

  depends_on "ocaml" => :build
  depends_on "gtk+" => :optional
  depends_on "lablgtk" => :build if build.with? "gtk+"

  patch :p2, :DATA

  def install
    ENV["OCAMLPARAM"] = "safe-string=0,_" # OCaml 4.06.0 compat
    ENV.deparallelize
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "make", "./mkProjectInfo"
    if build.with?("gtk+")
      system "make", "UISTYLE=gtk2"
      bin.install "unison" => "unison_gtk"
    end
    system "make", "UISTYLE=text"
    bin.install "unison"
  end

  test do
    if build.with?("gtk+")
      assert_match version.to_s, shell_output("#{bin}/unison_gtk -version")
    end
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end

__END__
diff --git a/src/files.ml b/src/files.ml
--- a/src/files.ml
+++ b/src/files.ml
@@ -722,7 +722,7 @@ let get_files_in_directory dir =
   with End_of_file ->
     dirh.System.closedir ()
   end;
-  Sort.list (<) !files
+  List.sort String.compare !files

 let ls dir pattern =
   Util.convertUnixErrorsToTransient
diff --git a/src/recon.ml b/src/recon.ml
--- a/src/recon.ml
+++ b/src/recon.ml
@@ -651,8 +651,8 @@ let rec reconcile

 (* Sorts the paths so that they will be displayed in order                   *)
 let sortPaths pathUpdatesList =
-  Sort.list
-    (fun (p1, _) (p2, _) -> Path.compare p1 p2 <= 0)
+  List.sort
+    Path.compare
     pathUpdatesList

 let rec enterPath p1 p2 t =
diff --git a/src/system/system_generic.ml b/src/system/system_generic.ml
--- a/src/system/system_generic.ml
+++ b/src/system/system_generic.ml
@@ -47,7 +47,7 @@ let open_out_gen = open_out_gen
 let chmod = Unix.chmod
 let chown = Unix.chown
 let utimes = Unix.utimes
-let link = Unix.link
+let link s d = Unix.link s d
 let openfile = Unix.openfile
 let opendir f =
   let h = Unix.opendir f in
diff --git a/src/uigtk2.ml b/src/uigtk2.ml
--- a/src/uigtk2.ml
+++ b/src/uigtk2.ml
@@ -89,12 +89,12 @@ let fontItalic = lazy (Pango.Font.from_string "italic")
 (* This does not work with the current version of Lablgtk, due to a bug
 let icon =
   GdkPixbuf.from_data ~width:48 ~height:48 ~has_alpha:true
-    (Gpointer.region_of_string Pixmaps.icon_data)
+    (Gpointer.region_of_bytes Pixmaps.icon_data)
 *)
 let icon =
   let p = GdkPixbuf.create ~width:48 ~height:48 ~has_alpha:true () in
   Gpointer.blit
-    (Gpointer.region_of_string Pixmaps.icon_data) (GdkPixbuf.get_pixels p);
+    (Gpointer.region_of_bytes Pixmaps.icon_data) (GdkPixbuf.get_pixels p);
   p

 let leftPtrWatch =
