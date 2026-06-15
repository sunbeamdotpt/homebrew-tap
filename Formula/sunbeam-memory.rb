class SunbeamMemory < Formula
  desc "Personal semantic memory server for AI assistants"
  homepage "https://github.com/sunbeamdotpt/memory"
  url "https://github.com/sunbeamdotpt/memory/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "b877ddca78e95590db4715651b9ab6d1e84f19e85527b56aeaae4544d2ff257e"
  license "MIT"
  head "https://github.com/sunbeamdotpt/memory.git", branch: "mainline"

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Wrapper script that sources an optional env file so users can configure
    # the background HTTP service without editing the generated launchd plist.
    (bin/"sunbeam-memory-http").write <<~EOS
      #!/bin/sh
      [ -r #{var}/sunbeam-memory/env ] && . #{var}/sunbeam-memory/env
      exec #{opt_bin}/sunbeam-memory http --port 3456 "$@"
    EOS
    (bin/"sunbeam-memory-http").chmod 0755
  end

  def post_install
    (var/"sunbeam-memory").mkpath
    (var/"sunbeam-memory/env").write <<~EOS unless (var/"sunbeam-memory/env").exist?
      # Sunbeam Memory HTTP service environment variables.
      # This file is sourced by the brew services wrapper before starting the server.
      #
      # Uncomment and set the values you need, then run:
      #   brew services restart sunbeam-memory

      # export MCP_MEMORY_BASE_DIR="#{var}/sunbeam-memory"
      # export MCP_AUTH_TOKEN="your-secret-token"
      # export MCP_OIDC_ISSUER="https://auth.example.com"
      # export MCP_OIDC_AUDIENCE="sunbeam-memory"
      # export MCP_SESSION_TTL_HOURS="24"
    EOS
  end

  service do
    run [opt_bin/"sunbeam-memory-http"]
    keep_alive true
    log_path var/"log/sunbeam-memory.log"
    error_log_path var/"log/sunbeam-memory.log"
    working_dir var/"sunbeam-memory"
  end

  def caveats
    <<~EOS
      The background HTTP service is managed by brew services:

          brew services start sunbeam-memory

      It listens on port 3456 by default.

      To configure environment variables (auth, data directory, session TTL, etc.),
      edit the env file:

          #{var}/sunbeam-memory/env

      Example:

          export MCP_AUTH_TOKEN="your-secret-token"
          export MCP_MEMORY_BASE_DIR="#{var}/sunbeam-memory"

      Then restart the service:

          brew services restart sunbeam-memory

      View logs:

          tail -f #{var}/log/sunbeam-memory.log
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sunbeam-memory --version")
  end
end
