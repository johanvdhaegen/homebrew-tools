class Rpiboot < Formula
  desc "Raspberry Pi USB device boot"
  homepage "https://github.com/raspberrypi/usbboot"
  url "https://github.com/raspberrypi/usbboot/archive/refs/tags/20250227-132106.tar.gz"
  version "20250227-132106"
  sha256 "e57c6e8183c3b9e6fa94758840985b595d58ec80079a37d6492250c1ccbcb004"
  head "https://github.com/raspberrypi/usbboot.git",
       branch: "master"

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
