class Pdfminer < Formula
  include Language::Python::Virtualenv

  desc "Tool for extracting information from PDF documents"
  homepage "https://github.com/pdfminer/pdfminer.six"
  url "https://files.pythonhosted.org/packages/e3/37/63cb918ffa21412dd5d54e32e190e69bfc340f3d6aa072ad740bec9386bb/pdfminer.six-20240706.tar.gz"
  sha256 "c631a46d5da957a9ffe4460c5dce21e8431dabb615fee5f9f4400603a58d95a6"
  license "MIT"

  head "https://github.com/pdfminer/pdfminer.six.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/pdfminer-20240706"
    sha256 cellar: :any,                 arm64_sonoma: "2cc06e166b94b4ed9020b2bb9ea7d703a52140832cfeb94256ad05ec75eaeb13"
    sha256 cellar: :any,                 ventura:      "6f1ce4150714f249fc383f8272789ccd3fd2b48bc953516b8f8cd1c8a911ea4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "00d6a425a5a57fdef6538accc6c09b94a839df73fb290fcddc16266a36d80e68"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "libffi"
  depends_on "openssl@3"
  depends_on "python@3.12"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/68/ce/95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91d/cffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/93/a7/1498799a2ea06148463a9a2c10ab2f6a921a74fb19e231b27dc412a748e2/cryptography-42.0.8.tar.gz"
    sha256 "8d09d05439ce7baa8e9e95b07ec5b6c886f548deb7e0f69ef25f64b3bce842f2"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
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
