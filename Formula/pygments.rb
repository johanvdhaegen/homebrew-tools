class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Syntax highlighting package written in Python"
  homepage "http://pygments.org/"
  url "https://files.pythonhosted.org/packages/91/29/3131bac2b484a9f87aed53d84328307b91fb238effa44ade3f241de36e4a/Pygments-2.4.1.tar.gz"
  sha256 "b437bc0d04dc36f1f5b3592985b3e0a3d0af46b7c39199231706d19a4ee63344"

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
