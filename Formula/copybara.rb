class Copybara < Formula
  desc "Tool for transforming and moving code between repositories"
  homepage "https://github.com/google/copybara"
  url "https://github.com/google/copybara.git",
      :revision => "75d4916562a4b3743b1fb0ffdc847f73684595bd"
  version "2018-11-16"

  depends_on "bazel" => :build
  depends_on :java => "1.9+"

  def install
    system "bazel", "build", "//java/com/google/copybara:copybara_deploy.jar"
    libexec.install "bazel-bin/java/com/google/copybara/copybara_deploy.jar"
    (bin/"copybara").write <<~EOS
      #!/bin/bash
      CLASSPATH="#{libexec}/copybara_deploy.jar:." exec java -jar #{libexec}/copybara_deploy.jar "$@"
    EOS
  end

  test do
    assert_match(/Unknown version$/, pipe_output("#{bin}/copybara version 2>&1"))
  end
end
