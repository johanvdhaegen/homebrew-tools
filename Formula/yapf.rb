class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for Python files"
  homepage "https://github.com/google/yapf"
  url "https://github.com/google/yapf.git",
      :tag      => "v0.26.0",
      :revision => "37f675d2baea555b94920251475fa968a454225b"
  head "https://github.com/google/yapf.git"

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yapf --version")
  end
end
