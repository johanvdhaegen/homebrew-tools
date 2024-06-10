class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server/"
  url "https://files.pythonhosted.org/packages/5e/58/835ce6e458317324a6c8a1fdd273659bd508d4c7967adca520e3d0b587f6/python-lsp-server-1.11.0.tar.gz"
  sha256 "89edd6fb3f7852e4bf5a3d1d95ea41484d1a28fa94b6e3cbff12b9db123b8e86"
  license "MIT"
  revision 2

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/python-lsp-server-1.11.0_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "f681fa47277a13a6ee21d081baad620eaea2e8020d26819abf83408f9142c389"
    sha256 cellar: :any_skip_relocation, ventura:      "e42f3a5dc4e0eb1ba671a60b49fb2f446043a5eae8e4164823ac7b7b301e1eb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d04c9267fab1918b8c91f6d31cd9695b9e0bc379376dcbeffd6addc14fc2e70b"
  end

  depends_on "rust" => :build
  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/27/8f/79adb88627d194824decf7b9f4dde9e059b251a7b76809c99f4803be258e/astroid-3.2.2.tar.gz"
    sha256 "8ead48e31b92b2e217b6c9733a21afafe479d52d6e164dd25fb1a770c7c3cf94"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/8f/5f/bac24a952668c7482cfdb4ebf91ba57a796c9da8829363a772040c1a3312/black-24.3.0.tar.gz"
    sha256 "a0c9c4a0771afc6919578cec71ce82a3e31e054904e7197deacbc9382671c41f"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/1e/57/c6ccd22658c4bcb3beb3f1c262e1f170cf136e913b122763d0ddd328d284/cattrs-23.2.3.tar.gz"
    sha256 "a934090d95abaa9e911dac357e3a8699e0b4b14f8529bcc7d2b1ad9d51672b9f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/17/4d/ac7ffa80c69ea1df30a8aa11b3578692a5118e7cd1aa157e3ef73b092d15/dill-0.3.8.tar.gz"
    sha256 "3ebe3c479ad625c4553aca177444d89b486b1d84982eeacded644afc0cf797ca"
  end

  resource "docstring-to-markdown" do
    url "https://files.pythonhosted.org/packages/7a/ad/6a66abd14676619bd56f6b924c96321a2e2d7d86558841d94a30023eec53/docstring-to-markdown-0.15.tar.gz"
    sha256 "e146114d9c50c181b1d25505054a8d0f7a476837f0da2c19f07e06eaed52b73d"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a0/fc/c4e6078d21fc4fa56300a241b87eae76766aa380a23fc450fc85bb7bf547/importlib_metadata-7.1.0.tar.gz"
    sha256 "b78938b926ee8d5f020fc4772d487045805a55ddbad2ecf21c6d60938dc7fcd2"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/87/f9/c1eb8635a24e87ade2efce21e3ce8cd6b8630bb685ddc9cdaca1349b2eb5/isort-5.13.2.tar.gz"
    sha256 "48fdfcb9face5d58a4f6dde2e72a1fb8dcaf8ab26f95ab49fab84c2ddefb0109"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/d6/99/99b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0a/jedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/9d/f6/6e80484ec078d0b50699ceb1833597b792a6c695f90c645fbaf54b947e6f/lsprotocol-2023.0.1.tar.gz"
    sha256 "cc5c15130d2403c18b734304339e51242d3018a05c4f7d0f198ad6e0cd21861d"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "mypy" do
    url "https://files.pythonhosted.org/packages/c3/b6/297734bb9f20ddf5e831cf4a83f422ddef5a29a33463999f0959d9cdc2df/mypy-1.10.0.tar.gz"
    sha256 "3d087fcbec056c4ee34974da493a826ce316947485cef3901f511848e687c131"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/66/94/68e2e17afaa9169cf6412ab0f28623903be73d1b32e208d9e8e541bb086d/parso-0.8.4.tar.gz"
    sha256 "eb3a7b58240fb99099a345571deecc0f9540ea5f4dd2fe14c2a99d6b281ab92d"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/f5/52/0763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19/platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/96/2d/02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6/pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/34/8f/fa09ae2acc737b9507b5734a9aec9a2b35fa73409982f57db1b42f8c3c65/pycodestyle-2.11.1.tar.gz"
    sha256 "41ba0e7afc9752dfb53ced5489e89f8186be00e599e712660695b7a75ff2663f"
  end

  resource "pydocstyle" do
    url "https://files.pythonhosted.org/packages/e9/5c/d5385ca59fd065e3c6a5fe19f9bc9d5ea7f2509fa8c9c22fb6b2031dd953/pydocstyle-6.3.0.tar.gz"
    sha256 "7ce43f0c0ac87b07494eb9c0b462c0b73e6ff276807f204d6b53edc72b7e44e1"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/57/f9/669d8c9c86613c9d568757c7f5824bd3197d7b1c6c27553bc5618a27cce2/pyflakes-3.2.0.tar.gz"
    sha256 "1c61603ff154621fb2a9172037d84dca3500def8c8b630657d1701f026f8af3f"
  end

  resource "pylint" do
    url "https://files.pythonhosted.org/packages/9a/e9/60280b14cc1012794120345ce378504cf17409e38cd88f455dc24e0ad6b5/pylint-3.2.3.tar.gz"
    sha256 "02f6c562b215582386068d52a30f520d84fdbcf2a95fc7e855b816060d048b60"
  end

  resource "pylsp-mypy" do
    url "https://files.pythonhosted.org/packages/76/98/41e7fe44f2e9773bbf711ecc73c34a29b645ea6e454b36e723595d4ad4a4/pylsp-mypy-0.6.8.tar.gz"
    sha256 "3f8307ca07d7e253e50e38c5fe31c371ceace0bc33d31c3429fa035d6d41bd5f"
  end

  resource "pylsp-rope" do
    url "https://files.pythonhosted.org/packages/5e/4b/2bbf498ebc1fa764f15c9155c0ed28900268ac22ddcb1d8cf219937bf151/pylsp-rope-0.1.16.tar.gz"
    sha256 "d680b688c60a40257a8842ec808a6e0de1596a47a5300f22aecfdc69555020a7"
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
    url "https://files.pythonhosted.org/packages/6b/d4/6836871410a0155f5ba05ab03b60efe75c194406fb7fc62e45d37cd13e9c/python_lsp_ruff-2.2.1.tar.gz"
    sha256 "0bb3a227bc136e8ab8c66e91733f2673dc15df6f7fc9eb99d4267d0991b327a5"
  end

  resource "pytoolconfig" do
    url "https://files.pythonhosted.org/packages/18/dc/abf70d2c2bcac20e8c71a7cdf6d44e4ddba4edf65acb179248d554d743db/pytoolconfig-1.3.1.tar.gz"
    sha256 "51e6bd1a6f108238ae6aab6a65e5eed5e75d456be1c2bf29b04e5c1e7d7adbae"
  end

  resource "rope" do
    url "https://files.pythonhosted.org/packages/1c/c1/875e0270ac39b764fcb16c2dfece14a42747dbd0f181ac3864bff3126af1/rope-1.13.0.tar.gz"
    sha256 "51437d2decc8806cd5e9dd1fd9c1306a6d9075ecaf78d191af85fc1dfface880"
  end

  resource "ruff" do
    url "https://files.pythonhosted.org/packages/0f/6b/4545638200466af8b9407bd0d5bea1ce426328eaa9714f8d3ef1a43fc0e6/ruff-0.4.8.tar.gz"
    sha256 "16d717b1d57b2e2fd68bd0bf80fb43931b79d05a7131aa477d66fc40fbd86268"
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
    url "https://files.pythonhosted.org/packages/2b/ab/18f4c8f2bec75eb1a7aebcc52cdb02ab04fd39ff7025bb1b1c7846cc45b8/tomlkit-0.12.5.tar.gz"
    sha256 "eef34fba39834d4d6b73c9ba7f3e4d1c417a4e56f89a7e96e090dd0d24b8fb3c"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/f0/00/3110fd566786bfa542adb7932d62035e0c0ef662a8ff6544b6643b3d6fd7/ujson-5.10.0.tar.gz"
    sha256 "b3cd8f3c5d8c7738257f1018880444f7b7d9b66232c64649f562d7ba86ad4bc1"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/2e/62/7a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10/websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  resource "yapf" do
    url "https://files.pythonhosted.org/packages/b9/14/c1f0ebd083fddd38a7c832d5ffde343150bd465689d12c549c303fbcd0f5/yapf-0.40.2.tar.gz"
    sha256 "4dab8a5ed7134e26d57c1647c7483afb3f136878b579062b786c9ba16b94637b"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/d3/20/b48f58857d98dcb78f9e30ed2cfe533025e2e9827bbd36ea0a64cc00cbc1/zipp-3.19.2.tar.gz"
    sha256 "bf1dcf6450f873a13e952a29504887c89e6de7506209e5b1bcc3460135d4de19"
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
    output = pipe_output("#{bin}/pylsp -v 2>&1", input)
    assert_match(/^Content-Length: \d+/i, output)
    assert_match(
      /"serverInfo":{"name":"pylsp","version":"#{version}"}/i,
      output,
    )

    expected_plugins = %w[
      black
      pylsp_mypy
      pylsp_rope
      ruff
    ]
    expected_plugins.each do |plugin_name|
      assert_match("Loaded pylsp plugin #{plugin_name}", output)
    end
  end
end
