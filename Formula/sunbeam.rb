class Sunbeam < Formula
  desc "CLI for the Sunbeam Compute Platform"
  homepage "https://github.com/sunbeamdotpt/cli"
  license "MIT"

  # Prebuilt release tarballs (binary + man pages + shell completions) from
  # the GitHub release — no build toolchain required. The platform's public
  # SSO client ID is baked in by the release workflow.
  on_macos do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.5.1/sunbeam_3.5.1_aarch64-apple-darwin.tar.gz"
      sha256 "12b3ec8f4e4599f8d950d2849d549f203205313139a533c6933f1eb1080ed0b8"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.5.1/sunbeam_3.5.1_x86_64-apple-darwin.tar.gz"
      sha256 "7e36550483aae5327fd9e80099bb994f87c12b8be6df89d7f19a0627e7da1951"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.5.1/sunbeam_3.5.1_aarch64-unknown-linux-gnu.tar.gz"
      sha256 "70d3e2b2cf99eaf61d3e70d03484cc4fa9ec5644c1faf1234ae93f25747d4f72"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.5.1/sunbeam_3.5.1_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dedad6702ce8383390014e7bd9d00d8cd3c717062122722cf31344313ea225a8"
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
