class Pytype < Formula
  include Language::Python::Virtualenv

  desc "Static analyzer for Python code"
  homepage "https://github.com/google/pytype/"
  url "https://github.com/google/pytype.git",
      :revision => "bddf0d70966c15ec920de185a5e78fbbc7aecb00"
  version "2017-12-23"
  head "https://github.com/google/pytype.git"

  depends_on :python if MacOS.version <= :snow_leopard
  # depends on "libyaml" => :recommend  # TODO(johan)

  resource "pyyaml" do
    url "https://pyyaml.org/download/pyyaml/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  def install
    virtualenv_install_with_resources
  end
end
