class Sunbeam < Formula
  desc "CLI for the Sunbeam Compute Platform"
  homepage "https://github.com/sunbeamdotpt/cli"
  license "MIT"

  # Prebuilt release tarballs (binary + man pages + shell completions) from
  # the GitHub release — no build toolchain required. The platform's public
  # SSO client ID is baked in by the release workflow.
  on_macos do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.2.1/sunbeam_3.2.1_aarch64-apple-darwin.tar.gz"
      sha256 "5565d07547fbce934e1d9297ef8b5b2a3d80c27cb140db0336d519c643185989"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.2.1/sunbeam_3.2.1_x86_64-apple-darwin.tar.gz"
      sha256 "f98ab267ddd7f9f3ed32cd315ddac77150c8663d927ab8e90fb8f7dc84f7f3f9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.2.1/sunbeam_3.2.1_aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e9238b9bd10582ce53064773f52c740a6d65b4c18c95252db18a8abf1a1502a2"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.2.1/sunbeam_3.2.1_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5aafecfd273b462c2979f75c18a4593250589727542590ab2aad1b97504e11c6"
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
