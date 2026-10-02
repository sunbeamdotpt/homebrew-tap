class Sunbeam < Formula
  desc "CLI for the Sunbeam Compute Platform"
  homepage "https://github.com/sunbeamdotpt/cli"
  license "MIT"

  # Prebuilt release tarballs (binary + man pages + shell completions) from
  # the GitHub release — no build toolchain required. The platform's public
  # SSO client ID is baked in by the release workflow.
  on_macos do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.5.2/sunbeam_3.5.2_aarch64-apple-darwin.tar.gz"
      sha256 "e6b6dd742f446a2ea7fda7d2b9222e0b373765992ae48ff5c1de594a9edd1ee5"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.5.2/sunbeam_3.5.2_x86_64-apple-darwin.tar.gz"
      sha256 "a1e6e70bfe55c732b7f0e5532e6918961b544432448f9c9e20e1160c0ff4b831"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.5.2/sunbeam_3.5.2_aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5ca43e3a294b6c1982f35c3173dce788b6ea743cb8bdf057cd8520fb68f3e88b"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.5.2/sunbeam_3.5.2_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d7aca1a413d678dd433deb07922a7d4c3def33d5c37cb82945b219967019c6ac"
    end
  end

  def install
    bin.install "sunbeam"
    man1.install Dir["man/*.1.gz"]
    bash_completion.install "sunbeam.bash" => "sunbeam"
    zsh_completion.install "sunbeam.zsh" => "_sunbeam"
    fish_completion.install "sunbeam.fish"
  end

  def caveats
    <<~EOS
      The platform's public SSO client ID is baked into this release binary.
      To override it (e.g. against a staging gateway):
        export SUNBEAM_SSO_CLIENT_ID=<other-client-id>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sunbeam --version")
    assert_path_exists man1/"sunbeam.1.gz"
    assert_path_exists man1/"sunbeam-service-apply.1.gz"
  end
end
