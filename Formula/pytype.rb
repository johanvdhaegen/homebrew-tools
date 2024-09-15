class Pytype < Formula
  include Language::Python::Virtualenv

  desc "Static analyzer for Python code"
  homepage "https://github.com/google/pytype/"
  url "https://files.pythonhosted.org/packages/ca/a5/4a80981dd69095a48cee43f62696aa614641978ab3f16a475b188a54813a/pytype-2024.9.13.tar.gz"
  sha256 "941046ca0f1c43b79162bb51836fef0ba6608012d99f6833148c249f22216f26"
  license "Apache-2.0"
  revision 1

  head "https://github.com/google/pytype.git", branch: "main"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/pytype-2024.9.13"
    sha256 cellar: :any, arm64_sonoma: "f4edeee8fd0f158a634156c3b7a26125c8a0bf86b9811d1ddcf2067cce12e059"
    sha256 cellar: :any, ventura:      "9f3dfcc99efabdfc1bbbaa1fdf1d8938868cc09e76fbe4972391aaaa278c57c7"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pybind11" => :build
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
    url "https://files.pythonhosted.org/packages/e4/bd/ff41d7a8efc4f60a61d903c3f9823565006f44f2b8b11c99701f552b0851/libcst-1.4.0.tar.gz"
    sha256 "449e0b16604f054fa7f27c3ffe86ea7ef6c409836fe68fe4e752a1894175db00"
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

  resource "pycnite" do
    url "https://files.pythonhosted.org/packages/26/55/7f412c01675a8c77a9ace64a37d557faebe6740cf7fd619c9bda82b33341/pycnite-2024.7.31.tar.gz"
    sha256 "5125f1c95aef4a23b9bec3b32fae76873dcd46324fa68e39c10fa852ecdea340"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/2c/aa/4cf0b17a070fb57798e8e0f5b1665abf5b2f19ee8ea47957aec2c37b9ced/pydot-3.0.1.tar.gz"
    sha256 "e18cf7f287c497d77b536a3d20a46284568fea390776dface6eabbdf1b1b5efc"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/83/08/13f3bce01b2061f2bbd582c9df82723de943784cf719a35ac886c652043a/pyparsing-3.1.4.tar.gz"
    sha256 "f86ec8d1a83f11977c9a6ea7598e8c27fc5cddfa5b07ea2241edbbde1d7bc032"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
        ninja_target = (OS.mac? ? "macosx-#{MacOS.version}" : "linux") +
                       "-#{Hardware::CPU.arch}"
        dl = resource("ninja-src")
        dl.verify_download_integrity(dl.fetch)
        dl_dir = "_skbuild/#{ninja_target}-#{pyver}/cmake-build"
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
