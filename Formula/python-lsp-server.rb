class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Implementation of Language Server Protocol for Python"
  homepage "https://github.com/python-lsp/python-lsp-server/"
  url "https://files.pythonhosted.org/packages/86/ea/d838df070b8d18664070a5ed78f750256645959664b5755e605a186f6625/python-lsp-server-1.5.0.tar.gz"
  sha256 "e5c094c19925022a27c4068f414b2bb653243f8fb0d768e39735289d7a89380d"
  license "MIT"
  revision 2

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/python-lsp-server-1.5.0_2"
    sha256 cellar: :any_skip_relocation, big_sur:      "c1a324488dca20af7bd877805636c2f00c0724783c8ba10fe27b647f71a3179c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5b6869928edaf417a9255d773b60e5892f52a82041cc1e336840b64d04c8b80b"
  end

  depends_on "python@3.9"

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/c2/25/273288df952e07e3190446efbbb30b0e4871a0d63b4246475f3019d4f55e/jedi-0.18.1.tar.gz"
    sha256 "74137626a64a99c8eb6ae5832d99b3bdd7d29a3850fe2aa80a4126b2a7d949ab"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/92/4a/2676677f59709517560b2b7eeb027453e86643d54d04687602e76cca4380/ujson-5.1.0.tar.gz"
    sha256 "a88944d2f99db71a3ca0c63d81f37e55b660edde0b07216fb65a3e46403ef004"
  end

  resource "python-lsp-jsonrpc" do
    url "https://files.pythonhosted.org/packages/99/45/1c2a272950679af529f7360af6ee567ef266f282e451be926329e8d50d84/python-lsp-jsonrpc-1.0.0.tar.gz"
    sha256 "7bec170733db628d3506ea3a5288ff76aa33c70215ed223abdb0d95e957660bd"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/08/dc/b29daf0a202b03f57c19e7295b60d1d5e1281c45a6f5f573e41830819918/pycodestyle-2.8.0.tar.gz"
    sha256 "eddd5847ef438ea1c7870ca7eb78a9d47ce0cdb4851a5523949f2601d0cbbe7f"
  end

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/44/7b/af302bebf22c749c56c9c3e8ae13190b5b5db37a33d9068652e8f73b7089/snowballstemmer-2.2.0.tar.gz"
    sha256 "09b16deb8547d3412ad7b590689584cd0fe25ec8db3be37788be3810cbf19cb1"
  end

  resource "pydocstyle" do
    url "https://files.pythonhosted.org/packages/4c/30/4cdea3c8342ad343d41603afc1372167c224a04dc5dc0bf4193ccb39b370/pydocstyle-6.1.1.tar.gz"
    sha256 "1d41b7c459ba0ee6c345f2eb9ae827cab14a7533a88c5c6f7e94923f72df92dc"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/15/60/c577e54518086e98470e9088278247f4af1d39cb43bcbd731e2c307acd6a/pyflakes-2.4.0.tar.gz"
    sha256 "05a85c2872edf37a4ed30b0cce2f6093e1d0581f8c19d7393122da7e25b2b24c"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pytoolconfig" do
    url "https://files.pythonhosted.org/packages/6e/c1/6156c684e2879c4873ef470048710ec00b08e639c9142c9263cf443f6f2b/pytoolconfig-1.2.1.tar.gz"
    sha256 "5ac82f78d731531f9f82e5cc7f5ebae9473b1404c0e75aa5ac0b8b41cd99b510"
  end

  resource "rope" do
    url "https://files.pythonhosted.org/packages/7a/46/412e491b73bb5e906178677917395b6437b7914576a85468fad22d575e32/rope-1.2.0.tar.gz"
    sha256 "f762542c9cfe52124aa55d33822a269fc4b0da70fe3170c6086de2733ed52f22"
  end

  resource "yapf" do
    url "https://files.pythonhosted.org/packages/c2/cd/d0d1e95b8d78b8097d90ca97af92f4af7fb2e867262a2b6e37d6f48e612a/yapf-0.32.0.tar.gz"
    sha256 "a3f5085d37ef7e3e004c4ba9f9b3e40c54ff1901cd111f05145ae313a7c67d1b"
  end

  resource "whatthepatch" do
    url "https://files.pythonhosted.org/packages/cf/88/2a5f8a0ec3ff8c76ed340b73558747736018ad9821e45439d63f989e1fbd/whatthepatch-1.0.2.tar.gz"
    sha256 "c540ea59173e0a291e19c742dd8b406c56e2be039a600edb7c6fc3ae4bbdfa9f"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/75/93/3fc1cc28f71dd10b87a53b9d809602d7730e84cc4705a062def286232a9c/lazy-object-proxy-1.7.1.tar.gz"
    sha256 "d609c75b986def706743cdebe5e47553f4a5a1da9c5ff66d76013ef396b5a8a4"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/9e/1d/d128169ff58c501059330f1ad96ed62b79114a2eb30b8238af63a2e27f70/typing_extensions-4.3.0.tar.gz"
    sha256 "e6d2677a32f47fc7eb2795db1dd15c1f34eff616bcaf2cfb5e997f854fa1c4a6"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/47/fa/cedd4cf37634b2fcc3773cedd0a9ca05fed2fa014d3d03815b04b7738ade/astroid-2.11.7.tar.gz"
    sha256 "bb24615c77f4837c707669d16907331374ae8a964650a66999da3f5ca68dc946"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/59/46/634d5316ee8984e7dac658fb2e297a19f50a1f4007b09acb9c7c4e15bd67/dill-0.3.5.1.tar.gz"
    sha256 "d75e41f3eff1eee599d738e76ba8f4ad98ea229db8b085318aa2b3333a208c86"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/ab/e9/964cb0b2eedd80c92f5172f1f8ae0443781a9d461c1372a3ce5762489593/isort-5.10.1.tar.gz"
    sha256 "e8443a5e7a020e9d7f97f1d7d9cd17c88bcb3bc7e218bf9cf5095fe550be2951"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/1e/81/93889ea6641154b22f26036bc4ef800b06df84fc647a6ded5abdc2f06dcf/tomlkit-0.11.1.tar.gz"
    sha256 "61901f81ff4017951119cd0d1ed9b7af31c821d6845c8c477587bbdcd5e5854e"
  end

  resource "pylint" do
    url "https://files.pythonhosted.org/packages/82/e5/ae649803c4f3a4e47720337352af046089f8e9ff8a25958199df74268984/pylint-2.14.5.tar.gz"
    sha256 "487ce2192eee48211269a0e976421f334cf94de1806ca9d0a99449adcdf0285e"
  end

  def install
    pyver = Language::Python.major_minor_version("python3")
    virtualenv_install_with_resources

    Pathname.glob(libexec/"lib/python#{pyver}/site-packages/yapf*.egg-info").each do |p|
      chmod_R("ugo+r", p)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pylsp -V 2>&1")
  end
end
