class Ycmd < Formula
  include Language::Python::Virtualenv

  desc "Code-completion & code-comprehension server"
  homepage "https://github.com/Valloric/ycmd"
  url "https://github.com/Valloric/ycmd.git",
      revision: "a24204e8382d0660a519f88b59c67026f453c085"
  version "2020-08-10"
  license "GPL-3.0"

  option "with-clang-completer", "Enable C-family semantic completion engine"
  option "with-go-completer", "Enable Go semantic completion engine"
  depends_on "cmake" => :build
  depends_on "go" => :build if build.with? "go-completer"
  depends_on "python@3.8"

  resource "llvm" do
    clang_version = "10.0.0"
    clang_filename = format("libclang-%<version>s-x86_64-apple-darwin.tar.bz2",
                            version: clang_version)
    url format("https://dl.bintray.com/ycm-core/libclang/%<filename>s",
               filename: clang_filename)
    sha256 "157c755c0d208414203b56057fd4f9b81dba93fd968e4435217ba1e4026136a8"
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
    args << "--go-completer" if build.with? "go-completer"

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
    third_party = %w[
      bottle cregex generic_server jedi_deps python-future requests_deps
      waitress watchdog_deps
    ]
    third_party << "clang" if build.with? "clang-completer"
    third_party << "go" if build.with? "go-completer"
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

    # fix third-party go modules permissions
    if build.with? "go-completer"
      chmod "u+w", Dir["#{libexec}/third_party/go/pkg/mod/*"]
      chmod "u+w", Dir.glob("#{libexec}/third_party/go/pkg/mod/**",
                            File::FNM_DOTMATCH)
      chmod "u+w", Dir.glob("#{libexec}/third_party/go/pkg/mod/**/*",
                            File::FNM_DOTMATCH)
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
