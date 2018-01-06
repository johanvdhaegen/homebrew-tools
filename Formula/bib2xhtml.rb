class Bib2xhtml < Formula
  desc "Convert BibTeX Files into HTML"
  homepage "http://www.spinellis.gr/sw/textproc/bib2xhtml"
  url "https://www.spinellis.gr/sw/textproc/bib2xhtml/bib2xhtml-v3.0-54-g5c30.tar.gz"
  version "3.0.54-g5c30"
  sha256 "1025afe15daf7d6083d4f249c9d9289951611a8d3bc4c3be4c9a78f911b914c8"

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
