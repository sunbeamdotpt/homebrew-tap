class Sunbeam < Formula
  desc "CLI for the Sunbeam Compute Platform"
  homepage "https://github.com/sunbeamdotpt/cli"
  license "MIT"

  # Prebuilt release tarballs (binary + man pages + shell completions) from
  # the GitHub release — no build toolchain required. The platform's public
  # SSO client ID is baked in by the release workflow.
  on_macos do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.1.2/sunbeam_3.1.2_aarch64-apple-darwin.tar.gz"
      sha256 "3bc8b8bf51f26634c31c54dc741a6454a11d397c7c0e05b4582dc8d0e48d45c5"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.1.2/sunbeam_3.1.2_x86_64-apple-darwin.tar.gz"
      sha256 "9b38ae665539f33508e1e8ca2121fc54fb217949b007313947d0215a2b2dd922"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.1.2/sunbeam_3.1.2_aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6bb89c3d9ced6a794d96b80fd7f0e2139e5c5a4b1a8498c30e99fb4e8b464119"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.1.2/sunbeam_3.1.2_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6e43e38768a9c09be23e986ad96495ccdd124beb660a3db6627f57f8b36e2355"
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
