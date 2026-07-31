class Sunbeam < Formula
  desc "CLI for the Sunbeam Compute Platform"
  homepage "https://github.com/sunbeamdotpt/cli"
  license "MIT"

  # Prebuilt release tarballs (binary + man pages + shell completions) from
  # the GitHub release — no build toolchain required. The platform's public
  # SSO client ID is baked in by the release workflow.
  on_macos do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.3.0/sunbeam_3.3.0_aarch64-apple-darwin.tar.gz"
      sha256 "f9cb2706731ad2d0395b42cc9822e9e3eecba56ceaa439f6474666e8a3892bbb"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.3.0/sunbeam_3.3.0_x86_64-apple-darwin.tar.gz"
      sha256 "2a2c1901a84fab7111050bfcc257589c38b500e22a3537010f8f50db42ff3e34"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.3.0/sunbeam_3.3.0_aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6b98f0c94c5898de9492ca43dd3271ba214735c5de5fade34344843b0312789c"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.3.0/sunbeam_3.3.0_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2140b15bdb9e2dcce41bb49f37c28d258583ce49eb7d0dc02d092b8c6352213c"
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
