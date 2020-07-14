class Magic
  livecheck do
    url "http://opencircuitdesign.com/magic/archive/"
    regex(%r{href=.*magic[._-]v?(\d+(?:\.\d+)+)\.tgz"})
  end
end
