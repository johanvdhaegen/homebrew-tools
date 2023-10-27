class Pyink < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https://github.com/google/pyink"

  url "https://files.pythonhosted.org/packages/4c/7f/21a6deb2230ca8a6c30c519ba4cdc1aaf83529218c89ba8333af7e948dfe/pyink-23.10.0.tar.gz"
  sha256 "99742f8a30b36e39898d2f5dde65fdb27100ce2cc2b48273e950c18338d657fa"
  license "MIT"
  head "https://github.com/google/pyink.git", branch: "pyink"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/pyink-23.10.0"
    sha256 cellar: :any_skip_relocation, ventura:      "d911cb479406c9632a40c48fa856d9908078a3bfdb475f63f717f18f601ce3af"
    sha256 cellar: :any_skip_relocation, monterey:     "d8ec8517070f1fe7165783a42ec45837b1137fc80681beda4546b0a4f034c5ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f109f701ca42db47d927f241ddeee48a64c73336325c4fd6f0c9efa53146e3a5"
  end

  depends_on "python@3.11"

  resource "black" do
    url "https://files.pythonhosted.org/packages/2d/e0/8433441b0236b9d795ffbf5750f98144e0378b6e20401ba4d2db30b99a5c/black-23.10.0.tar.gz"
    sha256 "31b9f87b277a68d0e99d2905edae08807c007973eaa609da5f0c62def6b7c0bd"
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
    url "https://files.pythonhosted.org/packages/a0/2a/bd167cdf116d4f3539caaa4c332752aac0b3a0cc0174cdb302ee68933e81/pathspec-0.11.2.tar.gz"
    sha256 "e0d8d0ac2f12da61956eb2306b69f9469b42f4deb0f3cb6ed47b9cce9996ced3"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d3/e3/aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5/platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
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
