class Pytype < Formula
  include Language::Python::Virtualenv

  desc "Static analyzer for Python code"
  homepage "https://github.com/google/pytype/"
  url "https://files.pythonhosted.org/packages/c0/ee/6a849ca837805044eed84b4cac7951b6562fdcb5ac39e7f4fb144b47b98c/pytype-2022.8.3.tar.gz"
  sha256 "4746f39aa25063990d207a159e5143adffd3be112ee057116180b9dc4ad7f4fc"
  license "Apache-2.0"
  revision 1

  head "https://github.com/google/pytype.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.10"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "importlab" do
    url "https://files.pythonhosted.org/packages/4b/d1/06a615a1363f80301ac23091f321b7420acd870a10d5a8b2ff833a101f1c/importlab-0.7.tar.gz"
    sha256 "744bd75d4410744962d203bd1eb71a950b19e8fb8eb5f0b805461dc0a2da329b"
  end

  resource "libcst" do
    url "https://files.pythonhosted.org/packages/90/6b/ef2d7c86a61c6b6ae4eb48b832ba96897d4ba9743e9ece40f66625b11d60/libcst-0.4.7.tar.gz"
    sha256 "95c52c2130531f6e726a3b077442cfd486975435fecf3db8224d43fba7b85099"
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
    url "https://files.pythonhosted.org/packages/00/99/5beedbf09e3ec6b617606df42d04c4251959caddbd98397cce21da4c52d1/ninja-1.10.2.3.tar.gz"
    sha256 "e1b86ad50d4e681a7dbdff05fc23bb52cb773edb90bc428efba33fa027738408"
  end

  resource "ninja-src" do
    # unix_source_url from NinjaUrls.cmake in ninja python archive
    # https://github.com/scikit-build/ninja-python-distributions/blob/master/NinjaUrls.cmake
    url "https://github.com/Kitware/ninja/archive/v1.10.2.g51db2.kitware.jobserver-1.tar.gz"
    sha256 "549c31ee596566b952c600e23eb9b8d39a4112cd5fdeb2e5a83370669176da40"
  end

  resource "pybind11" do
    url "https://files.pythonhosted.org/packages/59/f6/aafe0b7e798f25632b199523cce98552fde53e8c552b9d96765426532d5f/pybind11-2.10.0.tar.gz"
    sha256 "18977589c10f595f65ec1be90b0a0763b43e458d25d97be9db75b958eb1f43fe"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/7a/53/afac341569b3fd558bf2b5428e925e2eb8753ad9627c1f9188104c6e0c4a/tabulate-0.8.10.tar.gz"
    sha256 "6c57f3f3dd7ac2782770155f3adb2db0b1a269637e42f27599925e64b114f519"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/9e/1d/d128169ff58c501059330f1ad96ed62b79114a2eb30b8238af63a2e27f70/typing_extensions-4.3.0.tar.gz"
    sha256 "e6d2677a32f47fc7eb2795db1dd15c1f34eff616bcaf2cfb5e997f854fa1c4a6"
  end

  resource "typing-inspect" do
    url "https://files.pythonhosted.org/packages/c3/da/864ce66818e308b38209d4b1ef0585921d28eb07621ba7d905a0e96bcc80/typing_inspect-0.7.1.tar.gz"
    sha256 "047d4097d9b17f46531bf6f014356111a1b6fb821a24fe7ac909853ca2a782aa"
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
