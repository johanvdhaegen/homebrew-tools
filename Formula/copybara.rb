class Copybara < Formula
  desc "Tool for transforming and moving code between repositories"
  homepage "https://github.com/google/copybara"
  url "https://github.com/google/copybara.git",
      revision: "56cb3e3d0ef6691ff659546e71b2a38a0cf29412"
  version "2022-05-02"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/copybara-2022-05-02"
    sha256 cellar: :any_skip_relocation, big_sur:      "147d2cc61cc9017dcc2a19554224b1b4decf86364403c2a40582fc3c163f84e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "432117654beb7c83adc194b2aa000db3664a966898ddeadf810417651b148d20"
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
