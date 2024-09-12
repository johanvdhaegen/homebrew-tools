class Pyink < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https://github.com/google/pyink"

  url "https://files.pythonhosted.org/packages/b6/c6/71645f7d17601bcc2cf33d6ad3ca5e1849b2f4576c1202aa48e77deaf6e5/pyink-24.8.0.tar.gz"
  sha256 "90468db7148bcef7d4ceb3513f75346331f4f61cc13db940d996728602925603"
  license "MIT"
  head "https://github.com/google/pyink.git", branch: "pyink"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/pyink-24.8.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "01eb550935b47a2a370e62a8d7f1aec2e1de119f2f4390253367ed6574e30689"
    sha256 cellar: :any_skip_relocation, ventura:      "4bbd918bba8ea35b06cc95790392234b71153ceccd3a7d946672345bc782f060"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "17ea8582cbe19be0e9779f3200a5ab501dba6e7474b0effe7276c3dd287df9a7"
  end

  depends_on "python@3.12"

  resource "black" do
    url "https://files.pythonhosted.org/packages/04/b0/46fb0d4e00372f4a86a6f8efa3cb193c9f64863615e39010b1477e010578/black-24.8.0.tar.gz"
    sha256 "2500945420b6784c38b9ee885af039f5e7471ef284ab03fa35ecdde4688cd83f"
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
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/75/a0/d7cab8409cdc7d39b037c85ac46d92434fb6595432e069251b38e5c8dd0e/platformdirs-4.3.2.tar.gz"
    sha256 "9e5e27a08aa095dd127b9f2e764d74254f482fef22b0970773bfba79d091ab8c"
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
