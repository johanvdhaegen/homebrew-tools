class Copybara < Formula
  desc "Tool for transforming and moving code between repositories"
  homepage "https://github.com/google/copybara"
  url "https://github.com/google/copybara.git",
      revision: "2f8f7e5293689c18fa00b91b4d2390f3a4392308"
  version "2025-03-21"
  license "Apache-2.0"

  head "https://github.com/google/copybara.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/copybara-2025-03-21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd81c8c6af2104cc56b1bf4d2beb5414c31b55cd22f24c1c1815ce98599d095f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "365f9fdfa57e80ac9a2bc7a27f5ac20aae5ed45edb507fe101dd3f139d558f3d"
    sha256 cellar: :any_skip_relocation, ventura:       "afb23836e94e0bbf11143ddbedfd79c8168244255c250a5d24036f5bc12cceea"
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
