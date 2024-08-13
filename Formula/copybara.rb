class Copybara < Formula
  desc "Tool for transforming and moving code between repositories"
  homepage "https://github.com/google/copybara"
  url "https://github.com/google/copybara.git",
      revision: "ae19a16667b86484f359007c10de35a3b8b40617"
  version "2024-08-12"
  license "Apache-2.0"

  head "https://github.com/google/copybara.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/copybara-2024-08-12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "43c65ada2b8df9a85f0f040e64ace15d0f05e19e1b50cc61beb3cffd4134f33c"
    sha256 cellar: :any_skip_relocation, ventura:      "cd3ce52596a1e7a6987818ba52a42109e855482df448961ce653745fadce2ef2"
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
