class TrilinosXyce < Formula
  desc "Trilinos solver libraries, built with the packages Xyce requires"
  homepage "https://trilinos.github.io/"
  url "https://github.com/trilinos/Trilinos/archive/refs/tags/trilinos-release-14-4-0.tar.gz"
  version "14.4.0"
  sha256 "8e7d881cf6677aa062f7bfea8baa1e52e8956aa575d6a4f90f2b6f032632d4c6"
  # Trilinos is a collection of packages, each licensed individually.
  license :cannot_represent
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
    regex(/trilinos[._-]release[._-]v?(\d+)[._-](\d+)[._-](\d+)/i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/trilinos-xyce-14.4.0_1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69949bdf81e2ee6e29904f2077d6c49ea0b1c4c5ea78de61d2490d919105cda6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23cb6e368a2c0a9a51b0f4e251243322cef15b83c6cb2aedbb238533b279e477"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6d3506c7bd0973d5b87d297fe1d94b2d77577f6f3a6d1417431b2e2216ded25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37730d4910032d76a8719e79860b8f805ea5d0f846f1ae3bd88b54475f5a258b"
  end

  keg_only "it is built with only the subset of Trilinos that Xyce uses"

  depends_on "cmake" => :build
  # Trilinos has Fortran sources; Xyce's build notes report AztecOO failures
  # when Apple Clang is used without a Fortran compiler. libgfortran is needed
  # at link time by anything using these libraries, so this is not a build-only
  # dependency.
  depends_on "gcc"
  # Xyce uses AMD through Trilinos; it is the only part of SuiteSparse needed.
  depends_on "suite-sparse"

  on_linux do
    depends_on "openblas"
  end

  # The bundled KokkosKernels calls `sort_option`, a member that is never
  # declared. Trilinos explicitly instantiates SPADDHandle, which forces those
  # bodies to be compiled, and Clang rejects them. Upstream KokkosKernels has
  # since removed both accessors; do the same here.
  patch :DATA

  def install
    # The package and option selection below is Xyce's `trilinos-base.cmake`
    # initial-cache file (`cmake/trilinos/` in the Xyce sources), inlined so
    # that this formula does not depend on the Xyce tarball.  Xyce 7.10 requires
    # Trilinos 14.4; the Xyce team notes that later versions are untested.
    args = %w[
      -DTrilinos_ENABLE_NOX=ON
      -DNOX_ENABLE_LOCA=ON
      -DTrilinos_ENABLE_EpetraExt=ON
      -DEpetraExt_BUILD_BTF=ON
      -DEpetraExt_BUILD_EXPERIMENTAL=ON
      -DEpetraExt_BUILD_GRAPH_REORDERINGS=ON
      -DTrilinos_ENABLE_TrilinosCouplings=ON
      -DTrilinos_ENABLE_Ifpack=ON
      -DTrilinos_ENABLE_AztecOO=ON
      -DTrilinos_ENABLE_Belos=ON
      -DTrilinos_ENABLE_Teuchos=ON
      -DTrilinos_ENABLE_Amesos=ON
      -DAmesos_ENABLE_KLU=ON
      -DTrilinos_ENABLE_Sacado=ON
      -DTrilinos_ENABLE_Stokhos=ON
      -DTrilinos_ENABLE_ROL=ON
      -DTrilinos_ENABLE_Amesos2=ON
      -DAmesos2_ENABLE_KLU2=ON
      -DAmesos2_ENABLE_Basker=ON
      -DTrilinos_ENABLE_COMPLEX_DOUBLE=ON
      -DTrilinos_ENABLE_ALL_OPTIONAL_PACKAGES=OFF
      -DTPL_ENABLE_AMD=ON
      -DTPL_ENABLE_BLAS=ON
      -DTPL_ENABLE_LAPACK=ON
      -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE
    ]

    # Serial build. A parallel Xyce needs a second, MPI-enabled Trilinos
    # installation in a separate prefix.
    args << "-DTPL_ENABLE_MPI=OFF"
    # Static libraries with PIC, so that they can be linked into the shared
    # XyceLib that plugin support requires.
    args << "-DBUILD_SHARED_LIBS=OFF"
    args << "-DTrilinos_ENABLE_TESTS=OFF"
    args << "-DTrilinos_ENABLE_EXAMPLES=OFF"

    args << "-DAMD_INCLUDE_DIRS=#{formula_opt_include("suite-sparse")}/suitesparse"
    args << "-DAMD_LIBRARY_DIRS=#{formula_opt_lib("suite-sparse")}"
    args << "-DCMAKE_Fortran_COMPILER=#{formula_opt_bin("gcc")}/gfortran"
    # On Linux the C and C++ compilers are the system GCC while gfortran comes
    # from the brewed one, and CMake's Fortran/C interface probe compiles its
    # helper libraries with `-flto` there. That mixes LTO bytecode from two GCC
    # major versions in one link, which neither can read, so the probe fails.
    # The mangling itself is detected by a separate check that does succeed, so
    # skip only the verification.
    args << "-DTrilinos_SKIP_FORTRANCINTERFACE_VERIFY_TEST=ON" if OS.linux?
    # Apple Clang rejects implicitly declared functions.
    args << "-DCMAKE_C_FLAGS=-Wno-error=implicit-function-declaration"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Trilinos records the compiler and linker it was configured with in its
    # installed CMake package files, and Kokkos bakes them into
    # `kokkos_launch_compiler`. Under Homebrew those are the shims, which are
    # only usable inside a Homebrew build, so reduce them to bare program names
    # that resolve through PATH -- Xyce reads these files.
    shimmed = (lib.glob("cmake/**/*.cmake") + bin.glob("*")).select do |f|
      f.file? && !f.symlink? && f.binread.include?(Superenv.shims_path.to_s)
    end
    inreplace shimmed, "#{Superenv.shims_path}/", ""

    # Trilinos also records each external package it found as an imported
    # target holding an absolute path. On macOS BLAS, LAPACK and DLlib resolve
    # to link stubs inside the SDK, and that path is specific to the machine
    # that built the bottle, so let the linker find them by name instead.
    stubbed = lib.glob("external_packages/*/*Config.cmake").select do |f|
      f.file? && f.binread.include?(".tbd\"")
    end
    stubbed.each do |f|
      inreplace f do |s|
        s.gsub! "IMPORTED UNKNOWN)", "INTERFACE IMPORTED)"
        s.gsub!(%r{IMPORTED_LOCATION "[^"]*/usr/lib/lib(\w+)\.tbd"},
                'INTERFACE_LINK_LIBRARIES "\1"')
      end
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <Teuchos_Version.hpp>
      #include <iostream>

      int main() {
        std::cout << Teuchos::Teuchos_Version() << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cpp", "-o", "test",
           "-L#{lib}", "-lteuchoscore"
    assert_match "Teuchos", shell_output("./test")
  end
end

__END__
--- a/packages/kokkos-kernels/sparse/src/KokkosSparse_spadd_handle.hpp
+++ b/packages/kokkos-kernels/sparse/src/KokkosSparse_spadd_handle.hpp
@@ -72,10 +72,6 @@
    */
   size_type get_c_nnz() { return this->result_nnz_size; }
 
-  void set_sort_option(int option) { this->sort_option = option; }
-
-  int get_sort_option() { return this->sort_option; }
-
   /**
    * \brief Default constructor.
    */
