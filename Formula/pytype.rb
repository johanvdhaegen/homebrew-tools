class Pytype < Formula
  include Language::Python::Virtualenv

  desc "Static analyzer for Python code"
  homepage "https://github.com/google/pytype/"
  url "https://files.pythonhosted.org/packages/9c/7a/6fd33673f9c7b9e5f4f8107028c323b1c72acc0f909f1b9b3391a31ea604/pytype-2024.10.11.tar.gz"
  sha256 "ae5ff82f0b07d5ad68d4ec32a3e8de44fad6ed565a821a76aca50a14df382274"
  license "Apache-2.0"

  head "https://github.com/google/pytype.git", branch: "main"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/pytype-2024.10.11"
    sha256 cellar: :any,                 arm64_sonoma: "8caf78e17f7e3935b8163c5c7e35c7c294450e7c3a54bf8bf191489d38c00c53"
    sha256 cellar: :any,                 ventura:      "9dba88dfb739bfbd5f7a41972effc7a25b2b81eb0ea61ebc82a52b58df77024a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "254ccd88b4bd376965dc2a93c24c11236bb14a80791fe2b103d8a7712c1b5194"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "immutabledict" do
    url "https://files.pythonhosted.org/packages/55/f4/710c84db4d77767176342913ac6b25f43aaed6d0a0bdb9168a8d2936d9c7/immutabledict-4.2.0.tar.gz"
    sha256 "e003fd81aad2377a5a758bf7e1086cf3b70b63e9a5cc2f46bce8d0a2b4727c5f"
  end

  resource "importlab" do
    url "https://files.pythonhosted.org/packages/f5/22/ab9494dccf1e237276f98364d53673bc0ab97ebe5cb671e960f18710457d/importlab-0.8.1.tar.gz"
    sha256 "b3893853b1f6eb027da509c3b40e6787e95dd66b4b66f1b3613aad77556e1465"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "libcst" do
    url "https://files.pythonhosted.org/packages/4d/c4/5577b92173199299e0d32404aa92a156d353d6ec0f74148f6e418e0defef/libcst-1.5.0.tar.gz"
    sha256 "8478abf21ae3861a073e898d80b822bd56e578886331b33129ba77fec05b8c24"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b4/d2/38ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8f/markupsafe-3.0.1.tar.gz"
    sha256 "3e683ee4f5d0fa2dde4db77ed8dd8a876686e3fc417655c2ece9a90576905344"
  end

  resource "msgspec" do
    url "https://files.pythonhosted.org/packages/5e/fb/42b1865063fddb14dbcbb6e74e0a366ecf1ba371c4948664dde0b0e10f95/msgspec-0.18.6.tar.gz"
    sha256 "a59fc3b4fcdb972d09138cb516dbde600c99d07c38fd9372a6ef500d2d031b4e"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/36/2b/20ad9eecdda3f1b0dc63fb8f82d2ea99163dbca08bfa392594fc2ed81869/networkx-3.4.1.tar.gz"
    sha256 "f9df45e85b78f5bd010993e897b4f1fdb242c11e015b101bd951e5c0e29982d8"
  end

  resource "ninja" do
    url "https://files.pythonhosted.org/packages/37/2c/d717d13a413d6f7579cdaa1e28e6e2c98de95461549b08d311c8a5bf4c51/ninja-1.11.1.1.tar.gz"
    sha256 "9d793b08dd857e38d0b6ffe9e6b7145d7c485a42dcfea04905ca0cdb6017cc3c"
  end

  resource "pybind11" do
    url "https://files.pythonhosted.org/packages/d2/c1/72b9622fcb32ff98b054f724e213c7f70d6898baa714f4516288456ceaba/pybind11-2.13.6.tar.gz"
    sha256 "ba6af10348c12b24e92fa086b39cfba0eff619b61ac77c406167d813b096d39a"
  end

  resource "pycnite" do
    url "https://files.pythonhosted.org/packages/26/55/7f412c01675a8c77a9ace64a37d557faebe6740cf7fd619c9bda82b33341/pycnite-2024.7.31.tar.gz"
    sha256 "5125f1c95aef4a23b9bec3b32fae76873dcd46324fa68e39c10fa852ecdea340"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/85/10/4e4da8c271540dc35914e927546cbb821397f0f9477f4079cd8732946699/pydot-3.0.2.tar.gz"
    sha256 "9180da540b51b3aa09fbf81140b3edfbe2315d778e8589a7d0a4a69c41332bae"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8c/d5/e5aeee5387091148a19e1145f63606619cb5f20b83fccb63efae6474e7b2/pyparsing-3.2.0.tar.gz"
    sha256 "cbf74e27246d595d9a74b186b810f6fbb86726dbf3b9532efb343f6d7294fe9c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  def install
    python3 = "python3"
    pyver = Language::Python.major_minor_version(python3)
    venv = virtualenv_create(libexec, python3)
    ENV.prepend_create_path "PYTHONPATH",
                            libexec/Language::Python.site_packages(python3)

    # install all python resources
    resources.each do |r|
      r.stage do
        system libexec/"bin/python", "-m", "pip", "wheel", "-w", "dist", "."
        venv.pip_install Dir["dist/#{r.name.tr("-", "_")}*.whl"].first
      end
    end

    # install pytype
    # remove pyproject.toml to prevent creation of build environment
    # (all requirements have been installed at this point)
    rm "pyproject.toml"
    venv.pip_install_and_link buildpath

    bin.each_child do |f|
      next unless f.symlink?

      symlink = f.realpath
      rm f, verbose: true
      # create wrapper scripts with the correct PATH and PYTHONPATH for pytype
      # to find the python interpreter used to run pytype on PATH
      f.write_env_script(
        symlink,
        {
          PATH:       "#{Formula["python@#{pyver}"].opt_bin}:$PATH",
          PYTHONPATH: ENV["PYTHONPATH"],
        },
      )
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      def make_greeting(user_id) -> str:
          return 'hello, user' + user_id

      def print_greeting() -> None:
          print(make_greeting(0))
    EOS
    output = shell_output("#{bin}/pytype test.py 2>&1", 1)
    assert_match "[unsupported-operands]", output
  end
end
