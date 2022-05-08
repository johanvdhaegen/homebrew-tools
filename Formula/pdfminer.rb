class Pdfminer < Formula
  include Language::Python::Virtualenv

  desc "Tool for extracting information from PDF documents"
  homepage "https://github.com/pdfminer/pdfminer.six"
  url "https://files.pythonhosted.org/packages/d8/df/b2af9773a03f813adb3b17bf82c5195a4894a7416b35a75959408822e076/pdfminer.six-20220506.tar.gz"
  sha256 "3d65c1a0f4a0465c709e191550ec77a684ebe0bcb562337ccbfb7aa228c52076"
  license "MIT"

  head "https://github.com/pdfminer/pdfminer.six.git", branch: "develop"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/pdfminer-20220506"
    sha256 cellar: :any,                 big_sur:      "04ebd7dac48b801a4ae36b5e9b6bf58cb28bc3c6bb848cc6fb1ca94d3d6b9f75"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fb0fd69b2c02a854c59774a74fa418f4fbcb7d4197ccebb3e1c1035251b4ee6c"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/51/05/bb2b681f6a77276fc423d04187c39dafdb65b799c8d87b62ca82659f9ead/cryptography-37.0.2.tar.gz"
    sha256 "f224ad253cc9cea7568f49077007d2263efa57396a2f2f78114066fd54b5c68e"
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
