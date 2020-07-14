class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Google's C++ style guide checker"
  homepage "https://github.com/google/styleguide/tree/gh-pages/cpplint"
  url "https://raw.githubusercontent.com/google/styleguide/08268efb062ca77eb623e5745a2b11424f5951e0/cpplint/cpplint.py"
  version "2020-06-19"
  sha256 "b8a3504be3873675f37c6a98b84e86f67dcb103a14ef7c46cd5fbc4891e43db6"
  license "BSD-3-Clause"

  uses_from_macos "python@2"

  def install
    pyver = Language::Python.major_minor_version "python"
    ENV.prepend_create_path "PYTHONPATH",
                            libexec/"lib/python#{pyver}/site-packages"
    virtualenv_create(libexec, "python")
    (libexec/"bin").install "cpplint.py"
    (bin/"cpplint").write <<~EOS
      #!/bin/bash
      PYTHONPATH="#{ENV["PYTHONPATH"]}"
      "#{libexec}/bin/python" "#{libexec}/bin/cpplint.py" "$@"
    EOS
  end

  test do
    (testpath/"test.cc").write <<~EOS
      void Func(){};
    EOS
    output = shell_output("#{bin}/cpplint test.cc 2>&1", 1)
    assert_match "[legal/copyright]", output
    assert_match "[readability/braces]", output
  end
end
