class Pytype < Formula
  include Language::Python::Virtualenv

  desc "Static analyzer for Python code"
  homepage "https://github.com/google/pytype/"
  url "https://files.pythonhosted.org/packages/5b/27/c4db021bc59bf099435341df82453b949885b102833d860c2d938f7519b5/pytype-2023.1.10.tar.gz"
  sha256 "8a6165327491582293c5d43faf7bafe453fd298e788043a905a1c42cd52607ac"
  license "Apache-2.0"

  head "https://github.com/google/pytype.git", branch: "main"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/pytype-2023.1.10"
    sha256 cellar: :any,                 monterey:     "741a549a2086209f084f48d50e38150a1deceaa9f82ed3c15727af4f8e6fa3bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8ccc48ff6e9f557c6c3efc23b9b667b9b49796f6b2748ca6de8ce87dee29ba49"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.10"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "importlab" do
    url "https://files.pythonhosted.org/packages/74/2e/2b779bb26addcecbecf0e632324f79ec9b682b3338e9ee6951482fc6eae0/importlab-0.8.tar.gz"
    sha256 "b24b3aac3b073966ae42fb2d3a7764f3377b30bb72c0d411fe29134cc9276e86"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "libcst" do
    url "https://files.pythonhosted.org/packages/fa/4d/366f6fede5c5121fdda08db85a79f8b602a24378394cd9f87c917232d578/libcst-0.4.9.tar.gz"
    sha256 "01786c403348f76f274dbaf3888ae237ffb73e6ed6973e65eba5c1fc389861dd"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/9e/9e/3d67df5d543ffd743f4ccb12c9c90929e4f48136e3062e15a6d971d91202/networkx-2.7.1.tar.gz"
    sha256 "d1194ba753e5eed07cdecd1d23c5cd7a3c772099bd8dbd2fea366788cf4de7ba"
  end

  resource "ninja" do
    url "https://files.pythonhosted.org/packages/f7/69/938374c8ebfeda683863b22e936f5d465ac9f5bf42be238504c018123190/ninja-1.11.1.tar.gz"
    sha256 "c833a47d39b2d1eee3f9ca886fa1581efd5be6068b82734ac229961ee8748f90"
  end

  resource "ninja-src" do
    # unix_source_url from NinjaUrls.cmake in ninja python archive
    # https://github.com/scikit-build/ninja-python-distributions/blob/master/NinjaUrls.cmake
    url "https://github.com/Kitware/ninja/archive/v1.11.1.g95dee.kitware.jobserver-1.tar.gz"
    sha256 "7ba84551f5b315b4270dc7c51adef5dff83a2154a3665a6c9744245c122dd0db"
  end

  resource "pybind11" do
    url "https://files.pythonhosted.org/packages/56/d3/ebc2ad811d192b91d97a45d30b4d5bcb148275db668eada4b6f55781fdc7/pybind11-2.10.3.tar.gz"
    sha256 "08cfe6d4f73746447cc85a400c8169a91608b8a00c5feecd8ff251a70565d12f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
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
    url "https://files.pythonhosted.org/packages/e3/a7/8f4e456ef0adac43f452efc2d0e4b242ab831297f1bac60ac815d37eb9cf/typing_extensions-4.4.0.tar.gz"
    sha256 "1511434bb92bf8dd198c12b1cc812e800d4181cfcb867674e0f8279cc93087aa"
  end

  resource "typing-inspect" do
    url "https://files.pythonhosted.org/packages/72/23/bed3ea644bcd77ffe9a7f591eb058c00739747e33ab94d80cc4319ddee8e/typing_inspect-0.8.0.tar.gz"
    sha256 "8b1ff0c400943b6145df8119c41c244ca8207f1f10c9c057aeed1560e4806e3d"
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

    # fix pytype permissions: not all pytype files are world readable
    chmod_R "ugo+r", libexec/"lib/python#{pyver}/site-packages/pytype",
            verbose: true
    pytype_version = stable.url.slice(/\d+\.\d+\.\d+/)
    chmod_R "ugo+r",
            libexec/"lib/python#{pyver}/site-packages/pytype-#{pytype_version}-py#{pyver}.egg-info",
            verbose: true

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
