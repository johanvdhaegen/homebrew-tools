class Bib2xhtml < Formula
  desc "Convert BibTeX Files into HTML"
  homepage "http://www.spinellis.gr/sw/textproc/bib2xhtml"
  url "http://www.spinellis.gr/sw/textproc/bib2xhtml/bib2xhtml-v3.0-15-gf506.tar.gz"
  version "3.0.15-gf506"
  sha256 "e848bde6116ae86a3331961fd296ec20e4e856bf9ed98664b2db365aabfd2840"

  depends_on :tex

  def install
    ENV.prepend_create_path "BSTINPUTS", libexec

    #resources.each do |r|
    #  r.stage do
    #    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    #    system "make"
    #    system "make", "install"
    #  end
    #end

    bin.install "bib2xhtml"
    libexec.install Dir["*.bst"]
    bin.env_script_all_files(libexec+"bin", :BSTINPUTS => ENV["BSTINPUTS"])
  end
end
