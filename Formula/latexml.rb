class Latexml < Formula
  desc "LaTeX to XML/HTML/MathML Converter"
  homepage "https://dlmf.nist.gov/LaTeXML/"
  url "https://dlmf.nist.gov/LaTeXML/releases/LaTeXML-0.8.6.tar.gz"
  sha256 "9529c651b67f5e8ddef1fd1852f974e756a17b711c46d4118f0677ad0e6e9bb1"
  license :public_domain
  head "https://github.com/brucemiller/LaTeXML.git", branch: "master"
  revision 1

  livecheck do
    url "https://dlmf.nist.gov/LaTeXML/get.html"
    regex(/href=.*?LaTeXML[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "pkg-config" => :build
  depends_on "perl"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "Image::Size" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJRAY/Image-Size-3.300.tar.gz"
    sha256 "53c9b1f86531cde060ee63709d1fda73cabc0cf2d581d29b22b014781b9f026b"
  end

  resource "Text::Unidecode" do
    url "https://cpan.metacpan.org/authors/id/S/SB/SBURKE/Text-Unidecode-1.30.tar.gz"
    sha256 "6c24f14ddc1d20e26161c207b73ca184eed2ef57f08b5fb2ee196e6e2e88b1c6"
  end

  resource "Path::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.130.tar.gz"
    sha256 "74109aec04ddd83d80ee14a5346e8bc3e3f4673238e1c7358693bff348196c13"
  end

  resource "IO::String" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/IO-String-1.08.tar.gz"
    sha256 "2a3f4ad8442d9070780e58ef43722d19d1ee21a803bf7c8206877a10482de5a0"
  end

  resource "File::Chdir" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/File-chdir-0.1010.tar.gz"
    sha256 "efc121f40bd7a0f62f8ec9b8bc70f7f5409d81cd705e37008596c8efc4452b01"
  end

  resource "Capture::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz"
    sha256 "6c23113e87bad393308c90a207013e505f659274736638d8c79bac9c67cc3e19"
  end

  resource "File::Which" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.27.tar.gz"
    sha256 "3201f1a60e3f16484082e6045c896842261fc345de9fb2e620fd2a2c7af3a93a"
  end

  resource "Archive::Zip" do
    url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/Archive-Zip-1.68.tar.gz"
    sha256 "984e185d785baf6129c6e75f8eb44411745ac00bf6122fb1c8e822a3861ec650"
  end

  resource "Alien::Build" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-2.42.tar.gz"
    sha256 "517c99c69fd236e106c1827896bd8562d7768043cc11bfbc399d55e95a63b791"
  end

  resource "Alien::LibXML2" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Libxml2-0.17.tar.gz"
    sha256 "73b45244f0b5c36e5332c33569b82a1ab2c33e263f1d00785d2003bcaec68db3"
  end

  resource "LWP" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.57.tar.gz"
    sha256 "30c242359cb808f3fe2b115fb90712410557f0786ad74844f9801fd719bc42f8"
  end

  resource "Parse::RecDescent" do
    url "https://cpan.metacpan.org/authors/id/J/JT/JTBRAUN/Parse-RecDescent-1.967015.tar.gz"
    sha256 "1943336a4cb54f1788a733f0827c0c55db4310d5eae15e542639c9dd85656e37"
  end

  resource "XML::LibXML" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXML-2.0208.tar.gz"
    sha256 "0c006b03bf8d0eb531fb56bda3ae15754ca56d888dd7b9e805ab9eb19d5fd653"
  end

  resource "XML::Sax" do
    url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-Base-1.09.tar.gz"
    sha256 "66cb355ba4ef47c10ca738bd35999723644386ac853abbeb5132841f5e8a2ad0"
  end

  resource "XML::LibXSLT" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXSLT-1.99.tar.gz"
    sha256 "127e17a877fb61e47b9e8b87bf8daad31339a62a00121f9751d522b438b0f7f0"
  end

  resource "URI" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.16.tar.gz"
    sha256 "4cd2752adfaddd58f54e559155578696354834ee77a7760a04089de1f338fb11"
  end

  resource "HTTP::Request" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.33.tar.gz"
    sha256 "23b967f71b852cb209ec92a1af6bac89a141dff1650d69824d29a345c1eceef7"
  end

  resource "Canary::Stability" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/Canary-Stability-2013.tar.gz"
    sha256 "a5c91c62cf95fcb868f60eab5c832908f6905221013fea2bce3ff57046d7b6ea"
  end

  resource "JSON::XS" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/JSON-XS-4.03.tar.gz"
    sha256 "515536f45f2fa1a7e88c8824533758d0121d267ab9cb453a1b5887c8a56b9068"
  end

  resource "Pod::Find" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MAREKR/Pod-Parser-1.65.tar.gz"
    sha256 "3ba7bdec659416a51fe2a7e59f0883e9c6a3b21bc9d001042c1d6a32d401b28a"
  end

  resource "HTTP::Date" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.05.tar.gz"
    sha256 "365d6294dfbd37ebc51def8b65b81eb79b3934ecbc95a2ec2d4d827efe6a922b"
  end

  resource "Try::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.31.tar.gz"
    sha256 "3300d31d8a4075b26d8f46ce864a1d913e0e8467ceeba6655d5d2b2e206c11be"
  end

  resource "Encode::Locale" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
    sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        ENV["PERL_CANARY_STABILITY_NOPROMPT"] = "1"

        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make", "install"
    doc.install "manual.pdf"
    (libexec/"bin").find.each do |path|
      next if path.directory?

      program = path.basename
      (bin/program).write_env_script("#{libexec}/bin/#{program}", PERL5LIB: ENV["PERL5LIB"])
    end
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\title{LaTeXML Homebrew Test}
      \\begin{document}
      \\maketitle
      \\end{document}
    EOS
    assert_match %r{<title>LaTeXML Homebrew Test</title>},
      shell_output("#{bin}/latexml --quiet #{testpath}/test.tex")
  end
end
