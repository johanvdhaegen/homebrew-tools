class Dpic < Formula
  livecheck do
    url "https://ece.uwaterloo.ca/~aplevich/dpic/"
    regex(%r{href=.*dpic[._-]v?(\d+(?:\.\d+)+)\.tar\.gz}i)
  end
end
