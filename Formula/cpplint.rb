class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Google's C++ style guide checker"
  homepage "https://github.com/google/styleguide/tree/gh-pages/cpplint"
  url "https://raw.githubusercontent.com/google/styleguide/43d512ba13014d31f96053c0cdf299775681bc73/cpplint/cpplint.py"
  version "2018-04-15"

  depends_on "python"

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH",
                            libexec/"lib/python#{pyver}/site-packages"
    virtualenv_create(libexec, "python3")
    (libexec/"bin").install "cpplint.py"
    (bin/"cpplint").write <<~EOS
      #!/bin/bash
      PYTHONPATH="#{ENV["PYTHONPATH"]}"
      "#{libexec}/bin/python3" "#{libexec}/bin/cpplint.py" "$@"
    EOS
  end
end
