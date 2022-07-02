class Copybara < Formula
  desc "Tool for transforming and moving code between repositories"
  homepage "https://github.com/google/copybara"
  url "https://github.com/google/copybara.git",
      revision: "eddf9deddabecf3d77cb940f76793bb6bedf777b"
  version "2022-06-29"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/copybara-2022-06-29"
    sha256 cellar: :any_skip_relocation, big_sur:      "b1dd95711f2f3eaa60811a677eb81a9531b266407c86aafe644c6636b973e4ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "60a0bb37621163f48f8f8ca1d7f5ccd30d02603dc983b8a902e69e23dff9b17b"
  end

  head do
    url "https://github.com/google/copybara.git", branch: "master"
  end

  depends_on "bazel" => :build
  depends_on "openjdk@11"

  def install
    # Force Copybara to use openjdk@11
    ENV["JAVA_HOME"] = Language::Java.java_home("11")
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
