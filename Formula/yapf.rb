class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for Python files"
  homepage "https://github.com/google/yapf"
  url "https://github.com/google/yapf.git",
      :tag      => "v0.27.0"
  head "https://github.com/google/yapf.git"

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yapf --version")
  end
end
