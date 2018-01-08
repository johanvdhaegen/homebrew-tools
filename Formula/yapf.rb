class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for Python files"
  homepage "https://github.com/google/yapf"
  url "https://github.com/google/yapf.git",
      :tag => "v0.20.0",
      :revision => "0b8364e5fd715261dcf520a5b292bc8fc515ae7e"
  head "https://github.com/google/yapf.git"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    virtualenv_install_with_resources
  end
end
