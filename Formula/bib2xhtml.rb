class Bib2xhtml < Formula
  desc "Convert BibTeX Files into HTML"
  homepage "https://www.spinellis.gr/sw/textproc/bib2xhtml"
  url "https://www.spinellis.gr/sw/textproc/bib2xhtml/bib2xhtml-v3.0-56-gd8f4.tar.gz"
  version "3.0.56-gd8f4"
  sha256 "7034b49ca14807196e4cf737e8b7a4624ae26d240877203ed2e4cde01008a949"

  depends_on :tex

  def install
    ENV.prepend_create_path "BSTINPUTS", libexec

    # resources.each do |r|
    #   r.stage do
    #     system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    #     system "make"
    #     system "make", "install"
    #   end
    # end

    bin.install "bib2xhtml"
    libexec.install Dir["*.bst"]
    bin.env_script_all_files(libexec+"bin", :BSTINPUTS => ENV["BSTINPUTS"])
  end
end
