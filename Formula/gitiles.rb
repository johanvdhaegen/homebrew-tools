class Gitiles < Formula
  desc "Simple repository browser for Git repositories, built on JGit"
  homepage "https://gerrit.googlesource.com/gitiles"
  url "https://gerrit.googlesource.com/gitiles",
      using:    :git,
      revision: "13d82a7e004af9b79f36fa561fc1fc1845fd2a27"
  version "1.0.0.20220908"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/gitiles-1.0.0.20220908"
    sha256 cellar: :any_skip_relocation, big_sur:      "985e7de477190ef2b9ad0c1c6ef51dc587b28913c3d42a4ed7a28930146373a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "82d4157c91836aa7c7fc23c5cee34715b105ca36ffae58576579db96b8a62fd3"
  end

  head do
    url "https://gerrit.googlesource.com/gitiles",
        using:  :git,
        branch: "master"
  end

  depends_on "bazel" => :build
  depends_on "openjdk@11"

  def install
    # Force Gitiles to use openjdk@11
    ENV["JAVA_HOME"] = Language::Java.java_home("11")
    ENV["EXTRA_BAZEL_ARGS"] = "--host_javabase=@local_jdk//:jdk"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"

    # Allow Gitiles to use current version of bazel
    (buildpath / ".bazelversion").atomic_write Formula["bazel"].version
    # Remove bazel cache options
    inreplace Dir["**/.bazelrc"] do |f|
      f.gsub! "build --repository_cache=~/.gerritcodereview/bazel-cache/repository", ""
      f.gsub! "build --disk_cache=~/.gerritcodereview/bazel-cache/cas", ""
    end

    bazel_args =%W[
      --jobs=#{ENV.make_jobs}
      --compilation_mode=opt
      --copt=-march=native
    ]
    system "bazel", "build", *bazel_args,
           "java/com/google/gitiles/dev/dev_deploy.jar"

    lib.install "resources"
    libexec.install "bazel-bin/java/com/google/gitiles/dev/dev_deploy.jar"

    (bin/"gitiles").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{ENV["JAVA_HOME"]}"
      CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/gitiles"
      PROPERTIES=()
      PROPERTIES+=("-Dcom.google.gitiles.configPath=${CONFIG_DIR}/gitiles.conf")
      PROPERTIES+=("-Dcom.google.gitiles.sourcePath=#{lib}")
      exec "${JAVA_HOME}/bin/java" "${PROPERTIES[@]}" -jar "#{libexec}/dev_deploy.jar"
    EOS
  end

  test do
    port = "8080"  # fixed by gitiles
    pid = fork do
      exec "#{bin}/gitiles"
    end

    sleep 2

    begin
      assert_match(%r{<title>.* Git repositories - Gitiles .*</title>},
                   shell_output("curl -s http://localhost:#{port}"))
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
