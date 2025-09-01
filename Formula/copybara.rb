class Copybara < Formula
  desc "Tool for transforming and moving code between repositories"
  homepage "https://github.com/google/copybara"
  url "https://github.com/google/copybara.git",
      revision: "494fa7ea08aa58c0ae322887a923e57b1cc2ee83"
  version "2025-05-29"
  license "Apache-2.0"
  revision 2

  head "https://github.com/google/copybara.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/copybara-2025-05-29_1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "195d44e13590d5df4c55cd94fd5f1527177ad6c0362e7ba3d3d3a2c1dd2e7ceb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67caba61270f6058cf1db823208b1d2eaf846bac553a22479d8284d94e5d9ed3"
    sha256 cellar: :any_skip_relocation, ventura:       "3f4d5e963692338a0298e53461f5842b22b552869cb2becf1771c3c292791d7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f034add2ea47a0a4a9785969133086ddc5d83ae9cabef2b189b92d08c48d6868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97217bc2a9ea50d3fa2bd519dbf8b2423ac241a212a6f0859891a87c9910d1c9"
  end

  depends_on "bazel" => :build
  depends_on "openjdk@21"

  def install
    # Force Bazel to use brew OpenJDK
    java_version = "21"
    java_home_env = Language::Java.java_home_env(java_version)
    ENV.merge! java_home_env.transform_keys(&:to_s)
    extra_bazel_args = ["--tool_java_runtime_version=local_jdk"]
    # Bazel clears environment variables which breaks superenv shims
    ENV.remove "PATH", Superenv.shims_path

    # Fix linking on Linux
    if OS.linux? && build.bottle? && ENV["HOMEBREW_DYNAMIC_LINKER"]
      # set dynamic linker similar to cc shim so that bottle works on older Linux
      extra_bazel_args << "--linkopt=-Wl,--dynamic-linker=#{ENV["HOMEBREW_DYNAMIC_LINKER"]}"
    end

    # Construct Bazel arguments
    ENV["EXTRA_BAZEL_ARGS"] = extra_bazel_args.join(" ")
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"

    # Build Copybara
    system "bazel", "build", "--repo_contents_cache=",
           "//java/com/google/copybara:copybara_deploy.jar"
    libexec.install "bazel-bin/java/com/google/copybara/copybara_deploy.jar"
    bin.write_jar_script libexec/"copybara_deploy.jar", "copybara",
                         java_version: java_version
  end

  test do
    assert_match(/Version: Unknown version/,
                 pipe_output(
                   "#{bin}/copybara --work-dir=#{testpath} version 2>&1",
                 ))
  end
end
