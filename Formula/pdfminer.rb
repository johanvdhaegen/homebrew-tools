class Pdfminer < Formula
  include Language::Python::Virtualenv

  desc "Tool for extracting information from PDF documents"
  homepage "https://github.com/pdfminer/pdfminer.six"
  url "https://files.pythonhosted.org/packages/a0/e2/cf4782c86fbe487da3c9aed105878a4af7fbd64c7e3f85403722e6a82dae/pdfminer.six-20220319.tar.gz"
  sha256 "eff2ce0abeaa4df94dc3461f70eab104487c7b4a2b3c7e9fd0aeec6c5f44d6a6"
  license "MIT"

  head "https://github.com/pdfminer/pdfminer.six.git", branch: "develop"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/pdfminer-20220319"
    sha256 cellar: :any,                 big_sur:      "ad51155534c978584b3f2bcb7eb890ae4bbdf8a920c4e28e14f712d71968bad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "45a837ca8a1ecbdf6ff94f86466b2d177729f4f7624a928be9d0e929a413cf00"
  end

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

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/a7/51953e73828deef2b58ba1604de9167843ee9cd4185d8aaffcb45dd1932d/cryptography-36.0.2.tar.gz"
    sha256 "70f8f4f7bb2ac9f340655cbac89d68c527af5bb4387522a8413e841e3e6628c9"
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
