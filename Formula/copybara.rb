class Copybara < Formula
  desc "Tool for transforming and moving code between repositories"
  homepage "https://github.com/google/copybara"
  url "https://github.com/google/copybara.git",
      revision: "494fa7ea08aa58c0ae322887a923e57b1cc2ee83"
  version "2025-05-29"
  license "Apache-2.0"

  head "https://github.com/google/copybara.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/copybara-2025-05-29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afc1e25a624c6e72feef9df15e3c79770a42686768e12485766267156670ab56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f85454cf0992a109069831ed7a7f39c1f7695ede7e791f7d872e9800f81edd1"
    sha256 cellar: :any_skip_relocation, ventura:       "62747f884d465c0cfeb630543877d8fb9b44f34d890aa1ef971f2cc783019969"
  end

  depends_on "bazel" => :build
  depends_on "openjdk@21"

  def install
    # Force Bazel to use brew OpenJDK
    java_home_env = Language::Java.java_home_env("21")
    ENV.merge! java_home_env.transform_keys(&:to_s)
    ENV["EXTRA_BAZEL_ARGS"] = "--tool_java_runtime_version=local_jdk"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"

    system "bazel", "build", "--repo_contents_cache=",
           "//java/com/google/copybara:copybara_deploy.jar"
    libexec.install "bazel-bin/java/com/google/copybara/copybara_deploy.jar"
    (bin/"copybara").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{ENV["JAVA_HOME"]}"
      CLASSPATH="#{libexec}/copybara_deploy.jar:." exec java -jar #{libexec}/copybara_deploy.jar "$@"
    EOS
  end

  test do
    assert_match(/Version: Unknown version/,
                 pipe_output(
                   "#{bin}/copybara --work-dir=#{testpath} version 2>&1",
                 ))
  end
end
