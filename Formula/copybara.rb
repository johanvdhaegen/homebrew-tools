class Copybara < Formula
  desc "Tool for transforming and moving code between repositories"
  homepage "https://github.com/google/copybara"
  url "https://github.com/google/copybara.git",
      revision: "b252194ea7213a8abf25270fb8c0756ee4150332"
  version "20251205"
  license "Apache-2.0"

  head "https://github.com/google/copybara.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/copybara-20251205"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0465d908e2f4c5554e5c65a5982ae6b2ae11d91c630cc8466acda93db4f7a270"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "965e8dfe8216f0a6b387da896312f4587bca585970c23bfdc431f0391f41c0a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6c328374192016344e78b8b1ff36cac9ecd6ed35e07f8b007413339f9b1e6ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8cace5faaa081f681d848f210b3f14087872827117008223b00223b00446e39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d685ccc41c403d7e2ce2596832955d4b64a646b1a7c8a42dab1051601ceb4b4"
  end

  depends_on "bazel" => :build
  depends_on "openjdk@21"
  depends_on "zstd"

  def install
    # Force Bazel to use brew OpenJDK
    java_version = "21"
    java_home_env = Language::Java.java_home_env(java_version)
    ENV.merge! java_home_env.transform_keys(&:to_s)
    extra_bazel_args = ["--tool_java_runtime_version=local_jdk"]
    # Bazel clears environment variables which breaks superenv shims
    ENV.remove "PATH", Superenv.shims_path

    # Add zstd include and lib directories
    extra_bazel_args << "--copt=\"-isystem#{Formula["zstd"].opt_include}\""
    extra_bazel_args << "--linkopt=\"-L#{Formula["zstd"].opt_lib}\""
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
