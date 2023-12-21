class Gitiles < Formula
  desc "Simple repository browser for Git repositories, built on JGit"
  homepage "https://gerrit.googlesource.com/gitiles"
  url "https://gerrit.googlesource.com/gitiles",
      using:    :git,
      revision: "f506980b95c1a6e5c4da170ce37dd6f0adb28f2b"
  version "1.3.0.20231217"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/johanvdhaegen/homebrew-tools/releases/download/gitiles-1.2.0.20230125"
    sha256 cellar: :any_skip_relocation, monterey: "50d0a23c54f9ef39b900139d15fe366d8545cb0599f9f8fa512f192b2f5168dd"
  end

  head do
    url "https://gerrit.googlesource.com/gitiles",
        using:  :git,
        branch: "master"
  end

  depends_on "bazel" => :build
  depends_on :macos # TODO: fix bazel build failure on linux
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
    port = "8080" # fixed by gitiles
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
