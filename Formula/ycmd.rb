class Ycmd < Formula
  desc "A code-completion & code-comprehension server"
  homepage "https://github.com/Valloric/ycmd"
  url "https://github.com/Valloric/ycmd.git",
      :revision => "480b1c716b961ff6728f9b144014f3ffffceaed4"
  version "2017-07-28"

  depends_on :python
  depends_on "cmake" => :build
  option "with-clang-completer", "Build C-family semantic completion engine"

  resource "llvm" do
    clang_version = "4.0.1"
    clang_filename = format("clang+llvm-%s-x86_64-apple-darwin.tar.xz",
                            clang_version)
    url format("http://llvm.org/releases/%s/%s", clang_version, clang_filename)
    sha256 "5f697801a46239c04251730b7ccccd3ebbacb9043ad381a061ae6812409e9eae"
  end

  include Language::Python::Virtualenv

  def install
    args = []

    if build.with? "clang-completer"
      mkdir buildpath/"clang_archives" do
        cp resource("llvm").cached_download,
           File.basename(URI.parse(resource("llvm").url).path)
      end
      args << "--clang-completer"
    end

    # build ycmd
    system "python", "build.py", *args

    # install docs
    doc.install "COPYING.txt", "README.md"

    # create isolated virtualenv and install ycmd
    virtualenv_create(libexec)
    libexec.install "ycmd", "ycm_core.so", "CORE_VERSION",
                    "PYTHON_USED_DURING_BUILDING"
    (libexec/"third_party").install [
      "JediHTTP", "argparse", "bottle", "frozendict", "python-future",
      "requests", "waitress"
    ].map { |s| "third_party/" + s }

    libexec.install "libclang.dylib" if build.with? "clang-completer"

    # create wrapper script using virtualenv python
    (bin/"ycmd").write <<-EOS.undent
      #!/bin/bash
      #{libexec}/bin/python #{libexec}/ycmd "$@"
    EOS
  end
end
