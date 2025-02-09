class Uhubctl < Formula
  desc "USB hub per-port power control"
  homepage "https://github.com/mvp/uhubctl"
  url "https://github.com/mvp/uhubctl/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "56ca15ddf96d39ab0bf8ee12d3daca13cea45af01bcd5a9732ffcc01664fdfa2"
  license "GPL-2.0-only"
  head "https://github.com/mvp/uhubctl.git", branch: "master"

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "make", "prefix=#{prefix}", "CC=#{ENV.cc}"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/uhubctl -v")
  end
end
