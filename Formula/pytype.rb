class Pytype < Formula
  include Language::Python::Virtualenv

  desc "Static analyzer for Python code"
  homepage "https://github.com/google/pytype/"
  url "https://files.pythonhosted.org/packages/c5/0d/1ad58ab73a190f4d7db16a1af1e19363afec81cf14fa76a22972e94fc7e6/pytype-2019.10.17.tar.gz"
  version "2019-10-17"
  sha256 "ff43dd0abc144ddf4d895ea52918b5d4bbd0f96b690af205e477cb1074b6ef4e"
  head "https://github.com/google/pytype.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "libyaml"
  depends_on "python"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/98/c3/2c227e66b5e896e15ccdae2e00bbc69aa46e9a8ce8869cc5fa96310bf612/attrs-19.3.0.tar.gz"
    sha256 "f7b7ce16570fe9965acd6d30101a28f62fb4a7f9e926b3bbc9b61f8b04247e72"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/ba/19/1119fe7b1e49b9c8a9f154c930060f37074ea2e8f9f6558efc2eeaa417a2/decorator-4.4.0.tar.gz"
    sha256 "86156361c50488b84a3f148056ea716ca587df2f0de1d34750d35c21312725de"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/bf/63/7b579dd3b1c49ce6b7fd8f6f864038f255201410905dd183cf7f4a3845cf/networkx-2.4.tar.gz"
    sha256 "f8f4ff0b6f96e4f9b16af6b84622597b5334bf9cae8cf9b2e42e7985d5c95c64"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/59/b0/11710a598e1e148fb7cbf9220fd2a0b82c98e94efbdecb299cb25e7f0b39/wheel-0.33.6.tar.gz"
    sha256 "10c9da68765315ed98850f8e048347c3eb06dd81822dc2ab1d4fde9dc9702646"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/7e/24/eaa8d7003aee23eda270099eeec754d7bf4399f75c6a011ef948304f66a2/pyparsing-2.4.2.tar.gz"
    sha256 "6f98a7b9397e206d78cc01df10131398f1c8b8510a2f4d97d9abd82e1aacdd80"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/5a/2f/449ded84226d0e2fda8da9252e5ee7731bdf14cd338f622dfcd9934e0377/packaging-19.2.tar.gz"
    sha256 "28b924174df7a2fa32c1953825ff29c61e2f5e082343165438812f00d3a7fc47"
  end

  resource "scikit-build" do
    url "https://files.pythonhosted.org/packages/9f/6b/9c193b2402969b2f3ef5e8105a434a9d4274df9b8315699225072217322a/scikit-build-0.10.0.tar.gz"
    sha256 "7342017cc82dd6178e3b19377389b8a8d1f8b429d9cdb315cfb1094e34a0f526"
  end

  resource "ninja-src" do
    # unix_source_url from NinjaUrls.cmake in ninja python archive
    # https://github.com/scikit-build/ninja-python-distributions/blob/master/NinjaUrls.cmake
    url "https://github.com/kitware/ninja/archive/v1.9.0.g5b44b.kitware.dyndep-1.jobserver-1.tar.gz"
    sha256 "449359a402c3adccd37f6fece19ce7d7cda586e837fdf50eb7d53597b7f1ce90"
  end

  resource "ninja" do
    url "https://files.pythonhosted.org/packages/47/ff/e2ddb9b663fd387437f3aee7befc2376b98410c7375d1e3105c268274cd4/ninja-1.9.0.tar.gz"
    sha256 "78c840ef1c94507956dac8810282cade2b139f0fda44c2f4706522415b990816"
  end

  resource "importlab" do
    url "https://files.pythonhosted.org/packages/16/86/6b3e80e074272aa2968452c82390d8f6cb1bb7645e852437a1e696389c04/importlab-0.5.1.tar.gz"
    sha256 "d855350d19dc10a17aabd2fe6f4b428ff1a936071f692fbf686a73694d26a51c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/e3/e8/b3212641ee2718d556df0f23f78de8303f068fe29cdaa7a91018849582fe/PyYAML-5.1.2.tar.gz"
    sha256 "01adf0b6c6f61bd11af6e10ca52b7d4057dd0be0343eb9283c878cf3af56aee4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "typed_ast" do
    url "https://files.pythonhosted.org/packages/34/de/d0cfe2ea7ddfd8b2b8374ed2e04eeb08b6ee6e1e84081d151341bba596e5/typed_ast-1.4.0.tar.gz"
    sha256 "66480f95b8167c9c5c5c87f32cf437d585937970f3fc24386f313a4c97b44e34"
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
        ninja_deployment_target = "10.6" # scikit-build default
        dl = resource("ninja-src")
        dl.verify_download_integrity(dl.fetch)
        dl_dir = "_skbuild/macosx-#{ninja_deployment_target}-x86_64-#{pyver}/cmake-build"
        mkdir_p dl_dir
        cp dl.cached_download,
           File.join(dl_dir, File.basename(URI.parse(dl.url).path)),
           :verbose => true
        system libexec/"bin/python3",
               *Language::Python.setup_install_args(libexec),
               "--", "-DBUILD_FROM_SOURCE=ON"
      end
    end

    # install pytype
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
    chmod_R "ugo+r",
            libexec/"lib/python#{pyver}/site-packages/importlab-#{resource("importlab").version}-py#{pyver}.egg-info",
            :verbose => true
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
