class Pytype < Formula
  include Language::Python::Virtualenv

  desc "Static analyzer for Python code"
  homepage "https://github.com/google/pytype/"
  url "https://files.pythonhosted.org/packages/01/2f/b13afba5fdaea9402fbe78a82c373070fa5728a51da6bd3af01c32cff38f/pytype-2020.9.29.tar.gz"
  version "2020-09-29"
  sha256 "b44c0904160c6b55ee3f9e00227719a62bb4e3388ae54220da2e0609388325fe"
  license "Apache-2.0"

  head "https://github.com/google/pytype.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "libyaml"
  depends_on "python@3.7"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/81/d0/641b698d05f0eaea4df4f9cebaff573d7a5276228ef6b7541240fe02f3ad/attrs-20.2.0.tar.gz"
    sha256 "26b54ddbbb9ee1d34d5d3668dd37d6cf74990ab23c828c2888dccdceee395594"
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
    url "https://files.pythonhosted.org/packages/83/72/611c121b6bd15479cb62f1a425b2e3372e121b324228df28e64cc28b01c2/wheel-0.35.1.tar.gz"
    sha256 "99a22d87add3f634ff917310a3d87e499f19e663413a52eb9232c447aa646c9f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/55/fd/fc1aca9cf51ed2f2c11748fa797370027babd82f87829c7a8e6dbe720145/packaging-20.4.tar.gz"
    sha256 "4357f74f47b9c12db93624a82154e9b120fa8293699949152b22065d556079f8"
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
    url "https://files.pythonhosted.org/packages/16/86/6b3e80e074272aa2968452c82390d8f6cb1bb7645e852437a1e696389c04/importlab-0.5.1.tar.gz"
    sha256 "d855350d19dc10a17aabd2fe6f4b428ff1a936071f692fbf686a73694d26a51c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "typed_ast" do
    url "https://files.pythonhosted.org/packages/18/09/b6a6b14bb8c5ec4a24fe0cf0160aa0b784fd55a6fd7f8da602197c5c461e/typed_ast-1.4.1.tar.gz"
    sha256 "8c8aaad94455178e3187ab22c8b01a3837f8ee50e09cf31f1ba129eb293ec30b"
  end

  def install
    pyver = Language::Python.major_minor_version("python3")
    venv = virtualenv_create(libexec, "python3")

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

    # fix typeshed permissions: not all typeshed files are world readable
    chmod_R "ugo+r", libexec/"lib/python#{pyver}/site-packages/pytype/typeshed",
            :verbose => true
    chmod_R "ugo+r", libexec/"lib/python#{pyver}/site-packages/pytype/pytd",
            :verbose => true
    # fix other permission problems
    pytype_version = stable.url.slice(/\d+\.\d+\.\d+/)
    chmod_R "ugo+r",
            libexec/"lib/python#{pyver}/site-packages/pytype-#{pytype_version}-py#{pyver}.egg-info",
            :verbose => true

    bin.each_child do |f|
      next unless f.symlink?

      # replace symlinks from bin to libexec/bin by copies
      # (otherwise env_script_all_files does not produce the correct result)
      symlink = f.realpath
      rm f, verbose: true
      cp symlink, f, verbose: true
    end

    # pytype needs to find the python interpreter used to run pytype on PATH
    bin.env_script_all_files(libexec/"bin",
                             PATH: "#{Formula["python@3.7"].opt_bin}:$PATH}")
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
