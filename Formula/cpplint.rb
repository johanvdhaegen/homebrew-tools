class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Google's C++ style guide checker"
  homepage "https://github.com/google/styleguide/tree/gh-pages/cpplint"
  url "https://raw.githubusercontent.com/google/styleguide/26470f9ccb354ff2f6d098f831271a1833701b28/cpplint/cpplint.py"
  version "2019-11-19"
  sha256 "1cab0b908f059bf767f2bca296c67c6383d3e4971833b155b991649a9b492775"

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
