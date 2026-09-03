class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server/"
  url "https://files.pythonhosted.org/packages/e6/63/7d6af072a5b77a0d1f61306b7a72a7a2bc3f29ec0f8a8c85eb23f5ba7716/python_lsp_server-1.15.0.tar.gz"
  sha256 "85fa090262c3d1aef09b759d98811d6cb9ad5bbc58af15d588608ae8c1925801"
  license "MIT"
  head "https://github.com/python-lsp/python-lsp-server.git", branch: "develop"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/python-lsp-server-1.15.0"
    sha256 cellar: :any, arm64_tahoe:   "3ff2db93b90cfe3fab2d2c97cc348d76ce5b38fbd0623f89dc0d7f9f49dc37ca"
    sha256 cellar: :any, arm64_sequoia: "800490a1b1e9a96d554b431917b44497bff06ea42a8112d8bb315e5845c2183b"
    sha256 cellar: :any, arm64_linux:   "2bce26f083881570deb60648044d09476b2f7893788e334f6930cc3764431a30"
    sha256 cellar: :any, x86_64_linux:  "deb3c16f46a850db9289f8aa31a4cef348deb2ddaef7148ef61fa9b5d90686d7"
  end

  depends_on "rust" => :build
  depends_on "python@3.12"

  resource "ast-serialize" do
    url "https://files.pythonhosted.org/packages/e1/a9/11851c3e02a3fea2ddc9932d1fdc7d2edaeecc0d2e11bc5f2a7fde2b0934/ast_serialize-0.8.0.tar.gz"
    sha256 "6c37c43e4004dfb42d321ddedc569dc17ff4259296f3af577c9ea46a809bc010"
  end

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/07/63/0adf26577da5eff6eb7a177876c1cfa213856be9926a000f65c4add9692b/astroid-4.0.4.tar.gz"
    sha256 "986fed8bcf79fb82c78b18a53352a0b287a73817d6dbcfba3162da36667c49a0"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/c0/37/5628dd55bf2b34257fc7603f0fe97c40e3aaf24265f416a9c85c95ca1436/black-26.5.1.tar.gz"
    sha256 "dd321f668053961824bcc1be1cc1df748b2d7e4fa28086b08331e577b0100a73"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/a0/ec/ba18945e7d6e55a58364d9fb2e46049c1c2998b3d805f19b703f14e81057/cattrs-26.1.0.tar.gz"
    sha256 "fa239e0f0ec0715ba34852ce813986dfed1e12117e209b816ab87401271cdd40"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/81/e1/56027a71e31b02ddc53c7d65b01e68edf64dea2932122fe7746a516f75d5/dill-0.4.1.tar.gz"
    sha256 "423092df4182177d4d8ba8290c8a5b640c66ab35ec7da59ccfa00f6fa3eea5fa"
  end

  resource "docstring-to-markdown" do
    url "https://files.pythonhosted.org/packages/52/d8/8abe80d62c5dce1075578031bcfde07e735bcf0afe2886dd48b470162ab4/docstring_to_markdown-0.17.tar.gz"
    sha256 "df72a112294c7492487c9da2451cae0faeee06e86008245c188c5761c9590ca3"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/6f/7e/1e7e8dc30634b93ebb3d58a3dea569ad146e656218d3960ab04f62047b29/importlib_metadata-9.0.1.tar.gz"
    sha256 "ab830580bc0ef3db61ce8fae716389e5462b67e033018bab6d8f80ef17172f99"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/ef/7c/ec4ab396d31b3b395e2e999c8f46dec78c5e29209fac49d1f4dace04041d/isort-8.0.1.tar.gz"
    sha256 "171ac4ff559cdc060bcfff550bc8404a486fee0caab245679c2abe7cb253c78d"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/46/b7/a3635f6a2d7cf5b5dd98064fc1d5fbbafcb25477bcea204a3a92145d158b/jedi-0.20.0.tar.gz"
    sha256 "c3f4ccbd276696f4b19c54618d4fb18f9fc24b0aef02acf704b23f487daa1011"
  end

  resource "librt" do
    url "https://files.pythonhosted.org/packages/36/9b/356320fbae2ac8467e21c5e73e1389c80468e4998c62cc7d3536cc51b614/librt-0.15.0.tar.gz"
    sha256 "4e66cbe84437497d951b799d3e1551291b6fb3d643820a7014b3655d57a59162"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/e9/26/67b84e6ec1402f0e6764ef3d2a0aaf9a79522cc1d37738f4e5bb0b21521a/lsprotocol-2025.0.0.tar.gz"
    sha256 "e879da2b9301e82cfc3e60d805630487ac2f7ab17492f4f5ba5aaba94fe56c29"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "mypy" do
    url "https://files.pythonhosted.org/packages/82/6a/878cc1097d4035f82bd516658d0c528d2a9955bc7b363afcbd0b07fea11b/mypy-2.3.1.tar.gz"
    sha256 "47c1b1207258513a9d93495f69c8be9de73916186f0e52703e8c461b7a623419"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/30/4b/90c937815137d43ce71ba043cd3566221e9df6b9c805f24b5d138c9d40a7/parso-0.8.7.tar.gz"
    sha256 "eaaac4c9fdd5e9e8852dc778d2d7405897ec510f2a298071453e5e3a07914bb1"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ea/06/cf1564dcc2e2261c8c8c6c05628dc8b418943bdae2a4e58640ceb2f770fa/platformdirs-4.11.5.tar.gz"
    sha256 "e8b31f4f8bcbbedef91a6b57a706255e4f148d2a4e01648382a0a47342539173"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/11/e0/abfd2a0d2efe47670df87f3e3a0e2edda42f055053c85361f19c0e2c1ca8/pycodestyle-2.14.0.tar.gz"
    sha256 "c4b5b517d278089ff9d0abdec919cd97262a3367449ea1c8b49b91529167b783"
  end

  resource "pydocstyle" do
    url "https://files.pythonhosted.org/packages/e9/5c/d5385ca59fd065e3c6a5fe19f9bc9d5ea7f2509fa8c9c22fb6b2031dd953/pydocstyle-6.3.0.tar.gz"
    sha256 "7ce43f0c0ac87b07494eb9c0b462c0b73e6ff276807f204d6b53edc72b7e44e1"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/45/dc/fd034dc20b4b264b3d015808458391acbf9df40b1e54750ef175d39180b1/pyflakes-3.4.0.tar.gz"
    sha256 "b24f96fafb7d2ab0ec5075b7350b3d2d2218eab42003821c06344973d3ea2f58"
  end

  resource "pylint" do
    url "https://files.pythonhosted.org/packages/de/92/98dace02f2d11b88160354c53944f77ea7327aa78bce1c75971e7aaa4347/pylint-4.0.7.tar.gz"
    sha256 "9b2d1d15791c84b77a4fe2aafe8f0d9570717e2dea06d53b19c105cf60275a52"
  end

  resource "pylsp-mypy" do
    url "https://files.pythonhosted.org/packages/c2/d3/25f5fdecdeebee9f896b45011a03657bfd7b85503659ddee20e9a97bec7e/pylsp_mypy-0.8.0.tar.gz"
    sha256 "00d86eafa4e544ee81a73979eff1a998fbd40d4ae9c1821fe88023326a756dc2"
  end

  resource "pylsp-rope" do
    url "https://files.pythonhosted.org/packages/51/3d/cfcf7e093c98cccadbccdc8762194cd3afaa4d8aac6731ced5bea92489cb/pylsp_rope-0.1.17.tar.gz"
    sha256 "4cd6f2fb32c84302b94cb4ce002bc0700b1b656dd5147e7db3dd92303a9a8dc2"
  end

  resource "python-lsp-black" do
    url "https://files.pythonhosted.org/packages/c0/48/06edc947f711fb076b564ee97bbecb5ae877816ccc0edf4347f57cd9d6b9/python-lsp-black-2.0.0.tar.gz"
    sha256 "8286d2d310c566844b3c116b824ada6fccfa6ba228b1a09a0526b74c04e0805f"
  end

  resource "python-lsp-jsonrpc" do
    url "https://files.pythonhosted.org/packages/48/b6/fd92e2ea4635d88966bb42c20198df1a981340f07843b5e3c6694ba3557b/python-lsp-jsonrpc-1.1.2.tar.gz"
    sha256 "4688e453eef55cd952bff762c705cedefa12055c0aec17a06f595bcc002cc912"
  end

  resource "python-lsp-ruff" do
    url "https://files.pythonhosted.org/packages/6c/84/0cfc69ab2cc8f553530e1bc595c76e9a2b786ace6b8e070c3d5b813ce6e5/python_lsp_ruff-2.3.3.tar.gz"
    sha256 "156bfbbe2b6ef5d1a2d69500e0804677b64469fb59e41c4e77774fd3440a7f32"
  end

  resource "pytokens" do
    url "https://files.pythonhosted.org/packages/b6/34/b4e015b99031667a7b960f888889c5bd34ef585c85e1cb56a594b92836ac/pytokens-0.4.1.tar.gz"
    sha256 "292052fe80923aae2260c073f822ceba21f3872ced9a68bb7953b348e561179a"
  end

  resource "pytoolconfig" do
    url "https://files.pythonhosted.org/packages/18/dc/abf70d2c2bcac20e8c71a7cdf6d44e4ddba4edf65acb179248d554d743db/pytoolconfig-1.3.1.tar.gz"
    sha256 "51e6bd1a6f108238ae6aab6a65e5eed5e75d456be1c2bf29b04e5c1e7d7adbae"
  end

  resource "rope" do
    url "https://files.pythonhosted.org/packages/74/3a/85e60d154f26ecdc1d47a63ac58bd9f32a5a9f3f771f6672197f02a00ade/rope-1.14.0.tar.gz"
    sha256 "8803e3b667315044f6270b0c69a10c0679f9f322ed8efe6245a93ceb7658da69"
  end

  resource "ruff" do
    url "https://files.pythonhosted.org/packages/f3/85/c8e12473c93018f92d19dd988a294202e1c27426c47ec4de53ffb847b8d8/ruff-0.16.5.tar.gz"
    sha256 "1b88500f9ffbcab3dedb0082c9f9492e91ec3d618aac1236a3e0189938f7040b"
  end

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/43/f8/0a71edf031f03c40db17503cb8ca78a69a171254e568e7db241b0ab57ea1/snowballstemmer-3.1.1.tar.gz"
    sha256 "e07bbc54a0d798fe6010a12398422e62a8bfbba95c394fd0956ef58cb4d3e260"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/89/7a/c8bb37c8f6f3623d60c33d15d18cd6d6655d0f9c3eb31a9969f76361b199/ujson-5.13.0.tar.gz"
    sha256 "d62e3d7625384c08082abad81a077af587fdef2761bb14c3822f4234b8d07d75"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/18/72/fba934cb3dff7a85d811820efffcd141ddd52b5a2a01637f64551373ff4d/websockets-17.1.tar.gz"
    sha256 "acfea4c20bf54384883ea33b1240fc1db4f52e190823a4e2b334bc3e8bfca96a"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/b9/d8/eab98a517c14134c0b2eb4e2387bc5f457334293ec5d2dd3857ec2966802/zipp-4.1.0.tar.gz"
    sha256 "4cb57381f544315db7688e976e922a2b18cdb513d21cc194eb42232ba2a3e602"
  end

  def install
    ENV["PIP_USE_PEP517"] = "1"

    venv = virtualenv_create(libexec, "python3.12")

    # build the installed mypy with mypyc on macOS; Linux uses the pure-Python
    # build until https://github.com/python/mypy/issues/20567 is resolved
    ENV["MYPY_USE_MYPYC"] = OS.mac? ? "1" : "0"
    venv.pip_install resource("mypy")

    # pytokens installs mypy in an isolated build environment; keep that
    # temporary copy pure Python so the full mypyc compilation is not repeated
    ENV["MYPY_USE_MYPYC"] = "0"
    ENV["PYTOKENS_USE_MYPYC"] = OS.mac? ? "1" : "0"
    venv.pip_install resources.reject { |resource| resource.name == "mypy" }
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pylsp -V 2>&1")

    mypy_version = shell_output("#{libexec}/bin/mypy --version")
    assert_match "(compiled: #{OS.mac? ? "yes" : "no"})", mypy_version

    pytokens_file = shell_output(
      "#{libexec}/bin/python -c 'import pytokens; print(pytokens.__file__)'",
    ).strip
    if OS.mac?
      assert_match(/\.so$/, pytokens_file)
    else
      assert_match(/\.py$/, pytokens_file)
    end

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
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/pylsp -v 2>&1", input)
    assert_match(/^Content-Length: \d+/i, output)
    assert_match(
      /"serverInfo":{"name":"pylsp","version":"#{version}"}/i,
      output,
    )

    expected_plugins = %w[
      black
      pycodestyle
      pydocstyle
      pyflakes
      pylint
      pylsp_mypy
      pylsp_rope
      ruff
    ]
    expected_plugins.each do |plugin_name|
      assert_match("Loaded pylsp plugin #{plugin_name}", output)
    end
  end
end
