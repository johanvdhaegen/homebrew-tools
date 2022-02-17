class UnisonOcaml413 < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/v2.51.5.tar.gz"
  sha256 "7e876371992ebf890b60f32df880a98a75fe8c47c06b7b2ae2ad36be48013e83"
  license "GPL-3.0-or-later"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/unison-ocaml-4-13-2.51.5"
    sha256 cellar: :any_skip_relocation, big_sur:      "4a37b21486c482ad6cb91dca34d49317da3f559f68263dca29e71c9b6b4e5f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "21beb4a4bd891be39177e398f58018c55c2edd604de5265167890649f0641d36"
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