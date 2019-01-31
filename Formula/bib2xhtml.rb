class Bib2xhtml < Formula
  desc "Convert BibTeX Files into HTML"
  homepage "https://www.spinellis.gr/sw/textproc/bib2xhtml"
  url "https://www.spinellis.gr/sw/textproc/bib2xhtml/bib2xhtml-v3.0-79-ge935.tar.gz"
  version "3.0-79-ge935"
  sha256 "4a2d2d89dd2f3fed1c735055b806809b5cc1cde32dee1aa5987097ec5bf2181f"

  def install
    ENV.prepend_create_path "BSTINPUTS", libexec
    bin.install "bib2xhtml"
    libexec.install Dir["*.bst"]
    bin.env_script_all_files(libexec+"bin", :BSTINPUTS => ENV["BSTINPUTS"])
  end

  test do
    (testpath/"test.bib").write <<~EOS
      @Unpublished{ref,
        author       = {Me and Myself and I},
        title        = {Work 1},
        note         = {Not published}
      }
    EOS
    output = shell_output("#{bin}/bib2xhtml test.bib")
    assert_match(
      /<!-- BEGIN BIBLIOGRAPHY test -->(.|\\n)*<!-- END BIBLIOGRAPHY test -->/m,
      output,
    )
    assert_match("<li><a name=\"ref\"></a>Me", output)
  end
end
