class Pyink < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https://github.com/google/pyink"

  url "https://files.pythonhosted.org/packages/c6/ff/91f974f39fbd260d1f676866679421ccf9e833c7a8fb5711e9806459dce1/pyink-23.12.1.tar.gz"
  sha256 "cc940ec3b1c0f746c61e10f1e28a5b69a274da20843e14ee14fbb4130b3a4853"
  license "MIT"
  head "https://github.com/google/pyink.git", branch: "pyink"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/pyink-23.12.1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "4a7870a77eaa8f0b1490665e36f206e7f4cc6446b0cd4de29367cefcc87eda63"
    sha256 cellar: :any_skip_relocation, ventura:      "a1ed04032e970e54203eccbcea68f6c1004a8149c92dc418a0981a0506762169"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "78610841bc4d16799ca00b635408fefdab17254c4d0724e69c88a1d7403937d3"
  end

  depends_on "python@3.11"

  resource "black" do
    url "https://files.pythonhosted.org/packages/fd/f4/a57cde4b60da0e249073009f4a9087e9e0a955deae78d3c2a493208d0c5c/black-23.12.1.tar.gz"
    sha256 "4ce3ef14ebe8d9509188014d96af1c456a910d5b5cbf434a09fef7e024b3d0d5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/62/d1/7feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9a/platformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"pyink_test.py").write <<~EOS
      print(
      'It works!')
    EOS
    system bin/"pyink", "pyink_test.py"
    assert_equal "print(\"It works!\")\n", (testpath/"pyink_test.py").read
  end
end
