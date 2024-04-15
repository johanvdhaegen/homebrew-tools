class Pytype < Formula
  include Language::Python::Virtualenv

  desc "Static analyzer for Python code"
  homepage "https://github.com/google/pytype/"
  url "https://files.pythonhosted.org/packages/4a/62/1932134dfd7e9436ba790269f2b337caabe8dca84c0e6e9217a0f88bb147/pytype-2024.4.11.tar.gz"
  sha256 "3315f51ce482d8c07e2f1857c47ccd17beb4a9bfde9afa7d1e6669f1e8881081"
  license "Apache-2.0"

  head "https://github.com/google/pytype.git", branch: "main"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/pytype-2024.4.11"
    sha256 cellar: :any,                 arm64_sonoma: "8585ed09b71c857c40b8c859ffddd6d71e89e487b784e8ba3320885e20ead98b"
    sha256 cellar: :any,                 ventura:      "d5149e018b864b4bca49af442a43f8ff90c9730b5a1956ef7326ea0a3bbd6e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "58e9c669e228fbe81452afd69adbfefe040035ce94eeb9859b3585a223c4c67d"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.11"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
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
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "libcst" do
    url "https://files.pythonhosted.org/packages/f5/7e/11e25b1fc11bcad6b3f3a90fe515406387fe02e6b1ad36dea00ec125ca98/libcst-1.3.1.tar.gz"
    sha256 "03b1df1ae02456f1d465fcd5ead1d0d454bb483caefd8c8e6bde515ffdb53d1b"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "msgspec" do
    url "https://files.pythonhosted.org/packages/5e/fb/42b1865063fddb14dbcbb6e74e0a366ecf1ba371c4948664dde0b0e10f95/msgspec-0.18.6.tar.gz"
    sha256 "a59fc3b4fcdb972d09138cb516dbde600c99d07c38fd9372a6ef500d2d031b4e"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/fd/a1/47b974da1a73f063c158a1f4cc33ed0abf7c04f98a19050e80c533c31f0c/networkx-3.1.tar.gz"
    sha256 "de346335408f84de0eada6ff9fafafff9bcda11f0a0dfaa931133debb146ab61"
  end

  resource "ninja" do
    url "https://files.pythonhosted.org/packages/37/2c/d717d13a413d6f7579cdaa1e28e6e2c98de95461549b08d311c8a5bf4c51/ninja-1.11.1.1.tar.gz"
    sha256 "9d793b08dd857e38d0b6ffe9e6b7145d7c485a42dcfea04905ca0cdb6017cc3c"
  end

  resource "ninja-src" do
    # unix_source_url from NinjaUrls.cmake in ninja python archive
    # https://github.com/scikit-build/ninja-python-distributions/blob/master/NinjaUrls.cmake
    url "https://github.com/Kitware/ninja/archive/refs/tags/v1.11.1.g95dee.kitware.jobserver-1.tar.gz"
    sha256 "7ba84551f5b315b4270dc7c51adef5dff83a2154a3665a6c9744245c122dd0db"
  end

  resource "pybind11" do
    url "https://files.pythonhosted.org/packages/05/3b/23cb81e4cc567c1c4500c0f7ca865225d8cc2a06221099ff5826b99d4e4c/pybind11-2.12.0.tar.gz"
    sha256 "5e3c557a84b06b969247630407fc4d985bed157b4253b13153b8e8e165e0c3dc"
  end

  resource "pycnite" do
    url "https://files.pythonhosted.org/packages/d0/0b/9ff8741c92924e7e54327d24bc2c1300ad2fa86701aedfe1519acc70e323/pycnite-2023.10.11.tar.gz"
    sha256 "ad8616982beecc39f2090999aa8fe0b044b1f6733ec39484cb5e0900b3c88aa1"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/13/6e/916cdf94f9b38ae0777b254c75c3bdddee49a54cc4014aac1460a7a172b3/pydot-1.4.2.tar.gz"
    sha256 "248081a39bcb56784deb018977e428605c1c758f10897a339fce1dd728ff007d"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
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
    url "https://files.pythonhosted.org/packages/f6/f3/b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2/typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "typing-inspect" do
    url "https://files.pythonhosted.org/packages/dc/74/1789779d91f1961fa9438e9a8710cdae6bd138c80d7303996933d117264a/typing_inspect-0.9.0.tar.gz"
    sha256 "b23fc42ff6f6ef6954e4852c1fb512cdd18dbea03134f91f856a95ccc9461f78"
  end

  def install
    pyver = Language::Python.major_minor_version("python3")
    venv = virtualenv_create(libexec, "python3")
    ENV.prepend_create_path "PYTHONPATH",
                            libexec/"lib/python#{pyver}/site-packages"

    # install all python resources, except ninja python bindings
    resources.each do |r|
      next if r.name == "ninja" || r.name =="ninja-src"

      r.stage do
        system libexec/"bin/python", "-m", "pip", "wheel", "-w", "dist", "."
        venv.pip_install Dir["dist/#{r.name.tr("-", "_")}*.whl"].first
      end
    end

    # install ninja python bindings
    [resource("ninja")].each do |r|
      r.stage do
        ninja_deployment_target = MacOS.version.to_s
        dl = resource("ninja-src")
        dl.verify_download_integrity(dl.fetch)
        dl_dir = "_skbuild/macosx-#{ninja_deployment_target}-x86_64-#{pyver}/cmake-build"
        mkdir_p dl_dir
        cp dl.cached_download,
           File.join(dl_dir, File.basename(URI.parse(dl.url).path)),
           verbose: true
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

      # replace symlinks from bin to libexec/bin by copies
      # (otherwise env_script_all_files does not produce the correct result)
      symlink = f.realpath
      rm f, verbose: true
      cp symlink, f, verbose: true
    end

    # pytype needs to find the python interpreter used to run pytype on PATH
    bin.env_script_all_files(
      libexec/"bin",
      PATH:       "#{Formula["python@#{pyver}"].opt_bin}:$PATH",
      PYTHONPATH: ENV["PYTHONPATH"],
    )
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
