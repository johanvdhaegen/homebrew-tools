class Ycmd < Formula
  include Language::Python::Virtualenv

  desc "Code-completion & code-comprehension server"
  homepage "https://github.com/Valloric/ycmd"
  url "https://github.com/Valloric/ycmd.git",
      :revision => "ea58cfcf502dad92258102a5dd1911d43e39bcda"
  version "2018-07-25"

  option "with-clang-completer", "Build C-family semantic completion engine"
  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "cmake" => :build

  resource "llvm" do
    clang_version = "6.0.0"
    clang_filename = format("libclang-%s-x86_64-apple-darwin.tar.bz2",
                            clang_version)
    url format("https://dl.bintray.com/micbou/libclang/%s", clang_filename)
    sha256 "fd12532e3eb7b67cfede097134fc0a5b478c63759bcbe144ae6897f412ce2fe6"
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
    system "python", "build.py", *args

    # install docs
    doc.install "COPYING.txt", "README.md"

    # create isolated virtualenv and install ycmd
    virtualenv_create(libexec)
    libexec.install "ycmd", "ycm_core.so", "CORE_VERSION",
                    "PYTHON_USED_DURING_BUILDING"
    (libexec/"third_party").install [
      "JediHTTP", "bottle", "frozendict", "python-future", "requests",
      "waitress"
    ].map { |s| "third_party/" + s }

    libexec.install "libclang.dylib" if build.with? "clang-completer"

    # create wrapper script using virtualenv python
    (bin/"ycmd").write <<~EOS
      #!/bin/bash
      #{libexec}/bin/python #{libexec}/ycmd "$@"
    EOS
  end

  test do
    assert_match "usage: ycmd", shell_output("#{bin}/ycmd -h")
  end
end
