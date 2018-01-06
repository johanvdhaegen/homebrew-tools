class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Syntax highlighting package written in Python"
  homepage "http://pygments.org/"
  url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
  sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    # create isolated virtualenv and install pygments
    virtualenv_create(libexec)
    # build
    system libexec/"bin/python", *Language::Python.setup_install_args(libexec)
    # install symlink
    bin.install_symlink libexec/"bin/pygmentize"
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
