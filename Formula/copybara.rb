class Copybara < Formula
  desc "Tool for transforming and moving code between repositories"
  homepage "https://github.com/google/copybara"
  license "Apache-2.0"

  head do
    url "https://github.com/google/copybara.git"
  end

  depends_on "bazel" => :build
  depends_on "openjdk@11"

  def install
    # Force Bazel to use openjdk@11
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_libexec/"openjdk.jdk/Contents/Home"
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
