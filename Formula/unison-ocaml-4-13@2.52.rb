class UnisonOcaml413AT252 < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/v2.52.1.tar.gz"
  sha256 "ff7d920e1b4ec0872df764130b82a515f6f21a361f31a67b39c3e3ea12bfda80"
  license "GPL-3.0-or-later"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(2\.52\.[0-5]\d*)$/i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/unison-ocaml-4-13@2.52-2.52.1"
    sha256 cellar: :any_skip_relocation, big_sur:      "8dccb8355b2212c5787d6e14429dd7a283fc3a27afd6ff753d47d99135cb3146"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3b2d89d5bc61cae9521a2b430ef24822e540f9df894d4db4e5b24a0f5ccdb07f"
  end

  keg_only :versioned_formula

  depends_on "ocaml@4.13" => :build
  depends_on "gtk+" => OS.mac? ? :recommended : :optional
  depends_on "lablgtk-ocaml-4-13" => :build if build.with? "gtk+"

  def install
    ENV.deparallelize
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642

    if build.with?("gtk+")
      system "make", "src"
      prefix.install "src/uimac/build/Default/Unison.app"
    end
    system "make", "UISTYLE=text"
    bin.install "src/unison"

    prefix.install_metafiles "src"
  end

  test do
    if build.with?("gtk+")
      assert_match version.to_s, shell_output(
        "#{prefix}/Unison.app/Contents/MacOS/Unison -version",
      )
    end
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end
