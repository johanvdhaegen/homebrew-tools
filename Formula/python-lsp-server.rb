class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Implementation of Language Server Protocol for Python"
  homepage "https://github.com/python-lsp/python-lsp-server/"
  url "https://files.pythonhosted.org/packages/6e/13/1035621807f43f3339ed3535e4dcf52286fd3e96fefecb53797213b42839/python-lsp-server-1.2.2.tar.gz"
  sha256 "8c3e8ff5ff076f1aed8db5f14041e76d19ebd09ba1867e3f5f2f6740423ce0e3"
  license "MIT"

  depends_on "python@3.9"

  resource "setuptools_scm" do
    url "https://files.pythonhosted.org/packages/57/38/930b1241372a9f266a7df2b184fb9d4f497c2cef2e016b014f82f541fe7c/setuptools_scm-6.0.1.tar.gz"
    sha256 "d1925a69cb07e9b29416a275b9fadb009a23c148ace905b2fb220649a6c18e92"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/5e/61/d119e2683138a934550e47fc8ec023eb7f11b194883e9085dca3af5d4951/parso-0.8.2.tar.gz"
    sha256 "12b83492c6239ce32ff5eed6d3639d6a536170723c6f3f1506869f1ace413398"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/ac/11/5c542bf206efbae974294a61febc61e09d74cb5d90d8488793909db92537/jedi-0.18.0.tar.gz"
    sha256 "92550a404bad8afed881a137ec9a461fed49eca661414be45059329614ed0707"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/2c/8d/63b4afe82d646a606cef838855a6110c7a3a012622e656bd29fb2d15f1d1/ujson-4.1.0.tar.gz"
    sha256 "22b63ec4409f0d2f2c4c9d5aa331997e02470b7a15a3233f3cc32f2f9b92d58c"
  end

  resource "python-lsp-jsonrpc" do
    url "https://files.pythonhosted.org/packages/99/45/1c2a272950679af529f7360af6ee567ef266f282e451be926329e8d50d84/python-lsp-jsonrpc-1.0.0.tar.gz"
    sha256 "7bec170733db628d3506ea3a5288ff76aa33c70215ed223abdb0d95e957660bd"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz"
    sha256 "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/02/b3/c832123f2699892c715fcdfebb1a8fdeffa11bb7b2350e46ecdd76b45a20/pycodestyle-2.7.0.tar.gz"
    sha256 "c389c1d06bf7904078ca03399a4816f974a1d590090fecea0c63ec26ebaf1cef"
  end

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/a3/3d/d305c9112f35df6efb51e5acd0db7009b74d86f35580e033451b5994a0a9/snowballstemmer-2.1.0.tar.gz"
    sha256 "e997baa4f2e9139951b6f4c631bad912dfd3c792467e2f03d7239464af90e914"
  end

  resource "pydocstyle" do
    url "https://files.pythonhosted.org/packages/4c/30/4cdea3c8342ad343d41603afc1372167c224a04dc5dc0bf4193ccb39b370/pydocstyle-6.1.1.tar.gz"
    sha256 "1d41b7c459ba0ee6c345f2eb9ae827cab14a7533a88c5c6f7e94923f72df92dc"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/a8/0f/0dc480da9162749bf629dca76570972dd9cce5bedc60196a3c912875c87d/pyflakes-2.3.1.tar.gz"
    sha256 "f5bc8ecabc05bb9d291eb5203d6810b49040f6ff446a756326104746cc00c1db"
  end

  resource "rope" do
    url "https://files.pythonhosted.org/packages/49/b9/f53c6d375a79ce12e0dd710b832a1e7660ab24d37d922f1963253449ee5a/rope-0.19.0.tar.gz"
    sha256 "64e6d747532e1f5c8009ec5aae3e5523a5bcedf516f39a750d57d8ed749d90da"
  end

  resource "yapf" do
    url "https://files.pythonhosted.org/packages/85/60/8532f7ca17cea13de00e80e2fe1e6bd59a9379856706a027536b19daf0d3/yapf-0.31.0.tar.gz"
    sha256 "408fb9a2b254c302f49db83c59f9aa0b4b0fd0ec25be3a5c51181327922ff63d"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
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
