class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for Python files"
  homepage "https://github.com/google/yapf"
  url "https://github.com/google/yapf.git",
      :tag => "v0.21.0",
      :revision => "da07705ef020a66c5ca8b335ee66e256be614593"
  head "https://github.com/google/yapf.git"

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    virtualenv_install_with_resources
  end
end
