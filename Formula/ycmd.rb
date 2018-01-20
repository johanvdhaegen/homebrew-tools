class Ycmd < Formula
  include Language::Python::Virtualenv

  desc "Code-completion & code-comprehension server"
  homepage "https://github.com/Valloric/ycmd"
  url "https://github.com/Valloric/ycmd.git",
      :revision => "4fa81b5f9535c2a9fa37e96adec53abfc1cce133"
  version "2017-12-23"

  option "with-clang-completer", "Build C-family semantic completion engine"
  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "cmake" => :build

  resource "llvm" do
    clang_version = "5.0.1"
    clang_filename = format("clang+llvm-%s-x86_64-apple-darwin.tar.xz",
                            clang_version)
    url format("https://releases.llvm.org/%s/%s", clang_version, clang_filename)
    sha256 "c5b105c4960619feb32641ef051fa39ecb913cc0feb6bacebdfa71f8d3cae277"
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

  test do
    assert_match "usage: ycmd", shell_output("#{bin}/ycmd -h")
  end
end
