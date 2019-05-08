class Pytype < Formula
  include Language::Python::Virtualenv

  desc "Static analyzer for Python code"
  homepage "https://github.com/google/pytype/"
  url "https://files.pythonhosted.org/packages/51/f9/0b9be14e4d88d34d46df68cc4541fb6520d85aaa59e7ca401f7a4ac1fb6e/pytype-2019.4.26.tar.gz"
  version "2019-04-26"
  sha256 "666d401facc4d771bd2ac894c0c69749f490991773e7de157b24013aea5c0e72"
  head "https://github.com/google/pytype.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "libyaml"
  depends_on "python"

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/ba/19/1119fe7b1e49b9c8a9f154c930060f37074ea2e8f9f6558efc2eeaa417a2/decorator-4.4.0.tar.gz"
    sha256 "86156361c50488b84a3f148056ea716ca587df2f0de1d34750d35c21312725de"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/85/08/f20aef11d4c343b557e5de6b9548761811eb16e438cee3d32b1c66c8566b/networkx-2.3.zip"
    sha256 "8311ddef63cf5c5c5e7c1d0212dd141d9a1fe3f474915281b73597ed5f1d4e3d"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b7/cf/1ea0f5b3ce55cacde1e84cdde6cee1ebaff51bd9a3e6c7ba4082199af6f6/wheel-0.33.1.tar.gz"
    sha256 "66a8fd76f28977bb664b098372daef2b27f60dc4d1688cfab7b37a09448f0e9d"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/5d/3a/24d275393f493004aeb15a1beae2b4a3043526e8b692b65b4a9341450ebe/pyparsing-2.4.0.tar.gz"
    sha256 "1873c03321fc118f4e9746baf201ff990ceb915f433f23b395f5580d1840cb2a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/16/51/d72654dbbaa4a4ffbf7cb0ecd7d12222979e0a660bf3f42acc47550bf098/packaging-19.0.tar.gz"
    sha256 "0c98a5d0be38ed775798ece1b9727178c4469d9c3b4ada66e8e6b7849f8732af"
  end

  resource "scikit-build" do
    url "https://files.pythonhosted.org/packages/bb/48/412c5f3fb48364caa8e339d8e84dd2706c75b82d80df377353deecb5b2dc/scikit-build-0.9.0.tar.gz"
    sha256 "81119231cd9c4eba7acc1aaf7351a33b69494c2ccf94a31c2902a80622f089a9"
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
    url "https://files.pythonhosted.org/packages/6c/14/9081386bafaa5673b7d75063afe084d2c15ce837921e3bfb32281569081f/importlab-0.5.tar.gz"
    sha256 "ab3a0bf77a326de577e3c7f643ec304f83fed93cb1056638560d832413d6e736"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/9f/2c/9417b5c774792634834e730932745bc09a7d36754ca00acf1ccd1ac2594d/PyYAML-5.1.tar.gz"
    sha256 "436bc774ecf7c103814098159fbb84c2715d25980175292c648f2da143909f95"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "typed_ast" do
    url "https://files.pythonhosted.org/packages/d3/b1/959c3ed4a9cc100feba7ad1a7d6336d8888937ee89f4a577f7698e09decd/typed-ast-1.3.5.tar.gz"
    sha256 "5315f4509c1476718a4825f45a203b82d7fdf2a6f5f0c8f166435975b1c9f7d4"
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
