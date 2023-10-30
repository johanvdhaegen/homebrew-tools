class RustLlvm15AT170 < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.70.0-src.tar.gz"
    sha256 "b2bfae000b7a5040e4ec4bbc50a09f21548190cb7570b0ed77358368413bd27c"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.71.0.tar.gz"
      sha256 "43ddf8be33d0f9d2514a75ae0df57ed95c8e99a9869deddf49e6eeee5d56e940"
    end
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/rust-llvm-15@1.70-1.70.0"
    sha256 cellar: :any,                 ventura:      "e56458d847743b922347592826f8aa601037cbc263e3a6c98206adc76d038b9d"
    sha256 cellar: :any,                 monterey:     "67cf43bafe2be292f468c7dc034e2f840ce9ea12922c0a2538c229f326ffbded"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3d290811952874e6f315722ce7d7d8acc57dcaf99a118d31c6540b46fe4f6b97"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "master"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  keg_only "conflicts with rust"

  depends_on "python@3.11" => :build
  depends_on "llvm@15"
  depends_on "openssl@3"
  depends_on "pkg-config"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  resource "cargobootstrap" do
    on_macos do
      # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      on_arm do
        url "https://static.rust-lang.org/dist/2023-04-20/cargo-1.69.0-aarch64-
apple-darwin.tar.gz"
        sha256 "b185ea41a0ad76ac23b08744732c51e4811528291f7193d612a42e3e54ecd535"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-04-20/cargo-1.69.0-x86_64-apple-darwin.tar.gz"
        sha256 "3ed0b5eaaf7e908f196b4882aad757cb2a623ca3c8e8e74471422df5e93ebfb0"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      on_arm do
        url "https://static.rust-lang.org/dist/2023-04-20/cargo-1.69.0-aarch64-unknown-linux-gnu.tar.gz"
        sha256 "6ba6e4a9295b03d01b7dac94b7941d71c029343dc3abfd6cc4733a99fc3c7976"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-04-20/cargo-1.69.0-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "7ee899206f592a86687478465970aa6b57772ccbe9a1f1b7695aa1237c2325a6"
      end
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"

    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    if OS.mac?
      # Requires the CLT to be the active developer directory if Xcode is installed
      ENV["SDKROOT"] = MacOS.sdk_path
      # Fix build failure for compiler_builtins "error: invalid deployment target
      # for -stdlib=libc++ (requires OS X 10.7 or later)"
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    end

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --llvm-root=#{Formula["llvm@15"].opt_prefix}
      --enable-llvm-link-shared
      --enable-vendor
      --disable-cargo-native-static
      --set=rust.jemalloc
      --release-description=#{tap.user}
    ]
    if build.head?
      args << "--disable-rpath"
      args << "--release-channel=nightly"
    else
      args << "--release-channel=stable"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    resource("cargobootstrap").stage do
      system "./install.sh", "--prefix=#{buildpath}/cargobootstrap"
    end
    ENV.prepend_path "PATH", buildpath/"cargobootstrap/bin"

    resource("cargo").stage do
      ENV["RUSTC"] = bin/"rustc"
      args = %W[--root #{prefix} --path .]
      args += %w[--features curl-sys/force-system-lib-on-osx] if OS.mac?
      system "cargo", "install", *args
      man1.install Dir["src/etc/man/*.1"]
      bash_completion.install "src/etc/cargo.bashcomp.sh"
      zsh_completion.install "src/etc/_cargo"
    end

    (lib/"rustlib/src/rust").install "library"
    rm_f [
      bin.glob("*.old"),
      lib/"rustlib/install.log",
      lib/"rustlib/uninstall.sh",
      (lib/"rustlib").glob("manifest-*"),
    ]
  end

  def post_install
    Dir["#{lib}/rustlib/**/*.dylib"].each do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      MachO.codesign!(dylib) if Hardware::CPU.arm?
      chmod 0444, dylib
    end
  end

  test do
    system bin/"rustdoc", "-h"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system bin/"rustc", "hello.rs"
    assert_equal "Hello World!\n", shell_output("./hello")
    system bin/"cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!", cd("hello_world") {
      shell_output("PATH=#{bin}:$PATH #{bin}/cargo run").split("\n").last
    }
  end
end
