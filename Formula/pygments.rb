class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Syntax highlighting package written in Python"
  homepage "http://pygments.org/"
  url "https://files.pythonhosted.org/packages/7e/ae/26808275fc76bf2832deb10d3a3ed3107bc4de01b85dcccbe525f2cd6d1e/Pygments-2.4.2.tar.gz"
  sha256 "881c4c157e45f30af185c1ffe8d549d48ac9127433f2c380c24b84572ad66297"

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(
      "<div class=\"highlight\"><pre><span></span><span class=\"k\">print</span> <span class=\"s2\">&quot;Hello World&quot;</span>\n</pre></div>\n",
      shell_output(
        "echo 'print \"Hello World\"' | pygmentize -l python -f html",
      ),
    )
  end
end
