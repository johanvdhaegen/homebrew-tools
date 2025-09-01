class Copybara < Formula
  desc "Tool for transforming and moving code between repositories"
  homepage "https://github.com/google/copybara"
  url "https://github.com/google/copybara.git",
      revision: "be1636256bb8fbca07d3b5dba6071cad83cd14e8"
  version "20250901"
  license "Apache-2.0"

  head "https://github.com/google/copybara.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/copybara-2025-05-29_2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77f368467016677f4fded29fdcde84d66f4f9944c7509895786b9a1bdc2378f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "109beb64427958a449aaca366eb9b606417e0b5c0c049f5b7cdeae9373105441"
    sha256 cellar: :any_skip_relocation, ventura:       "69306cd9977ab260c434fe278360db92d191a70e29a36158715843686b250425"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bb63d8456abf4c092bbae3bf26180bde420e8f7b78aa318e6f0b56a3e7af50f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a19d76cb1481322b9a21bd76a0babdc978672d043225d6d874a10b58389a2cb0"
  end

  depends_on "bazel" => :build
  depends_on macos: :sonoma # zstd issues on ventura
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
           "--verbose_failures",
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
