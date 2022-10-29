class Nagelfar < Formula
  desc "Static syntax checker for Tcl"
  homepage "https://nagelfar.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nagelfar/Rel_132/nagelfar132.tar.gz"
  version "1.3.2"
  sha256 "ff704e551efa2f39ba851ce9f02cc8ab66c7fae39fb41d5aa2abd6fe05c76b72"
  license "GPL-2.0-only"

  depends_on "tcl-tk"

  def install
    mkdir lib
    cp_r buildpath, lib/"nagelfar", preserve: true
    mkdir bin
    ln_s lib/"nagelfar/nagelfar.tcl", bin/"nagelfar"
  end

  test do
    cp_r Dir[lib/"nagelfar/misctests/*"], testpath
    assert_match "Unknown variable \"cep\"",
                 shell_output("#{bin}/nagelfar test.tcl")
  end
end
