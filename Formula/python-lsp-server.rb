class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server/"
  url "https://files.pythonhosted.org/packages/13/c3/02952e2465da01d2b9f3df8972ddce72fe4ac471fa9af9fcc7a89dc8f863/python-lsp-server-1.6.0.tar.gz"
  sha256 "d75cdff9027c4212e5b9e861e9a0219219c8e2c69508d9f24949951dabd0dc1b"
  license "MIT"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/python-lsp-server-1.6.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "568cca6b7f85d8490b94693468e61fd1607303598c563caaf78a261456c62ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "23e91e311e3ab7b4898f7fe0d19a443f25d20ba355b993b82222c5558ae5dfe1"
  end

  depends_on "python@3.10"

  resource "docstring-to-markdown" do
    url "https://files.pythonhosted.org/packages/1e/c5/53e13bb0e3dd8b7fa3595c80deb40a3742dd191a9350141d4daa7ab09a9f/docstring-to-markdown-0.10.tar.gz"
    sha256 "12f75b0c7b7572defea2d9e24b57ef7ac38c3e26e91c0e5547cfc02b1c168bf6"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/c2/25/273288df952e07e3190446efbbb30b0e4871a0d63b4246475f3019d4f55e/jedi-0.18.1.tar.gz"
    sha256 "74137626a64a99c8eb6ae5832d99b3bdd7d29a3850fe2aa80a4126b2a7d949ab"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/6e/4a/03ddad85a10dd52e209993a14afa0cb0dc5c348e4647329f1c53856ad9e6/ujson-5.5.0.tar.gz"
    sha256 "b25077a971c7da47bd6846a912a747f6963776d90720c88603b1b55d81790780"
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
    url "https://files.pythonhosted.org/packages/b6/83/5bcaedba1f47200f0665ceb07bcb00e2be123192742ee0edfb66b600e5fd/pycodestyle-2.9.1.tar.gz"
    sha256 "2c9607871d58c76354b697b42f5d57e1ada7d261c261efac224b664affdc5785"
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
    url "https://files.pythonhosted.org/packages/07/92/f0cb5381f752e89a598dd2850941e7f570ac3cb8ea4a344854de486db152/pyflakes-2.5.0.tar.gz"
    sha256 "491feb020dca48ccc562a8c0cbe8df07ee13078df59813b83959cbdada312ea3"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
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
    url "https://files.pythonhosted.org/packages/74/37/591f89e8a09ae4574391bdf8a5eecd34a3dbe545917333e625c9de9a66b0/lazy-object-proxy-1.8.0.tar.gz"
    sha256 "c219a00245af0f6fa4e95901ed28044544f50152840c5b6a3e7b2568db34d156"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/e3/a7/8f4e456ef0adac43f452efc2d0e4b242ab831297f1bac60ac815d37eb9cf/typing_extensions-4.4.0.tar.gz"
    sha256 "1511434bb92bf8dd198c12b1cc812e800d4181cfcb867674e0f8279cc93087aa"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/be/61/5a97efa0622b3413e3d01d6bc6b019a87bcc23058c378dbd24b8c2474860/astroid-2.12.12.tar.gz"
    sha256 "1c00a14f5a3ed0339d38d2e2e5b74ea2591df5861c0936bb292b84ccf3a78d83"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/7c/e7/364a09134e1062d4d5ff69b853a56cf61c223e0afcc6906b6832bcd51ea8/dill-0.3.6.tar.gz"
    sha256 "e5db55f3687856d8fbdab002ed78544e1c4559a130302693d839dfe8f93f2373"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/ab/e9/964cb0b2eedd80c92f5172f1f8ae0443781a9d461c1372a3ce5762489593/isort-5.10.1.tar.gz"
    sha256 "e8443a5e7a020e9d7f97f1d7d9cd17c88bcb3bc7e218bf9cf5095fe550be2951"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/32/3d/711a708e9b69b263e5cf190a030a77fd79a05613820f6ce0c7ea6f92f99f/platformdirs-2.5.3.tar.gz"
    sha256 "6e52c21afff35cb659c6e52d8b4d61b9bd544557180440538f255d9382c8cbe0"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/ff/04/58b4c11430ed4b7b8f1723a5e4f20929d59361e9b17f0872d69681fd8ffd/tomlkit-0.11.6.tar.gz"
    sha256 "71b952e5721688937fb02cf9d354dbcf0785066149d2855e44531ebdd2b65d73"
  end

  resource "pylint" do
    url "https://files.pythonhosted.org/packages/4e/9d/fa68dd17140373786c5a379f6b313ceeb324dfe47ff13f717710c2e63c1d/pylint-2.15.5.tar.gz"
    sha256 "3b120505e5af1d06a5ad76b55d8660d44bf0f2fc3c59c2bdd94e39188ee3a4df"
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

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
        "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\n\n#{json}"
    output = pipe_output("#{bin}/pylsp", input)
    assert_match(/^Content-Length: \d+/i, output)
    assert_match(
      /"serverInfo":{"name":"pylsp","version":"#{version}"}/i,
      output,
    )
  end
end
