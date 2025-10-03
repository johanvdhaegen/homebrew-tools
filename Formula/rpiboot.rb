class Rpiboot < Formula
  desc "Raspberry Pi USB device boot"
  homepage "https://github.com/raspberrypi/usbboot"
  url "https://github.com/raspberrypi/usbboot/archive/refs/tags/20250908-162618.tar.gz"
  version "20250908-162618"
  sha256 "956cd4e09050263e1f5ba126ecdb832b53fd0fdea06d1a85397d577bd8bc6ba0"
  head "https://github.com/raspberrypi/usbboot.git",
       branch: "master"

  livecheck do
    url :stable
    regex(/^([\d-]+)$/i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/rpiboot-20250227-132106"
    sha256 arm64_sequoia: "97c30256199dbe3bb3229cffa4420e0662049957d31d91323615ee037db46193"
    sha256 arm64_sonoma:  "0d478a1e3398f8037552ff69b4713101e6a0fc37cf1e4af299c5bebcce8b0789"
    sha256 ventura:       "3d4ac1b1b93c0779608fe772ddc80300a3d6b3940de6515e61c0b60c38b8054c"
    sha256 arm64_linux:   "2565566d605f6cfa0c0f35aed41b3e9657e53f0b11caf4986c7d03fcd9159034"
    sha256 x86_64_linux:  "4b51e598c4c54ad6883ed44a7df183392c1fd55a14c8fc41aa3651c1b8ed0d5b"
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "make", "CFLAGS=#{ENV.cflags}", "CPPFLAGS=#{ENV.cppflags}",
           "INSTALL_PREFIX=#{prefix}"
    mkdir_p prefix/"bin"
    system "make", "install", "INSTALL_PREFIX=#{prefix}"
  end

  test do
    assert_match("Usage: rpiboot", shell_output("#{bin}/rpiboot -h 2>&1"))
  end
end
