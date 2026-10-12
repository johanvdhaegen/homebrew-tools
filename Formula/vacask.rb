class Vacask < Formula
  desc "Analog circuit simulator with Verilog-A device models"
  homepage "https://codeberg.org/arpadbuermen/VACASK"
  url "https://codeberg.org/arpadbuermen/VACASK/archive/_0.3.4.tar.gz"
  sha256 "a55ff7fa0b5495bb2180a865be32816e0a1457e978a5033db06ddc716b23845c"
  license "AGPL-3.0-only"

  livecheck do
    url :head
    regex(/^_(\d+(?:\.\d+)+)$/i)
    strategy :git
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/vacask-0.3.4"
    sha256               arm64_tahoe:   "d0fa2492ca62c523d712bda8f178beb3fcda63baf764756b83c40f6d2aa11a7b"
    sha256               arm64_sequoia: "9301deed31a69e843a776a93332f6d7d8e9adfd0bcf605b7e0ca2dfb5abaaeda"
    sha256               arm64_linux:   "f063bd66bdb8e0c2d1d2daa103a197b27d1703a0fa61bec8242ff080d6c14793"
    sha256 cellar: :any, x86_64_linux:  "bc33c92b3e514b85f02829243ecd2fb0b0c0409b4c3e422c3cbbf0bd8b03e1ef"
  end

  head do
    url "https://codeberg.org/arpadbuermen/VACASK.git", branch: "main"
    depends_on "fftw"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "tomlplusplus" => :build
  depends_on "boost"
  depends_on "openblas"
  depends_on "openvaf"
  depends_on "suite-sparse"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    on_arm do
      # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=119372
      fails_with :gcc do
        version "14"
        cause "Emits duplicate ARM return authentication instructions with branch protection"
      end
    end
  end

  def install
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "set(Boost_USE_STATIC_LIBS ON)", "set(Boost_USE_STATIC_LIBS OFF)"
      # Homebrew's build environment does not put brew itself on PATH.
      s.gsub! "execute_process(COMMAND brew --prefix OUTPUT_VARIABLE BREW_PREFIX OUTPUT_STRIP_TRAILING_WHITESPACE)",
              "set(BREW_PREFIX \"#{HOMEBREW_PREFIX}\")"
      # OpenVAF's formula selects its own LLVM version.
      s.gsub!(/^\s*set\(LLVM_PREFIX .*\)\n/, "")
      s.gsub!(/^\s*set\(ENV\{LLVM_SYS_181_PREFIX\} .*\)\n/, "")
      s.gsub! 'set(PROGRAM_VERSION "unknown")', "set(PROGRAM_VERSION \"#{version}\")" unless build.head?
    end

    # COMPILE_OPTIONS expects a list, while FindOpenMP supplies a flag string.
    inreplace "lib/CMakeLists.txt" do |s|
      s.sub! "if (OpenMP_CXX_FOUND)", <<~CMAKE.chomp
        separate_arguments(VACASK_OPENMP_OPTIONS NATIVE_COMMAND "${OpenMP_CXX_FLAGS}")
        if (OpenMP_CXX_FOUND)
      CMAKE
      s.gsub! 'COMPILE_OPTIONS "${OpenMP_CXX_FLAGS}"', 'COMPILE_OPTIONS "${VACASK_OPENMP_OPTIONS}"'
    end

    # Use the dependency at runtime, and omit upstream's bundled compiler copy.
    inreplace "lib/libplatform.cpp", 'static const char binary[] = "openvaf-r";',
              "static const char binary[] = \"#{formula_opt_bin("openvaf")}/openvaf-r\";"
    inreplace "packaging.cmake", /install\(FILES \$\{OPENVAF_COMPILER\}.*?\)\r?\n/m, ""
    inreplace "simulator/platform.cpp", '"/etc/vacask/vacaskrc.toml"', "\"#{etc}/vacask/vacaskrc.toml\""

    args = [
      "-DOPENVAF_DIR=#{formula_opt_bin("openvaf")}",
      "-DOPENVAF_OPTIONS=--target_cpu generic",
      "-DBoost_ROOT=#{formula_opt_prefix("boost")}",
      "-DSuiteSparse_DIR=#{formula_opt_prefix("suite-sparse")}",
      "-DTOMLPP_DIR=#{formula_opt_prefix("tomlplusplus")}",
      "-DOPENBLAS_DIR=#{formula_opt_prefix("openblas")}",
      "-DBLA_VENDOR=OpenBLAS",
      "-DCADNIP_PARSERS=OFF",
    ]
    args << "-DFFTW3_DIR=#{formula_opt_prefix("fftw")}" if build.head?
    if OS.mac?
      args += [
        "-DOpenMP_CXX_FLAGS=-Xpreprocessor -fopenmp",
        "-DOpenMP_CXX_LIB_NAMES=omp",
        "-DOpenMP_omp_LIBRARY=#{formula_opt_lib("libomp")}/libomp.dylib",
        "-DOpenMP_CXX_INCLUDE_DIR=#{formula_opt_include("libomp")}",
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build", "--parallel", ENV.make_jobs
    system "cmake", "--install", "build"
    (etc/"vacask").install "config/vacaskrc-sample.toml" => "vacaskrc.toml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vacask --help") unless build.head?
    (testpath/"custom.va").write <<~EOS
      `include "disciplines.vams"
      module custom_resistor(p, n);
        inout p, n;
        electrical p, n;
        parameter real r = 1000.0 from (0:inf);
        analog I(p, n) <+ V(p, n) / r;
      endmodule
    EOS
    (testpath/"divider.sim").write <<~EOS
      Voltage divider
      ground 0
      load "resistor.osdi"
      load "custom.va"
      model source vsource
      model bundled resistor r=1k noisy=0
      model custom custom_resistor r=1k
      v1 (in 0) source dc=1
      r1 (in out) bundled
      r2 (out 0) custom
      control
        abort always
        options rawfile="ascii"
        analysis divider op
      endc
    EOS
    system bin/"vacask", "divider.sim"
    assert_path_exists testpath/"custom.osdi"

    raw = (testpath/"divider.raw").read
    variables, values = raw.split("Variables:\n", 2).last.split("Values:\n", 2)
    names = variables.lines.map { |line| line.split[1] }
    solution = values.split.drop(1).map(&:to_f)
    assert_in_delta 0.5, solution.fetch(names.index("out")), 1e-9
    assert_in_delta(-0.0005, solution.fetch(names.index("v1:flow(br)")), 1e-12)
  end
end
