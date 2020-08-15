class Pdfminer < Formula
  include Language::Python::Virtualenv

  desc "Tool for extracting information from PDF documents"
  homepage "https://github.com/pdfminer/pdfminer.six"
  url "https://files.pythonhosted.org/packages/71/a3/155c5cde5f9c0b1069043b2946a93f54a41fd72cc19c6c100f6f2f5bdc15/pdfminer-20191125.tar.gz"
  sha256 "9e700bc731300ed5c8936343c1dd4529638184198e54e91dd2b59b64a755dc01"
  license "MIT"

  head "https://github.com/pdfminer/pdfminer.six.git"

  depends_on "python@3.8"

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/4c/2b/eddbfc56076fae8deccca274a5c70a9eb1e0b334da0a33f894a420d0fe93/pycryptodome-3.9.8.tar.gz"
    sha256 "0e24171cf01021bc5dc17d6a9d4f33a048f09d62cc3f62541e95ef104588bda4"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/3b/fb/48f6fa11e4953c530b09fa0f2976df5234b0eaabcd158625c3e73535aeb8/sortedcontainers-2.2.2.tar.gz"
    sha256 "4e73a757831fc3ca4de2859c422564239a31d8213d09a2a666e375807034d2ba"
  end

  def install
    # virtualenv_install_with_resources
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH",
                            libexec/"lib/python#{pyver}/site-packages"
    venv = virtualenv_create(libexec, "python3")

    venv.pip_install resources
    venv.pip_install buildpath

    env = { PYTHONPATH: ENV["PYTHONPATH"] }
    (bin/"dumppdf").write_env_script(libexec/"bin/dumppdf.py", env)
    (bin/"pdf2txt").write_env_script(libexec/"bin/pdf2txt.py", env)
  end

  test do
    (testpath/"test.pdf").write <<~EOS
      %PDF-1.4
      1 0 obj
        << /Type /Catalog
           /Outlines 2 0 R
           /Pages 3 0 R
        >>
      endobj

      2 0 obj
        << /Type /Outlines
           /Count 0
        >>
      endobj

      3 0 obj
        << /Type /Pages
           /Kids [4 0 R]
           /Count 1
        >>
      endobj

      4 0 obj
        << /Type /Page
           /Parent 3 0 R
           /MediaBox [0 0 612 792]
           /Contents 5 0 R
           /Resources <<  /ProcSet 6 0 R
                          /Font << /F1 7 0 R >>
                      >>
        >>
      endobj

      5 0 obj
        << /Length 60 >>
      stream
        BT
          /F1 24 Tf
          100 100 Td
          (Hello World) Tj
        ET
      endstream
      endobj

      6 0 obj
        [/PDF /Text]
      endobj

      7 0 obj
        << /Type /Font
           /Subtype /Type1
           /Name /F1
           /BaseFont /Helvetica
        >>
      endobj

      xref
      0 8
      0000000000 65536 f
      0000000009 00000 n
      0000000089 00000 n
      0000000145 00000 n
      0000000217 00000 n
      0000000420 00000 n
      0000000532 00000 n
      0000000563 00000 n

      trailer
        << /Size 8
           /Root 1 0 R
        >>
      startxref
      663
      %%EOF
    EOS

    assert_match(/Hello World/, shell_output("#{bin}/pdf2txt test.pdf"))
  end
end
