class Copybara < Formula
  desc "A tool for transforming and moving code between repositories"
  homepage "https://github.com/google/copybara"
  url "https://github.com/google/copybara.git",
      :revision => "dd31c3389be2455db2d6614e0c56aada5b8e6109"
  version "2017-09-01"

  depends_on "bazel" => :build
  depends_on :java => "1.8+"

  def install
    system "bazel", "build", "//java/com/google/copybara:copybara_deploy.jar"
    libexec.install "bazel-bin/java/com/google/copybara/copybara_deploy.jar"
    (bin/"copybara").write <<-EOS.undent
      #!/bin/bash
      CLASSPATH="#{libexec}/copybara_deploy.jar:." exec java -jar #{libexec}/copybara_deploy.jar "$@"
    EOS
  end
end
