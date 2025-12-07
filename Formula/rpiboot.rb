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
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/rpiboot-20250908-162618"
    sha256 arm64_tahoe:   "20b81570ea3897f6528e2949cf6e0f55db1c9d9efe25778a007a5630365ec3aa"
    sha256 arm64_sequoia: "ad6d24cd338daa1e1e180d7009e38ae35419c1cfb64ecbcd077b30446bb4ce99"
    sha256 arm64_sonoma:  "3d9d096043b5aea867865263516d052d684ca22572beb3f27712864489bf04d7"
    sha256 arm64_linux:   "98bdf105a5120a7b636590167cbf17c64b6cfb21311548ba37ed8c9d635fa27c"
    sha256 x86_64_linux:  "fa6f3c1ddd2fe2c44cafa0eabeea58cd80f0feea902b35b6b09c5de967618841"
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
