class Ycmd < Formula
  include Language::Python::Virtualenv

  desc "Code-completion & code-comprehension server"
  homepage "https://github.com/Valloric/ycmd"
  url "https://github.com/Valloric/ycmd.git",
      :revision => "eca62b77d1b2b34aaa50033425bd215263d8fee2"
  version "2019-01-23"

  option "with-clang-completer", "Build C-family semantic completion engine"
  depends_on "cmake" => :build
  depends_on "python"

  resource "llvm" do
    clang_version = "7.0.0"
    clang_filename = format("libclang-%{version}-x86_64-apple-darwin.tar.bz2",
                            :version => clang_version)
    url format("https://dl.bintray.com/micbou/libclang/%{filename}",
               :filename => clang_filename)
    sha256 "db84d5a622390300af76d73221ffba8c6923a477bce069e85763c046b207eb80"
  end

  def install
    args = []

    if build.with? "clang-completer"
      mkdir buildpath/"clang_archives" do
        [resource("llvm")].each do |r|
          r.verify_download_integrity(r.fetch)
          cp r.cached_download, File.basename(URI.parse(r.url).path)
        end
      end
      args << "--clang-completer"
    end

    # build ycmd
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH",
                            libexec/"lib/python#{pyver}/site-packages"
    system "python3", "build.py", *args

    # install docs
    doc.install "COPYING.txt", "README.md"

    # create isolated virtualenv and install ycmd
    virtualenv_create(libexec, "python3")
    libexec.install "ycmd", "ycm_core.so", "CORE_VERSION",
                    "PYTHON_USED_DURING_BUILDING"
    (libexec/"third_party").install [
      "jedi_deps", "bottle", "frozendict", "python-future", "requests_deps",
      "waitress", "cregex"
    ].map { |s| "third_party/" + s }

    libexec.install "libclang.dylib" if build.with? "clang-completer"

    # create wrapper script using virtualenv python
    (bin/"ycmd").write <<~EOS
      #!/bin/bash
      PYTHONPATH="#{ENV["PYTHONPATH"]}"
      "#{libexec}/bin/python3" "#{libexec}/ycmd" "$@"
    EOS
  end

  test do
    assert_match "usage: ycmd", shell_output("#{bin}/ycmd -h")
  end
end
