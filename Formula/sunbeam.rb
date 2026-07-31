class Sunbeam < Formula
  desc "CLI for the Sunbeam Compute Platform"
  homepage "https://github.com/sunbeamdotpt/cli"
  license "MIT"

  # Prebuilt release tarballs (binary + man pages + shell completions) from
  # the GitHub release — no build toolchain required. The platform's public
  # SSO client ID is baked in by the release workflow.
  on_macos do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.4.0/sunbeam_3.4.0_aarch64-apple-darwin.tar.gz"
      sha256 "e8cef306280915fd886a86b56e917cfbc69096f0b0482262047461b6461fc7b9"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.4.0/sunbeam_3.4.0_x86_64-apple-darwin.tar.gz"
      sha256 "e2619bd8538d48387801da8ede771d1c633c92dda4e09f53d3dd0947d39bd354"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.4.0/sunbeam_3.4.0_aarch64-unknown-linux-gnu.tar.gz"
      sha256 "56500d1e75d73d92970b9b4f6af7e4581a5841bd0c07664a013866cf0dcbb057"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.4.0/sunbeam_3.4.0_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c38dfc90cb7fdce4034d80aac27caec8787bd052e9216f33ac1b208c6d9effd3"
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
