class Copybara < Formula
  desc "Tool for transforming and moving code between repositories"
  homepage "https://github.com/google/copybara"
  url "https://github.com/google/copybara.git",
      revision: "0a2600c9a6a3da100e84668f5ca7c27f24e9f152"
  version "2024-09-25"
  license "Apache-2.0"

  head "https://github.com/google/copybara.git", branch: "master"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/copybara-2024-09-25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "b4687fb275ddc924346d922b081ef9bd5bb5db6df1a5339005649f444e48db88"
    sha256 cellar: :any_skip_relocation, ventura:      "a67d138ca6a5f251044346848742448d982e9e5be7c1849b242c9a76d2a876a9"
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
