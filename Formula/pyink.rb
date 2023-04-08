class Pyink < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https://github.com/google/pyink"

  url "https://files.pythonhosted.org/packages/38/a8/6e050ca1d2ef15df358822fc1943f5bf350dbd822a88ef724f3d13e6a4b9/pyink-23.3.1.tar.gz"
  sha256 "c252688d2c20cd00033a4b8aa74781f059a06481701d88453b99ca844e9d5d87"
  license "MIT"
  head "https://github.com/google/pyink.git", branch: "pyink"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/pyink-23.3.1"
    sha256 cellar: :any_skip_relocation, monterey:     "682ff4a23d4866917374bde199f7978ba9af940acf08b75a2eab3c1f2a1f5c28"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e1164488ab4e7ef657f0cd061032fc06039815fd0f2f3253d21c1218fb644ced"
  end

  depends_on "python@3.10"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/95/60/d93628975242cc515ab2b8f5b2fc831d8be2eff32f5a1be4776d49305d13/pathspec-0.11.1.tar.gz"
    sha256 "2798de800fa92780e33acca925945e9a19a133b715067cf165b8866c15a31687"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/15/04/3f882b46b454ab374ea75425c6f931e499150ec1385a73e55b3f45af615a/platformdirs-3.2.0.tar.gz"
    sha256 "d5b638ca397f25f979350ff789db335903d7ea010ab28903f57b27e1b16c2b08"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/d6/36/66370f5017b100225ec4950a60caeef60201a10080da57ddb24124453fba/black-23.3.0.tar.gz"
    sha256 "1c7b8d606e728a41ea1ccbd7264677e494e87cf630e399262ced92d4a8dac940"
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
