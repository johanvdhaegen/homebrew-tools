class Pdfminer < Formula
  include Language::Python::Virtualenv

  desc "Tool for extracting information from PDF documents"
  homepage "https://github.com/pdfminer/pdfminer.six"
  url "https://files.pythonhosted.org/packages/ac/6e/89c532d108e362cbaf76fdb972e7a5e85723c225f08e1646fb86878d4f7f/pdfminer.six-20221105.tar.gz"
  sha256 "8448ab7b939d18b64820478ecac5394f482d7a79f5f7eaa7703c6c959c175e1d"
  license "MIT"
  revision 1

  head "https://github.com/pdfminer/pdfminer.six.git", branch: "develop"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/pdfminer-20221105_1"
    sha256 cellar: :any,                 ventura:      "069f42133097424874a38db0fb67ebf88179868f88235cf3a2cf7fbe10726c82"
    sha256 cellar: :any,                 monterey:     "16f1f8f7732c62b81434e0459f479aa9e863e83990a3ca4723f418304a69e1d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6b10a2503566d934d41a35bfe26a489511838057460c14805466b8d5ed7c2bfe"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f7/80/04cc7637238b78f8e7354900817135c5a23cf66dfb3f3a216c6d630d6833/cryptography-40.0.2.tar.gz"
    sha256 "c33c0d32b8594fa647d2e01dbccc303478e16fdd7cf98652d5b3ed11aa5e5c99"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  def install
    # virtualenv_install_with_resources
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH",
                            libexec/"lib/python#{pyver}/site-packages"
    venv = virtualenv_create(libexec, "python3")

    resources.each do |r|
      r.stage do
        system libexec/"bin/python", "-m", "pip", "wheel", "-w", "dist", "."
        venv.pip_install Dir["dist/#{r.name.tr("-", "_")}*.whl"].first
      end
    end
    venv.pip_install buildpath

    env = { PYTHONPATH: ENV["PYTHONPATH"] }
    (bin/"dumppdf").write_env_script(libexec/"bin/dumppdf.py", env)
    (bin/"pdf2txt").write_env_script(libexec/"bin/pdf2txt.py", env)
  end

  test do
    require "base64"
    (testpath/"test.pdf").write ::Base64.decode64 <<~EOS
      JVBERi0xLjQKMSAwIG9iagogIDw8IC9UeXBlIC9DYXRhbG9nCiAgICAgL091dGxp
      bmVzIDIgMCBSCiAgICAgL1BhZ2VzIDMgMCBSCiAgPj4KZW5kb2JqCgoyIDAgb2Jq
      CiAgPDwgL1R5cGUgL091dGxpbmVzCiAgICAgL0NvdW50IDAKICA+PgplbmRvYmoK
      CjMgMCBvYmoKICA8PCAvVHlwZSAvUGFnZXMKICAgICAvS2lkcyBbNCAwIFJdCiAg
      ICAgL0NvdW50IDEKICA+PgplbmRvYmoKCjQgMCBvYmoKICA8PCAvVHlwZSAvUGFn
      ZQogICAgIC9QYXJlbnQgMyAwIFIKICAgICAvTWVkaWFCb3ggWzAgMCA2MTIgNzky
      XQogICAgIC9Db250ZW50cyA1IDAgUgogICAgIC9SZXNvdXJjZXMgPDwgIC9Qcm9j
      U2V0IDYgMCBSCiAgICAgICAgICAgICAgICAgICAgL0ZvbnQgPDwgL0YxIDcgMCBS
      ID4+CiAgICAgICAgICAgICAgICA+PgogID4+CmVuZG9iagoKNSAwIG9iagogIDw8
      IC9MZW5ndGggNjAgPj4Kc3RyZWFtCiAgQlQKICAgIC9GMSAyNCBUZgogICAgMTAw
      IDEwMCBUZAogICAgKEhlbGxvIFdvcmxkKSBUagogIEVUCmVuZHN0cmVhbQplbmRv
      YmoKCjYgMCBvYmoKICBbL1BERiAvVGV4dF0KZW5kb2JqCgo3IDAgb2JqCiAgPDwg
      L1R5cGUgL0ZvbnQKICAgICAvU3VidHlwZSAvVHlwZTEKICAgICAvTmFtZSAvRjEK
      ICAgICAvQmFzZUZvbnQgL0hlbHZldGljYQogID4+CmVuZG9iagoKeHJlZgowIDgK
      MDAwMDAwMDAwMCA2NTUzNiBmIAowMDAwMDAwMDA5IDAwMDAwIG4gCjAwMDAwMDAw
      ODkgMDAwMDAgbiAKMDAwMDAwMDE0NSAwMDAwMCBuIAowMDAwMDAwMjE3IDAwMDAw
      IG4gCjAwMDAwMDA0MjAgMDAwMDAgbiAKMDAwMDAwMDUzMiAwMDAwMCBuIAowMDAw
      MDAwNTYzIDAwMDAwIG4gCgp0cmFpbGVyCiAgPDwgL1NpemUgOAogICAgIC9Sb290
      IDEgMCBSCiAgPj4Kc3RhcnR4cmVmCjY2MwolJUVPRgo=
    EOS

    assert_match(/Hello World/, shell_output("#{bin}/pdf2txt test.pdf"))
  end
end
