class Pytype < Formula
  include Language::Python::Virtualenv

  desc "Static analyzer for Python code"
  homepage "https://github.com/google/pytype/"
  url "https://github.com/google/pytype.git",
      :revision => "f0e7aa70ffe6fd5a4e16d39795924afcdbac3555"
  version "2018-01-09"
  head "https://github.com/google/pytype.git"

  depends_on "python" if MacOS.version <= :snow_leopard
  # depends on "libyaml" => :recommend  # TODO(johan)

  resource "pyyaml" do
    url "https://pyyaml.org/download/pyyaml/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  def install
    virtualenv_install_with_resources
  end
end
