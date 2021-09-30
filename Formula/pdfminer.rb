class Pdfminer < Formula
  include Language::Python::Virtualenv

  desc "Tool for extracting information from PDF documents"
  homepage "https://github.com/pdfminer/pdfminer.six"
  url "https://files.pythonhosted.org/packages/d8/bb/45cb24e715d3058f92f703265e6ed396767b19fec6d19d1ea54e04b730b7/pdfminer.six-20201018.tar.gz"
  sha256 "b9aac0ebeafb21c08bf65f2039f4b2c5f78a3449d0a41df711d72445649e952a"
  license "MIT"

  head "https://github.com/pdfminer/pdfminer.six.git", branch: "develop"

  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/cb/ae/380e33d621ae301770358eb11a896a34c34f30db188847a561e8e39ee866/cffi-1.14.3.tar.gz"
    sha256 "f92f789e4f9241cd262ad7a555ca2c648a98178a953af117ef7fad46aa1d5591"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/5d/4b/7bb135c5787c003cdbc44990c5f41908f0f37135e0bb554e880d90fd5f6f/cryptography-3.1.1.tar.gz"
    sha256 "9d9fc6a16357965d282dd4ab6531013935425d0dc4950df2e0cf2a1b1ac1017d"
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
