class Ycmd < Formula
  include Language::Python::Virtualenv

  desc "Code-completion & code-comprehension server"
  homepage "https://github.com/Valloric/ycmd"
  url "https://github.com/Valloric/ycmd.git",
      :revision => "c7ffd1d0ef7fb57540bd5c0ceba6068ead80c53c"
  version "2019-04-11"

  option "with-clang-completer", "Build C-family semantic completion engine"
  depends_on "cmake" => :build
  depends_on "python"

  resource "llvm" do
    clang_version = "8.0.0"
    clang_filename = format("libclang-%{version}-x86_64-apple-darwin.tar.bz2",
                            :version => clang_version)
    url format("https://dl.bintray.com/micbou/libclang/%{filename}",
               :filename => clang_filename)
    sha256 "0900559a7aff8a1156949a53b811d6711f8493938e47f0587c2e5e6a5c4972e8"
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

    # create isolated virtualenv and install ycmd and third-party dependencies
    virtualenv_create(libexec, "python3")
    libexec.install "ycmd", "ycm_core.so", "CORE_VERSION",
                    "PYTHON_USED_DURING_BUILDING"
    third_party = [
      "bottle", "cregex", "frozendict", "jedi", "jedi_deps", "parso",
      "python-future", "requests", "requests_deps", "waitress"
    ]
    third_party << "clang" if build.with? "clang-completer"
    (libexec/"third_party").install third_party.map { |s| "third_party/" + s }

    # fix shared library paths which are not fixed automatically
    if build.with? "clang-completer"
      ["#{libexec}/ycm_core.so"].each do |f|
        macho = MachO.open(f)
        macho.change_dylib("@rpath/libclang.dylib",
                           "#{libexec}/third_party/clang/lib/libclang.dylib")
        macho.write!
      end
    end

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
