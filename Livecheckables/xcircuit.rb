class Xcircuit
  livecheck do
    url "http://opencircuitdesign.com/xcircuit/archive/"
    regex(%r{href=.*xcircuit[._-]v?(\d+(?:\.\d+)+)\.tgz"})
  end
end
