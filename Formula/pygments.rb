class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Syntax highlighting package written in Python"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/6e/4d/4d2fe93a35dfba417311a4ff627489a947b01dc0cc377a3673c00cf7e4b2/Pygments-2.6.1.tar.gz"
  sha256 "647344a061c249a3b74e230c739f434d7ea4d8b1d5f3721bc0f3558049b38f44"

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(
      "<div class=\"highlight\"><pre><span></span><span class=\"nb\">print</span> <span class=\"s2\">&quot;Hello World&quot;</span>\n</pre></div>\n",
      shell_output(
        "echo 'print \"Hello World\"' | pygmentize -l python -f html",
      ),
    )
  end
end
