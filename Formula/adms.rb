class Adms < Formula
  desc "Automatic device model synthesizer for Verilog-AMS compact models"
  homepage "https://github.com/Qucs/ADMS"
  url "https://github.com/Qucs/ADMS/releases/download/release-2.3.7/adms-2.3.7.tar.gz"
  sha256 "3a78e1283ecdc3f356410474b3ff44c4dcc82cb89772087fd3bbde8a1038ce08"
  license "GPL-3.0-or-later"

  # No `head` spec: the git tree ships neither `configure` nor the generated
  # parser sources, so a HEAD build really would need Perl's XML::LibXML.

  livecheck do
    url :stable
    strategy :github_latest
    regex(/release[._-]v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/adms-2.3.7"
    sha256 cellar: :any, arm64_tahoe:   "8027e75c7d982194369d61f1f75dbb9d655785f96560d09d7b1cce7ff0bd4c84"
    sha256 cellar: :any, arm64_sequoia: "823f8d023fd402fa18044bf0039c2f50f17ec3d1c19280038219ecd4776e1256"
    sha256 cellar: :any, arm64_linux:   "a103b6833eb90ebbad6e01dc866594a4ecbcdab262d930ead424ee32216ee179"
    sha256 cellar: :any, x86_64_linux:  "7499fd775e9a7a6345902bdcc8c376ef89abc0e3c2b874a9753098d7312460e5"
  end

  # Both are configure-time gates only -- the shipped parsers are pre-generated
  # and neither program is invoked during the build.  Bison is required to be
  # 2.5 or newer, and macOS provides 2.3.
  depends_on "bison" => :build
  depends_on "flex" => :build
  uses_from_macos "perl" => :build

  def install
    # `mkelements.pl` and friends regenerate the Verilog-A and admst parsers
    # from `adms.xml`, and need Perl's XML::LibXML to do it.  The release
    # tarball ships those parsers pre-generated, so the module is never used,
    # but configure aborts on it regardless and offers no way to opt out.
    inreplace "configure", /as_fn_error \$\? "Perl package XML::LibXML.*$/, ":"

    system "./configure", *std_configure_args
    system "make", "install"
    lib.glob("*.la").map(&:unlink)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/admsXml --version")

    (testpath/"resistor.va").write <<~EOS
      `include "disciplines.vams"
      module res(p,n);
        inout p,n;
        electrical p,n;
        parameter real r = 1000 from (0:inf);
        analog I(p,n) <+ V(p,n)/r;
      endmodule
    EOS
    system bin/"admsXml", "-I", include/"adms", testpath/"resistor.va"
  end
end
