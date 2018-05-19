class Copybara < Formula
  desc "Tool for transforming and moving code between repositories"
  homepage "https://github.com/google/copybara"
  url "https://github.com/google/copybara.git",
      :revision => "d990b5a8c1dbfe7499b371e64551b12a82c79c94"
  version "2018-05-18"

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
    assert_match(/Unknown version$/, pipe_output("#{bin}/copybara --version 2>&1"))
  end
end
