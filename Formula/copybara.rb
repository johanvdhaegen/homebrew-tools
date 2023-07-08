class Copybara < Formula
  desc "Tool for transforming and moving code between repositories"
  homepage "https://github.com/google/copybara"
  url "https://github.com/google/copybara.git",
      revision: "6f8440769a822d2bf075cdea1ed1351abb72a05c"
  version "2023-07-06"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/copybara-2023-07-06"
    sha256 cellar: :any_skip_relocation, ventura:  "93542e2a1f1672efff00c2018517e05287a3b1989d110507aa146c626e15d75b"
    sha256 cellar: :any_skip_relocation, monterey: "b1f2f4233be1d2d7baffcdaa099c85dcc5f0bc3286c9dfcd65fe44451f0cf759"
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
