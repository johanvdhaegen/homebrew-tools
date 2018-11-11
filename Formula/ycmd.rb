class Ycmd < Formula
  include Language::Python::Virtualenv

  desc "Code-completion & code-comprehension server"
  homepage "https://github.com/Valloric/ycmd"
  url "https://github.com/Valloric/ycmd.git",
      :revision => "600f54de207207a69761e3b585a3bc12194eb49f"
  version "2018-09-18"

  option "with-clang-completer", "Build C-family semantic completion engine"
  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "cmake" => :build

  resource "llvm" do
    clang_version = "7.0.0"
    clang_filename = format("libclang-%s-x86_64-apple-darwin.tar.bz2",
                            clang_version)
    url format("https://dl.bintray.com/micbou/libclang/%s", clang_filename)
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
    system "python", "build.py", *args

    # install docs
    doc.install "COPYING.txt", "README.md"

    # create isolated virtualenv and install ycmd
    virtualenv_create(libexec)
    libexec.install "ycmd", "ycm_core.so", "CORE_VERSION",
                    "PYTHON_USED_DURING_BUILDING"
    (libexec/"third_party").install [
      "parso", "jedi", "bottle", "frozendict", "python-future", "requests",
      "waitress", "cregex"
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
