class Uhubctl < Formula
  desc "USB hub per-port power control"
  homepage "https://github.com/mvp/uhubctl"
  url "https://github.com/mvp/uhubctl/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "56ca15ddf96d39ab0bf8ee12d3daca13cea45af01bcd5a9732ffcc01664fdfa2"
  license "GPL-2.0-only"
  head "https://github.com/mvp/uhubctl.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/uhubctl-2.6.0"
    sha256 cellar: :any,                 arm64_sequoia: "e824ba1869bcf3e4796b2f2d482dec9fed7c7077c0e04f5ce1d3c00aea617faa"
    sha256 cellar: :any,                 arm64_sonoma:  "5d395f624e9015622993887186921e846ac58c6ce34c67ba66f2a8dff85b4d19"
    sha256 cellar: :any,                 ventura:       "43efd12f4a5985da91def9f701b71bdf3edf21d1d49dd03a116235c81d2e37fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1d0f297e8381edcd80c764b53277d40ca7e5a08e7fa488e0366353dfae75711"
  end

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
