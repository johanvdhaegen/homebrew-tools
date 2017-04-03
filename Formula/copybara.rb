class Copybara < Formula
  desc "A tool for transforming and moving code between repositories."
  homepage "https://github.com/google/copybara"
  url "https://github.com/google/copybara.git",
      :revision => "d68d7f614a611adc77cbd7e50d0031fa3656dc0f"
  version "2017-03-28"

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
