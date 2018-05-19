class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for Python files"
  homepage "https://github.com/google/yapf"
  url "https://github.com/google/yapf.git",
      :tag => "v0.22.0",
      :revision => "d52ae2a4d32bb3d1ca1076b4181474b486972ff0"
  head "https://github.com/google/yapf.git"

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yapf --version")
  end
end
