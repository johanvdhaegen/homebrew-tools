class Dpic < Formula
  livecheck do
    url "https://ece.uwaterloo.ca/~aplevich/dpic/"
    regex(%r{dpic-([0-9.]+)\.tar\.gz})
  end
end
