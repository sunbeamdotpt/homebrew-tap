class Sunbeam < Formula
  desc "CLI for the Sunbeam Compute Platform"
  homepage "https://github.com/sunbeamdotpt/cli"
  url "https://github.com/sunbeamdotpt/cli/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "a0d51cd9282533afae10c4a91027e48d5ac894d28ab8332fceb951d15aee1575"
  license "MIT"
  head "https://github.com/sunbeamdotpt/cli.git", branch: "mainline"

  # buf: the `sdk` dependency generates its ConnectRPC stubs at build time
  # (buf export buf.build/sunbeamdotpt/kanban) — network access required.
  # protobuf: protoc is required by transitive build scripts (wfe protos).
  depends_on "buf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    # The CLI's public SSO client ID is platform-provisioned and deliberately
    # never committed to any repo. Builds bake it in at compile time
    # (option_env!) when SUNBEAM_SSO_CLIENT_ID is set; otherwise users must
    # provide it at runtime (see caveats). Homebrew's wrapper only forwards
    # HOMEBREW_* variables into the build, so accept that channel too.
    sso_client_id = ENV["SUNBEAM_SSO_CLIENT_ID"].to_s
    sso_client_id = ENV["HOMEBREW_SSO_CLIENT_ID"].to_s if sso_client_id.empty?
    if sso_client_id.empty?
      opoo "SUNBEAM_SSO_CLIENT_ID not set; `sunbeam auth login` will require it at runtime"
    else
      ENV["SUNBEAM_SSO_CLIENT_ID"] = sso_client_id
    end

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sunbeam", "completions")

    # Man pages: rendered from the clap tree by the hidden `__man` command.
    (buildpath/"man").mkpath
    system bin/"sunbeam", "__man", buildpath/"man"
    man1.install Dir["man/*.1"]
  end

  def caveats
    <<~EOS
      `sunbeam auth login` needs the platform's public SSO client ID.
      If it was not baked into this build, set it before logging in:
        export SUNBEAM_SSO_CLIENT_ID=<provisioned-client-id>

      To bake it into a source build instead:
        HOMEBREW_SSO_CLIENT_ID=<provisioned-client-id> \\
          brew install --build-from-source sunbeamdotpt/tap/sunbeam
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sunbeam --version")
    assert_path_exists man1/"sunbeam.1"
    assert_path_exists man1/"sunbeam-service-apply.1"
    assert_path_exists man1/"sunbeam-kanban-card-create.1"
  end
end
