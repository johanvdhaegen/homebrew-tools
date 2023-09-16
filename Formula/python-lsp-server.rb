class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server/"
  url "https://files.pythonhosted.org/packages/7f/38/9c7196124b2b36088b8c0b83fe4c117f02dd0bfae64473b51cd09628af08/python-lsp-server-1.8.0.tar.gz"
  sha256 "807b0347cf83f02cbd9113a68624ac5dbf8b01854a3b11dd03c3bbbdff4e5d89"
  license "MIT"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/python-lsp-server-1.8.0"
    sha256 cellar: :any_skip_relocation, ventura:      "2995adea4214faea80bb7cfbbe6703834b2055bad74588cb0c62d3b8b4d1561e"
    sha256 cellar: :any_skip_relocation, monterey:     "33212146c6668b414187e431e1c9ed53162706746ce79ec61f6d0da9dd456b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5801c5ecd44594b94d854138cce4cfffca55d354d28a46011dcf837b648ed399"
  end

  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/d5/05/2c2ef3504e32a22b224614d45c590abb5be417cfed47ee63bf6089c3ae56/astroid-2.15.6.tar.gz"
    sha256 "903f024859b7c7687d7a7f3a3f73b17301f8e42dfd9cc9df9d4418172d3e2dbd"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/c4/31/54dd222e02311c2dbc9e680d37cbd50f4494ce1ee9b04c69980e4ec26f38/dill-0.3.7.tar.gz"
    sha256 "cc1c8b182eb3013e24bd475ff2e9295af86c1a38eb1aff128dac8962a9ce3c03"
  end

  resource "docstring-to-markdown" do
    url "https://files.pythonhosted.org/packages/52/c2/6f73c08b97bacd1242835bdca1cfc123b059eb15af9350eb1eb5d58868fc/docstring-to-markdown-0.12.tar.gz"
    sha256 "40004224b412bd6f64c0f3b85bb357a41341afd66c4b4896709efa56827fb2bb"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/44/ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36/importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/a9/c4/dc00e42c158fc4dda2afebe57d2e948805c06d5169007f1724f0683010a9/isort-5.12.0.tar.gz"
    sha256 "8bef7dde241278824a6d83f44a544709b065191b95b6e50894bdc722fcba0504"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/57/38/4ac6f712c308de92af967142bd67e9d27e784ea5a3524c9e84f33507d82f/jedi-0.19.0.tar.gz"
    sha256 "bcf9894f1753969cbac8022a8c2eaee06bfa3724e4192470aaffe7eb6272b0c4"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/20/c0/8bab72a73607d186edad50d0168ca85bd2743cfc55560c9d721a94654b20/lazy-object-proxy-1.9.0.tar.gz"
    sha256 "659fb5809fa4629b8a1ac5106f669cfc7bef26fbb389dda53b3e010d1ac4ebae"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/c1/2d/022c78a6b3f591205e52b4d25c93b7329280f752b36ba2fc1377cbf016cd/pycodestyle-2.11.0.tar.gz"
    sha256 "259bcc17857d8a8b3b4a2327324b79e5f020a13c16074670f9c8c8f872ea76d0"
  end

  resource "pydocstyle" do
    url "https://files.pythonhosted.org/packages/e9/5c/d5385ca59fd065e3c6a5fe19f9bc9d5ea7f2509fa8c9c22fb6b2031dd953/pydocstyle-6.3.0.tar.gz"
    sha256 "7ce43f0c0ac87b07494eb9c0b462c0b73e6ff276807f204d6b53edc72b7e44e1"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/8b/fb/7251eaec19a055ec6aafb3d1395db7622348130d1b9b763f78567b2aab32/pyflakes-3.1.0.tar.gz"
    sha256 "a0aae034c444db0071aa077972ba4768d40c830d9539fd45bf4cd3f8f6992efc"
  end

  resource "pylint" do
    url "https://files.pythonhosted.org/packages/19/07/24a57a4b12b8ea09f61436db7b312676aa2e526a34dbd0f2866e3e563e1a/pylint-2.17.5.tar.gz"
    sha256 "f7b601cbc06fef7e62a754e2b41294c2aa31f1cb659624b9a85bcba29eaf8252"
  end

  resource "python-lsp-jsonrpc" do
    url "https://files.pythonhosted.org/packages/ee/83/5a5ccfe879e7dfdc650168bb2fbe33d43afef735ea1ae62ee946ae1f86ee/python-lsp-jsonrpc-1.1.1.tar.gz"
    sha256 "05cc914aa5ee2e7f52eb762014ba4996a8cc52459bfddb81fb96c56ace927908"
  end

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/44/7b/af302bebf22c749c56c9c3e8ae13190b5b5db37a33d9068652e8f73b7089/snowballstemmer-2.2.0.tar.gz"
    sha256 "09b16deb8547d3412ad7b590689584cd0fe25ec8db3be37788be3810cbf19cb1"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/0d/07/d34a911a98e64b07f862da4b10028de0c1ac2222ab848eaf5dd1877c4b1b/tomlkit-0.12.1.tar.gz"
    sha256 "38e1ff8edb991273ec9f6181244a6a391ac30e9f5098e7535640ea6be97a7c86"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/15/16/ff0a051f9a6e122f07630ed1e9cbe0e0b769273e123673f0d2aa17fe3a36/ujson-5.8.0.tar.gz"
    sha256 "78e318def4ade898a461b3d92a79f9441e7e0e4d2ad5419abed4336d702c7425"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
  end

  resource "yapf" do
    url "https://files.pythonhosted.org/packages/e0/7a/9020bfa17d294b5d0d8bf26bb175ad4c90d1e3ad4039001f621ef046cb06/yapf-0.40.1.tar.gz"
    sha256 "958587eb5c8ec6c860119a9c25d02addf30a44f75aa152a4220d30e56a98037c"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e2/45/f3b987ad5bf9e08095c1ebe6352238be36f25dd106fde424a160061dce6d/zipp-3.16.2.tar.gz"
    sha256 "ebc15946aa78bd63458992fc81ec3b6f7b1e92d51c35e6de1c3804e73b799147"
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
