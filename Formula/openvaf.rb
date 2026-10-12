class Openvaf < Formula
  desc "Verilog-A compiler for use in circuit simulators"
  homepage "https://github.com/OpenVAF-Reloaded/OpenVAF"
  url "https://github.com/OpenVAF-Reloaded/OpenVAF/archive/5ed9e63afe70ac95129a78af7b3732e7d431b1e5.tar.gz"
  version "23.5.0.20260820"
  sha256 "ab669d00a47b73deef8a6d50849b09d905e5bd28b7b1e23b874458419e8d9899"
  license "GPL-3.0-only"
  head "https://github.com/OpenVAF-Reloaded/OpenVAF.git", branch: "master"

  livecheck do
    skip "Pinned to an upstream commit snapshot"
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/openvaf-23.5.0.20260820"
    sha256 cellar: :any, arm64_tahoe:   "3edea6371406ee2560bd3656aa76a318799e704f1d43d52442b820b79eda04cb"
    sha256 cellar: :any, arm64_sequoia: "144bf03600f77f827566b8b4155512daddcc82cde34d18fb7fdc26a99069ec21"
    sha256 cellar: :any, arm64_linux:   "5c4e2f2a8cefc4ae38b227f3df8934ae7fe7fda53437dc013e4a1d96617ffd96"
    sha256 cellar: :any, x86_64_linux:  "cba22915b78bd1f25b970e4a5f12ee3a7ae6c2d029d4df4dd99356c5ea2096c7"
  end

  depends_on "rust" => :build
  depends_on "llvm@21"

  def install
    llvm = Formula["llvm@21"]
    ENV["LLVM_SYS_211_PREFIX"] = llvm.opt_prefix
    ENV.prepend_path "PATH", llvm.opt_bin
    # The target build script also compiles Windows import libraries.
    ENV["CC"] = llvm.opt_bin/"clang"

    # Source archives have no Git metadata for the upstream version probe.
    unless build.head?
      inreplace "openvaf/openvaf-driver/build.rs", '"unknown".to_string()', "\"#{version}\".to_string()"
    end

    system "cargo", "install", *std_cargo_args(path: "openvaf/openvaf-driver", features: "llvm21")
    (include/"openvaf").install "openvaf/osdi/header/osdi_0_4.h"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openvaf-r --version") unless build.head?
    (testpath/"resistor.va").write <<~EOS
      `include "disciplines.vams"
      module resistor(p, n);
        inout p, n;
        electrical p, n;
        parameter real r = 1000.0 from (0:inf);
        analog I(p, n) <+ V(p, n) / r;
      endmodule
    EOS
    system bin/"openvaf-r", "resistor.va", "-o", "resistor.osdi"

    # Load the generated model and check its ABI and descriptor, not just its existence.
    (testpath/"check.c").write <<~EOS
      #include <assert.h>
      #include <dlfcn.h>
      #include <stdint.h>
      #include <string.h>
      #include <openvaf/osdi_0_4.h>

      int main(void) {
        void *model = dlopen("./resistor.osdi", RTLD_NOW);
        assert(model);
        const uint32_t *major = dlsym(model, "OSDI_VERSION_MAJOR");
        const uint32_t *minor = dlsym(model, "OSDI_VERSION_MINOR");
        const uint32_t *count = dlsym(model, "OSDI_NUM_DESCRIPTORS");
        const OsdiDescriptor *descriptor = dlsym(model, "OSDI_DESCRIPTORS");
        assert(major && *major == OSDI_VERSION_MAJOR_CURR);
        assert(minor && *minor == OSDI_VERSION_MINOR_CURR);
        assert(count && *count == 1);
        assert(descriptor && strcmp(descriptor->name, "resistor") == 0);
        assert(descriptor->num_terminals == 2);
        return dlclose(model);
      }
    EOS
    args = ["check.c", "-I#{include}", "-o", "check"]
    args << "-ldl" if OS.linux?
    system ENV.cc, *args
    system "./check"
  end
end
