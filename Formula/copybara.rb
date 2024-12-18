class Copybara < Formula
  desc "Tool for transforming and moving code between repositories"
  homepage "https://github.com/google/copybara"
  url "https://github.com/google/copybara.git",
      revision: "c55abbe6a7b49861c113c6b73f0d28e090f15777"
  version "2024-12-12"
  license "Apache-2.0"

  head "https://github.com/google/copybara.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/copybara-2024-12-12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eb9ef7420adf2729b7c6482908d5b8c3846ddf9b42ed22533414ceebad986bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "146e51c300982b790f1f0131abb9654563621b91b77768f4978b427b8560d1c7"
    sha256 cellar: :any_skip_relocation, ventura:       "f8b16cdc2d324968db14d2b5def56f2a8ba14c3ac67891a8bf03f4732497456b"
  end

  depends_on "bazel" => :build
  depends_on "openjdk@21"

  def install
    # Force Copybara to use openjdk@21
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    ENV["EXTRA_BAZEL_ARGS"] = "--host_javabase=@local_jdk//:jdk"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"

    system "bazel", "build",
           "//java/com/google/copybara:copybara_deploy.jar"
    libexec.install "bazel-bin/java/com/google/copybara/copybara_deploy.jar"
    (bin/"copybara").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{ENV["JAVA_HOME"]}"
      CLASSPATH="#{libexec}/copybara_deploy.jar:." exec java -jar #{libexec}/copybara_deploy.jar "$@"
    EOS
  end

  test do
    assert_match(/Unknown version$/,
                 pipe_output(
                   "#{bin}/copybara --work-dir=#{testpath} version 2>&1",
                 ))
  end
end
