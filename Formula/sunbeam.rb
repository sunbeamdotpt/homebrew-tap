class Sunbeam < Formula
  desc "CLI for the Sunbeam Compute Platform"
  homepage "https://github.com/sunbeamdotpt/cli"
  license "MIT"

  # Prebuilt release tarballs (binary + man pages + shell completions) from
  # the GitHub release — no build toolchain required. The platform's public
  # SSO client ID is baked in by the release workflow.
  on_macos do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.4.1/sunbeam_3.4.1_aarch64-apple-darwin.tar.gz"
      sha256 "4220e66d03a81a1bc0292857176ed8f0bb834a522fe3d7717aad48d65fcc09f4"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.4.1/sunbeam_3.4.1_x86_64-apple-darwin.tar.gz"
      sha256 "2d740b9f6dbdba317b87869b23dab7bfb30111a32f6b9a37f4f1b37bd04d6b50"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.4.1/sunbeam_3.4.1_aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a1c5d673b5595991811d132c08bd1f98bbc414144058216937a592f967f590e9"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.4.1/sunbeam_3.4.1_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a87dad4fef781c48ab2375e52b7bfc37b3489de8553a7ff833919771e6861d5e"
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
