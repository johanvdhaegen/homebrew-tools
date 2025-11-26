class Pdfminer < Formula
  include Language::Python::Virtualenv

  desc "Tool for extracting information from PDF documents"
  homepage "https://github.com/pdfminer/pdfminer.six"
  url "https://files.pythonhosted.org/packages/1d/50/5315f381a25dc80a8d2ea7c62d9a28c0137f10ccc263623a0db8b49fcced/pdfminer_six-20251107.tar.gz"
  sha256 "5fb0c553799c591777f22c0c72b77fc2522d7d10c70654e25f4c5f1fd996e008"
  license "MIT"
  head "https://github.com/pdfminer/pdfminer.six.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/pdfminer-20251107"
    sha256 cellar: :any,                 arm64_sequoia: "b0560eb5092c8452285f6c3d5e37e48d0e32ca59b3b72f42daf2963710163ea9"
    sha256 cellar: :any,                 arm64_sonoma:  "4ff764488fa75cc9c874b38b0f4d986abc5e65399d4c55baa45145b809fae18d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af4c3dec1a60f4fc316758f39aa40e02867417b70deae1c8bc552109a5f5787e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df2d88a33d520aa01fab36aace5be3ee5ae7fcefc5d1b65c88c67672697fb57b"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "libffi"
  depends_on "openssl@3"
  depends_on "python@3.12"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/eb/56/b1ba7935a17738ae8453301356628e8147c79dbb825bcbc73dc7401f9846/cffi-2.0.0.tar.gz"
    sha256 "44d1b5909021139fe36001ae048dbdde8214afa20200eda0f64c068cac5d5529"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9f/33/c00162f49c0e2fe8064a62cb92b93e50c74a72bc370ab92f86112b33ff62/cryptography-46.0.3.tar.gz"
    sha256 "a8b17438104fed022ce745b362294d9ce35b4c2e45c1d958ad4a4b019285f4a1"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/fe/cf/d2d3b9f5699fb1e4615c8e32ff220203e43b248e1dfcc6736ad9057731ca/pycparser-2.23.tar.gz"
    sha256 "78816d4f24add8f10a06d6f05b4d424ad9e96cfebf68a4ddc99c65c0720d00c2"
  end

  def install
    python3 = "python3"
    venv = virtualenv_create(libexec, python3)
    ENV.prepend_create_path "PYTHONPATH",
                            libexec/Language::Python.site_packages(python3)

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
