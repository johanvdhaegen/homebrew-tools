class Pyink < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https://github.com/google/pyink"

  url "https://files.pythonhosted.org/packages/e3/6e/f44c822f67725cad89e1e8c15fc620a695a9e34c7f3da44376d7a0407dc4/pyink-24.3.0.tar.gz"
  sha256 "0ac418875461fca73b4ba85b49a6b4598accdbe003ef1f31c5c5d72c2a354dda"
  license "MIT"
  head "https://github.com/google/pyink.git", branch: "pyink"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/pyink-24.3.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "9990c9ba04a15cd6c51a8b95002cc1ac5be198533ff14d97403b8f26aa220c98"
    sha256 cellar: :any_skip_relocation, ventura:      "5d4c02ecd54f2fab904895b1c33fae18241a73fad92a9a7f7ff836442010d576"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ec9d108bc412b2739ac89577bc2e3cf92bbe0514283f4b0819a11cb6975da499"
  end

  depends_on "python@3.11"

  resource "black" do
    url "https://files.pythonhosted.org/packages/8f/5f/bac24a952668c7482cfdb4ebf91ba57a796c9da8829363a772040c1a3312/black-24.3.0.tar.gz"
    sha256 "a0c9c4a0771afc6919578cec71ce82a3e31e054904e7197deacbc9382671c41f"
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
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
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
