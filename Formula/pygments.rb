class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Syntax highlighting package written in Python"
  homepage "http://pygments.org/"
  url "https://files.pythonhosted.org/packages/64/69/413708eaf3a64a6abb8972644e0f20891a55e621c6759e2c3f3891e05d63/Pygments-2.3.1.tar.gz"
  sha256 "5ffada19f6203563680669ee7f53b64dabbeb100eb51b61996085e99c03b284a"

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
