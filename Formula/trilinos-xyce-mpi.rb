class TrilinosXyceMpi < Formula
  desc "Trilinos solver libraries, built with MPI for parallel Xyce"
  homepage "https://trilinos.github.io/"
  url "https://github.com/trilinos/Trilinos/archive/refs/tags/trilinos-release-14-4-0.tar.gz"
  version "14.4.0"
  sha256 "8e7d881cf6677aa062f7bfea8baa1e52e8956aa575d6a4f90f2b6f032632d4c6"
  # Trilinos is a collection of packages, each licensed individually.
  license :cannot_represent

  livecheck do
    url :stable
    strategy :github_latest
    regex(/trilinos[._-]release[._-]v?(\d+)[._-](\d+)[._-](\d+)/i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/trilinos-xyce-mpi-14.4.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38ddf7b5fde6a8f498582c224696a4b51d26da4f9745e9858bf7434704646128"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1b800f546b4807836b7cbfdd53e1a52b2161eef58370cdfa9c2ab00d986bcb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf6750160e7ec656a08503c274bf5425f69d285ee3483f4428f358ef184903ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c62a26b03487e814c38d429129385d0f1791bc61a4da1fee7ee316f59daef316"
  end

  keg_only "it is a second Trilinos, built with MPI for xyce-mpi"

  depends_on "cmake" => :build
  # Trilinos has Fortran sources; Xyce's build notes report AztecOO failures
  # when Apple Clang is used without a Fortran compiler. libgfortran is needed
  # at link time by anything using these libraries, so this is not a build-only
  # dependency.
  depends_on "gcc"
  depends_on "open-mpi"
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

    # Xyce's `trilinos-MPI-base.cmake` is the serial cache file above plus
    # these three settings; Zoltan and Isorropia partition the circuit matrix
    # across ranks.  TriBITS drives MPI through the compiler wrappers, which
    # honour CC/CXX and so still reach Homebrew's shims.
    args << "-DTPL_ENABLE_MPI=ON"
    args << "-DTrilinos_ENABLE_Zoltan=ON"
    args << "-DTrilinos_ENABLE_Isorropia=ON"
    args << "-DMPI_BASE_DIR=#{formula_opt_prefix("open-mpi")}"
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
    # `inreplace` treats an empty file list as an error, and the MPI builds
    # record the compiler wrappers rather than a shim, so nothing matches.
    inreplace shimmed, "#{Superenv.shims_path}/", "" if shimmed.present?

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
    system ENV.cxx, "-std=c++17", "-I#{include}",
           "-I#{formula_opt_include("open-mpi")}", "test.cpp", "-o", "test",
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
