class Sunbeam < Formula
  desc "CLI for the Sunbeam Compute Platform"
  homepage "https://github.com/sunbeamdotpt/cli"
  license "MIT"

  # Prebuilt release tarballs (binary + man pages + shell completions) from
  # the GitHub release — no build toolchain required. The platform's public
  # SSO client ID is baked in by the release workflow.
  on_macos do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.1.0/sunbeam_3.1.0_aarch64-apple-darwin.tar.gz"
      sha256 "f48d53b95410bbcd48cd27fb1776db4b549a1a3ea2131eba2e7fe492fa178059"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.1.0/sunbeam_3.1.0_x86_64-apple-darwin.tar.gz"
      sha256 "27e33864149bcde19603379750b51ae1b1f2e981267edda48d8c858525f54971"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.1.0/sunbeam_3.1.0_aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cb442e9e800e7b3fb46d880e0b0bde0daef065985342d75fdc1ed76150944aab"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.1.0/sunbeam_3.1.0_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9f48b3ef606e3e0f7db797a4298d88127b11942fc030d3e5c1a78011cbe14176"
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
