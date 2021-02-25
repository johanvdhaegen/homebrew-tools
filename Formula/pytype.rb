class Pytype < Formula
  include Language::Python::Virtualenv

  desc "Static analyzer for Python code"
  homepage "https://github.com/google/pytype/"
  url "https://files.pythonhosted.org/packages/51/ea/104beb90a906b5aa4f253ea7f786dc94f4bc9c978629b7ba54fddab10f66/pytype-2021.2.23.tar.gz"
  sha256 "ce6c652bacd2926b56b7dbb347096863c276d407377784bc2d2674e80fd1d3e7"
  license "Apache-2.0"

  head "https://github.com/google/pytype.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "libyaml"
  depends_on "python@3.8"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/f0/cb/80a4a274df7da7b8baf083249b0890a0579374c3d74b5ac0ee9291f912dc/attrs-20.3.0.tar.gz"
    sha256 "832aa3cde19744e49938b91fea06d69ecb9e649c93ba974535d08ad92164f700"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/da/93/84fa12f2dc341f8cf5f022ee09e109961055749df2d0c75c5f98746cfe6c/decorator-4.4.2.tar.gz"
    sha256 "e3a62f0520172440ca0dcc823749319382e377f37f140a0b99ef45fecb84bfe7"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/ef/d0/f706a9e5814a42c544fa1b2876fc33e5d17e1f2c92a5361776632c4f41ab/networkx-2.5.tar.gz"
    sha256 "7978955423fbc9639c10498878be59caf99b44dc304c2286162fd24b458c1602"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/ed/46/e298a50dde405e1c202e316fa6a3015ff9288423661d7ea5e8f22f589071/wheel-0.36.2.tar.gz"
    sha256 "e11eefd162658ea59a60a0f6c7d493a7190ea4b9a85e335b33489d9f17e0245e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "scikit-build" do
    url "https://files.pythonhosted.org/packages/71/02/1e94506b7bee5739317f2d141cebab7dab5bb5731b377e718fddd3b3e7e7/scikit-build-0.11.1.tar.gz"
    sha256 "da40dfd69b2456fad1349a894b90180b43712152b8a85d2a00f4ae2ce8ac9a5c"
  end

  resource "ninja-src" do
    # unix_source_url from NinjaUrls.cmake in ninja python archive
    # https://github.com/scikit-build/ninja-python-distributions/blob/master/NinjaUrls.cmake
    url "https://github.com/kitware/ninja/archive/v1.10.0.gfb670.kitware.jobserver-1.tar.gz"
    sha256 "d00033813993116a4e14f835df813daee9916b107333d88dbb798a22f8671b1f"
  end

  resource "ninja" do
    url "https://files.pythonhosted.org/packages/55/a3/56376f09d6be4be5b7ebfc492d3e89cb05206a61f8c5f695a5d1e8cc49b7/ninja-1.10.0.post2.tar.gz"
    sha256 "621fd73513a9bef0cb82e8c531a29ef96580b4d6e797f833cce167054ad812f8"
  end

  resource "importlab" do
    url "https://files.pythonhosted.org/packages/3a/68/97775a75cb03949ecfda7ac61182e11ad22d4e9ae9d2f61c3417de9b2aac/importlab-0.6.1.tar.gz"
    sha256 "056503329df1ba8f6291a4b548042aa18620ad91d39388ba58044f0fd44ff83e"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "typed_ast" do
    url "https://files.pythonhosted.org/packages/36/8c/efd8ffe7d242cd389632a11cbc6ce596de49b46ece22760a67b742534368/typed_ast-1.4.2.tar.gz"
    sha256 "9fc0b3cb5d1720e7141d103cf4819aea239f7d136acf9ee4a69b047b7986175a"
  end

  resource "pybind11" do
    url "https://files.pythonhosted.org/packages/46/0e/3131a9ae6e6cd1d718cfdd3e2c25f681f2db29be30763aa54b9310de5fea/pybind11-2.6.2.tar.gz"
    sha256 "d0e0aed9279656f21501243b707eb6e3b951e89e10c3271dedf3ae41c365e5ed"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    pyver = Language::Python.major_minor_version("python3")
    venv = virtualenv_create(libexec, "python3")
    ENV.prepend_create_path "PYTHONPATH",
                            libexec/"lib/python#{pyver}/site-packages"

    # install all python resources, except ninja python bindings
    resources.each do |r|
      if r.name == "ninja" || r.name =="ninja-src"
        # do nothing: handle separately to ensure other resources are installed
      else
        venv.pip_install r
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
        system libexec/"bin/python3",
               *Language::Python.setup_install_args(libexec),
               "--", "-DBUILD_FROM_SOURCE=ON"
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
      PATH: "#{Formula["python@#{pyver}"].opt_bin}:$PATH}",
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
