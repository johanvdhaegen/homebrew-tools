class Gitiles < Formula
  desc "Simple repository browser for Git repositories, built on JGit"
  homepage "https://gerrit.googlesource.com/gitiles"
  url "https://gerrit.googlesource.com/gitiles",
      using:    :git,
      revision: "06b65fdf46c7bae589e11151ca834e8bd8319e86"
  version "1.6.0.20250324"
  license "Apache-2.0"

  head "https://gerrit.googlesource.com/gitiles",
       using:  :git,
       branch: "master"

  depends_on "bazel@7" => :build
  depends_on "openjdk@21"

  def install
    # Force Bazel to use brew OpenJDK
    java_version = "21"
    java_home_env = Language::Java.java_home_env(java_version)
    ENV.merge! java_home_env.transform_keys(&:to_s)
    extra_bazel_args = ["--tool_java_runtime_version=local_jdk"]
    # Bazel clears environment variables which breaks superenv shims
    ENV.remove "PATH", Superenv.shims_path

    # Fix linking on Linux
    if OS.linux? && build.bottle? && ENV["HOMEBREW_DYNAMIC_LINKER"]
      # set dynamic linker similar to cc shim so that bottle works on older Linux
      extra_bazel_args << "--linkopt=-Wl,--dynamic-linker=#{ENV["HOMEBREW_DYNAMIC_LINKER"]}"
    end

    # Construct Bazel arguments
    ENV["EXTRA_BAZEL_ARGS"] = extra_bazel_args.join(" ")
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"

    # Allow Gitiles to use current version of bazel
    (buildpath / ".bazelversion").atomic_write Formula["bazel@7"].version.to_s
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
