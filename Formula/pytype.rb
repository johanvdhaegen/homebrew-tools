class Pytype < Formula
  include Language::Python::Virtualenv

  desc "Static analyzer for Python code"
  homepage "https://github.com/google/pytype/"
  url "https://files.pythonhosted.org/packages/39/ba/c86ec7209efb89ac0a0e1cd82773ea42c5e9be3eb7f839a86efdc9e3d658/pytype-2019.1.30.tar.gz"
  version "2019-01-30"
  sha256 "a19c2f145420fab82f8af9027201d583004e9fc9cb1adce0913d22b189e9810e"
  head "https://github.com/google/pytype.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "libyaml"
  depends_on "python"

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/c4/26/b48aaa231644bc875bb348e162d156edb18b994da900a10f4493ea995a2f/decorator-4.3.2.tar.gz"
    sha256 "33cd704aea07b4c28b3eb2c97d288a06918275dac0ecebdaf1bc8a48d98adb9e"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/f3/f4/7e20ef40b118478191cec0b58c3192f822cace858c19505c7670961b76b2/networkx-2.2.zip"
    sha256 "45e56f7ab6fe81652fb4bc9f44faddb0e9025f469f602df14e3b2551c2ea5c8b"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d8/55/221a530d66bf78e72996453d1e2dedef526063546e131d70bed548d80588/wheel-0.32.3.tar.gz"
    sha256 "029703bf514e16c8271c3821806a1c171220cc5bdd325cbf4e7da1e056a01db6"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/b9/b8/6b32b3e84014148dcd60dd05795e35c2e7f4b72f918616c61fdce83d27fc/pyparsing-2.3.1.tar.gz"
    sha256 "66c9268862641abcac4a96ba74506e594c884e3f57690a696d21ad8210ed667a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/16/51/d72654dbbaa4a4ffbf7cb0ecd7d12222979e0a660bf3f42acc47550bf098/packaging-19.0.tar.gz"
    sha256 "0c98a5d0be38ed775798ece1b9727178c4469d9c3b4ada66e8e6b7849f8732af"
  end

  resource "scikit-build" do
    url "https://files.pythonhosted.org/packages/30/ee/1d6bc8c865b77d7c74487c63770582b72675c5f3260d687f1504996a5379/scikit-build-0.8.1.tar.gz"
    sha256 "2aa4411a7de928d395eca240a6a794aa05c8d1c42ee53a4ae48fa324693902c2"
  end

  resource "ninja-src" do
    url "https://github.com/kitware/ninja/archive/v1.8.2.g3bbbe.kitware.dyndep-1.jobserver-1.tar.gz"
    sha256 "121c432cec32c8aea730a71a256a81442ac8446c6f0e7652ea3121da9e0d482d"
  end

  resource "ninja" do
    url "https://files.pythonhosted.org/packages/66/09/2a859888a29ca698c45c2e5a12b7f3dfdc58bd2896b33366dfffcba1a385/ninja-1.8.2.post2.tar.gz"
    sha256 "17964e0260a9f1955d6da6d28d61b0ab2b77bec57aed285850bbd149219c70e2"
  end

  resource "importlab" do
    url "https://files.pythonhosted.org/packages/6c/14/9081386bafaa5673b7d75063afe084d2c15ce837921e3bfb32281569081f/importlab-0.5.tar.gz"
    sha256 "ab3a0bf77a326de577e3c7f643ec304f83fed93cb1056638560d832413d6e736"
  end

  resource "pyyaml" do
    url "https://pyyaml.org/download/pyyaml/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
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
        dl = resource("ninja-src")
        dl.verify_download_integrity(dl.fetch)
        dl_dir = "_skbuild/macosx-#{MacOS.version}-x86_64-#{pyver}/cmake-build"
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
    chmod_R "ugo+r",
            libexec/"lib/python#{pyver}/site-packages/pytype-2019.1.30-py#{pyver}.egg-info",
            :verbose => true
    chmod_R "ugo+r",
            libexec/"lib/python#{pyver}/site-packages/importlab-0.5-py#{pyver}.egg-info",
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
