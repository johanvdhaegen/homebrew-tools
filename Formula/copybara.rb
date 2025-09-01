class Copybara < Formula
  desc "Tool for transforming and moving code between repositories"
  homepage "https://github.com/google/copybara"
  url "https://github.com/google/copybara.git",
      revision: "be1636256bb8fbca07d3b5dba6071cad83cd14e8"
  version "20250901"
  license "Apache-2.0"

  head "https://github.com/google/copybara.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/copybara-20250901"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91d649558b3990a80509d3e1bde47bdfb01e46b6f1198444b681d1fa103ea671"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "210cbaff0542861154887daf172711f33bede54351fe98928161f9dde79d439b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26a60d7265ef88043462723237fcdc232027a0cef7a2c19bc3afdc7818dadd42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbd084f7acdef8840790c585d5dd999c3b4622c782551d2a80aee2c9d89798b9"
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
