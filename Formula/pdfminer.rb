class Pdfminer < Formula
  include Language::Python::Virtualenv

  desc "Tool for extracting information from PDF documents"
  homepage "https://github.com/pdfminer/pdfminer.six"
  url "https://files.pythonhosted.org/packages/ac/0a/b01677bb31bd79756f05ff3e052ad369ac0ebb2e64b47fc6d6bad290d981/pdfminer.six-20211012.tar.gz"
  sha256 "0351f17d362ee2d48b158be52bcde6576d96460efd038a3e89a043fba6d634d7"
  license "MIT"

  head "https://github.com/pdfminer/pdfminer.six.git", branch: "develop"

  depends_on "rust" => :build # for cryptography
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
    url "https://files.pythonhosted.org/packages/2e/92/87bb61538d7e60da8a7ec247dc048f7671afe17016cd0008b3b710012804/cffi-1.14.6.tar.gz"
    sha256 "c9a875ce9d7fe32887784274dd533c57909b7b1dcadcc128a2ac21331a9765dd"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/12/22/6ba3031e7cbd6eb002e13ffc7397e136df95813b6a2bd71ece52a8f89613/setuptools-rust-0.12.1.tar.gz"
    sha256 "647009e924f0ae439c7f3e0141a184a69ad247ecb9044c511dabde232d3d570e"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/91/90b8d4cd611ac2aa526290ae4b4285aa5ea57ee191c63c2f3d04170d7683/cryptography-35.0.0.tar.gz"
    sha256 "9933f28f70d0517686bd7de36166dda42094eac49415459d9bdf5e7df3e0086d"
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
