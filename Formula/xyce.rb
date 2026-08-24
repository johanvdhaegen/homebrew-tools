class Xyce < Formula
  desc "Parallel circuit simulator from Sandia National Laboratories"
  homepage "https://xyce.sandia.gov/"
  url "https://github.com/Xyce/Xyce/archive/refs/tags/Release-7.10.0.tar.gz"
  sha256 "b5a883196f0a2b3972fd13c541fecf04735bfabc7d124d7c7e17de707204f4e2"
  license "GPL-3.0-or-later"
  head "https://github.com/Xyce/Xyce.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/Release[._-]v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/xyce-7.10.0"
    sha256 cellar: :any, arm64_tahoe:   "272fe1ca0622f574240c1666d506a9d5600404567467db38dfe65527cfb822eb"
    sha256 cellar: :any, arm64_sequoia: "40835a5bb518906ee24330e57c987adf4023686443ff69a78c4c00cf15b241fd"
    sha256 cellar: :any, arm64_linux:   "5b3534f33311281bf180371f1ceb8c0c34a95bf34a1068dacf194081e30ea747"
    sha256 cellar: :any, x86_64_linux:  "04d3f1154499cd945fbd0721bab52ea7ee93d3e036ac55a0defba4eac0416034"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build # Xyce needs flex 2.6+; macOS ships 2.5.35
  depends_on "pkgconf" => :build
  depends_on "adms" # for Verilog-A support
  depends_on "fftw"
  depends_on "suite-sparse" # indirect dependency through trilinos-xyce
  depends_on "trilinos-xyce"

  on_linux do
    depends_on "openblas" # indirect dependency through trilinos-xyce
  end

  # `std::abs<double>(val)` is ambiguous under libc++: the floating-point
  # overloads are not templates, so the explicit template argument only matches
  # the integral ones.  Upstream Xyce has since dropped the template argument.
  patch :DATA

  def install
    args = [
      "-DTrilinos_ROOT=#{formula_opt_prefix("trilinos-xyce")}",
      # Homebrew's bison and flex are keg-only, and Xyce needs FlexLexer.h.
      "-DBISON_EXECUTABLE=#{formula_opt_bin("bison")}/bison",
      "-DFLEX_EXECUTABLE=#{formula_opt_bin("flex")}/flex",
      "-DFLEX_INCLUDE_DIR=#{formula_opt_include("flex")}",
      # Verilog-A plugin support.  This forces BUILD_SHARED_LIBS to ON.
      "-DXyce_PLUGIN_SUPPORT=ON",
      # Sacado specializes std::is_same, which libc++ marks as
      # `_LIBCPP_NO_SPECIALIZATIONS` -- a default-error diagnostic.  CMake alone
      # passes the Trilinos headers with `-isystem`, which would suppress it,
      # but superenv also adds a plain `-I` for every dependency, and that wins.
      "-DCMAKE_CXX_FLAGS=-Wno-invalid-specialization",
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Xyce installs adms's `admsXml` into its own bin, which would collide with
    # the adms formula on link -- and because CMake copies the symlink it found
    # rather than the file behind it, that copy is left dangling.  Point the
    # plugin tooling at the adms keg instead and drop the copy.
    adms_bin = formula_opt_bin("adms")
    inreplace bin/"buildxyceplugin.sh", "${XyceInstDir}/bin/admsXml", "#{adms_bin}/admsXml"
    inreplace share/"CMakeLists.txt", "PATHS ${Xyce_BinDir}", "PATHS #{adms_bin}"
    rm bin/"admsXml"

    # `buildxyceplugin.sh` and the installed CMake files record the compiler
    # Xyce was built with.  Under Homebrew that is a shim, which is only usable
    # inside a Homebrew build.
    shimmed = (bin.glob("*") + lib.glob("cmake/**/*.cmake") + share.glob("**/*.cmake")).select do |f|
      f.file? && !f.symlink? && f.binread.include?(Superenv.shims_path.to_s)
    end
    inreplace shimmed, "#{Superenv.shims_path}/", ""
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/Xyce -v")

    # The plugin tooling has to reach admsXml in the adms keg, since Xyce's own
    # copy is removed above.
    assert_match "#{formula_opt_bin("adms")}/admsXml", (bin/"buildxyceplugin.sh").read

    (testpath/"rc.cir").write <<~EOS
      RC test circuit
      v1 1 0 1
      r1 1 2 1k
      c1 2 0 1u ic=0
      .tran 10u 5m uic
      .print tran v(2)
      .end
    EOS
    system bin/"Xyce", "rc.cir"

    # Five time constants, so the capacitor charges to (1 - e**-5) of 1 V.
    output = (testpath/"rc.cir.prn").read
    assert_match "V(2)", output
    assert_in_delta 0.9933, output.lines.grep(/^\d/).last.split[2].to_f, 0.005
  end
end

__END__
--- a/src/LinearAlgebraServicesPKG/N_LAS_BlockSystemHelpers.C
+++ b/src/LinearAlgebraServicesPKG/N_LAS_BlockSystemHelpers.C
@@ -815,8 +815,8 @@
       Vector& timeVecRef = xt.block(i);
       double val = timeVecRef[j];
       (*inputSignal)[i] = val;
-      if (std::abs<double>(val) > norm1)
-        norm1 = std::abs<double>(val);
+      if (std::abs(val) > norm1)
+        norm1 = std::abs(val);
     }
 
     // Calculate the DFT for the inputSignal.
