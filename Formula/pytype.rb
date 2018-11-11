class Pytype < Formula
  include Language::Python::Virtualenv

  desc "Static analyzer for Python code"
  homepage "https://github.com/google/pytype/"
  url "https://files.pythonhosted.org/packages/e6/f1/1e950c8b3122178c63259c458329500f4d889f0c320c2af27a2b220cf318/pytype-2018.10.30.tar.gz"
  sha256 "fdbbb2ae1c739b4bad67bfdfeedbe21d5b41c9689e6370e441101f3149157d43"
  version "2018-10-30"
  head "https://github.com/google/pytype.git"

  depends_on "python"
  # depends on "libyaml" => :recommend  # TODO(johan)

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/6f/24/15a229626c775aae5806312f6bf1e2a73785be3402c0acdec5dbddd8c11e/decorator-4.3.0.tar.gz"
    sha256 "c39efa13fbdeb4506c476c9b3babf6a718da943dab7811c206005a4a956c080c"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/f3/f4/7e20ef40b118478191cec0b58c3192f822cace858c19505c7670961b76b2/networkx-2.2.zip"
    sha256 "45e56f7ab6fe81652fb4bc9f44faddb0e9025f469f602df14e3b2551c2ea5c8b"
  end

  resource "importlab" do
    url "https://files.pythonhosted.org/packages/89/f7/ef55882b6db6022ef476a4fbd8c843f3c25971d9d6e7766be9ae6f11146e/importlab-0.3.1.tar.gz"
    sha256 "b5fdb0e32c43192aa13869c9b14a8141ec5f73c406581fa544e57a12cda2ae53"
  end

  resource "pyyaml" do
    url "https://pyyaml.org/download/pyyaml/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end
end
