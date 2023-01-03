class Inkscape < Formula
  include Language::Python::Virtualenv

  desc "Professional vector graphics editor"
  homepage "https://inkscape.org/"
  url "https://gitlab.com/inkscape/inkscape.git",
      tag:      "INKSCAPE_1_2_2",
      revision: "b0a8486541ac36327488da641d58a86bee2f07ad"
  head "https://gitlab.com/inkscape/inkscape.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/inkscape-1.2.2"
    sha256 monterey: "4eac2da1010bb005e77e8b7b4c7e8c77ed7fe5a2d63e313a367d6bed5dcf67b8"
  end

  depends_on "automake" => :build
  depends_on "boost-build" => :build
  depends_on "cmake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "aspell"
  depends_on "bdw-gc"
  depends_on "boost"
  depends_on "cairomm"
  depends_on "double-conversion"
  depends_on "fontconfig"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glibmm"
  depends_on "graphicsmagick"
  depends_on "gsl"
  depends_on "gtk+3"
  depends_on "gtk-mac-integration"
  depends_on "gtkmm3"
  depends_on "gtkspell3"
  depends_on "harfbuzz"
  depends_on "hicolor-icon-theme"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libsigc++@2"
  depends_on "libsoup@2"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "little-cms"
  depends_on :macos
  depends_on "numpy"
  depends_on "pango"
  depends_on "poppler"
  depends_on "potrace"
  depends_on "pygobject3"
  depends_on "python@3.10"
  depends_on "readline"
  depends_on "jemalloc" => :optional
  depends_on "libcdr" => :optional
  depends_on "libomp" => :optional
  depends_on "libvisio" => :optional
  depends_on "libwpg" => :optional

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/06/5a/e11cad7b79f2cf3dd2ff8f81fa8ca667e7591d3d8451768589996b65dec1/lxml-4.9.2.tar.gz"
    sha256 "2455cfaeb7ac70338b3257f41e21f0724f4b5b0c0e7702da67ee6c3640835b67"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/e8/b0/cd2b968000577ec5ce6c741a54d846dfa402372369b8b6861720aa9ecea7/beautifulsoup4-4.11.1.tar.gz"
    sha256 "ad9aa55b65ef2808eb405f46cf74df7fcb7044d5cbc26487f96eb2ef2e436693"
  end

  resource "cachecontrol" do
    url "https://files.pythonhosted.org/packages/46/9b/34215200b0c2b2229d7be45c1436ca0e8cad3b10de42cfea96983bd70248/CacheControl-0.12.11.tar.gz"
    sha256 "a5b9fcc986b184db101aa280b42ecdcdfc524892596f606858e0b7a8b4d9e144"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/d1/91/d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081c/cssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
  end

  resource "gtkme" do
    url "https://files.pythonhosted.org/packages/cc/75/762ace4771cc23a350e6fe26edc85a062e935b359eaeb63bc6c1192dbb28/gtkme-1.5.3.tar.gz"
    sha256 "3485209db7dc1e36cf7ec1f7085d81cb0a3ca30addb22d70a83a0cc4e6bed94e"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "charset_normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/22/44/0829b19ac243211d1d2bd759999aa92196c546518b0be91de9cacc98122a/msgpack-1.0.4.tar.gz"
    sha256 "f5d869c18f030202eb412f08b28d2afeea553d6613aee89e200d7aca7ef01f5f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "scour" do
    url "https://files.pythonhosted.org/packages/75/19/f519ef8aa2f379935a44212c5744e2b3a46173bf04e0110fb7f4af4028c9/scour-0.38.2.tar.gz"
    sha256 "6881ec26660c130c5ecd996ac6f6b03939dd574198f50773f2508b81a68e0daf"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/f3/03/bac179d539362319b4779a00764e95f7542f4920084163db6b0fd4742d38/soupsieve-2.3.2.post1.tar.gz"
    sha256 "fc53893b3da2c33de295667a0e19f078c14bf86544af307354de5fcf12a3f30d"
  end

  resource "inkscape-extensions-manager" do
    url "https://files.pythonhosted.org/packages/ed/d1/c6048bc503bfd0e2df7881493eeeeb5eab340db4419a99923d8cb6d7866e/inkscape-extensions-manager-0.9.9.tar.gz"
    sha256 "1f42e66d8c245b4e6a6706e03ab541c7a6b72509dc37751a045da46dd1370fc8"
  end

  def install
    ENV.cxx11
    ENV.append "LDFLAGS", "-liconv"

    libomp = Formula["libomp"]
    args = []
    args << "-DWITH_X11=OFF"
    if build.with?("openmp")
      args << "-DOpenMP_C_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_CXX_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
      args << "-DOpenMP_CXX_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.dylib"
    else
      args << "-DWITH_OPENMP=OFF"
    end
    args << "-DWITH_DBUS=OFF"
    args << ("-DWITH_JEMALLOC=" + (build.with?("jemalloc") ? "ON" : "OFF"))
    args << "-DWITH_LIBWPG=OFF" if build.without? "libwpg"
    args << "-DWITH_LIBVISIO=OFF" if build.without? "libvisio"
    args << "-DWITH_LIBCDR=OFF" if build.without? "libcdr"

    # install under libexec
    cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] }
    cmake_args << "-DCMAKE_INSTALL_PREFIX=#{libexec}"
    mkdir buildpath/"build" do
      system "cmake", "..", *cmake_args, *args
      system "make"
      system "make", "install"
    end

    # create wrapper scripts for inkscape binaries
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PATH: "#{libexec}/bin:$PATH")

    # set up python virtualenv for inkscape extensions
    pyver = Language::Python.major_minor_version("python3")
    ENV.prepend_create_path "PYTHONPATH",
                            libexec/"lib/python#{pyver}/site-packages"
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    # move extension manager script to site packages
    mv libexec/"manage_extensions.inx",
       libexec/"lib/python#{pyver}/site-packages"
    mv libexec/"manage_extensions.py",
       libexec/"lib/python#{pyver}/site-packages"
  end

  test do
    system "#{bin}/inkscape", "--debug-info"
  end
end
