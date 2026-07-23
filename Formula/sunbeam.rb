class Sunbeam < Formula
  desc "CLI for the Sunbeam Compute Platform"
  homepage "https://github.com/sunbeamdotpt/cli"
  license "MIT"

  # Prebuilt release tarballs (binary + man pages + shell completions) from
  # the GitHub release — no build toolchain required. The platform's public
  # SSO client ID is baked in by the release workflow.
  on_macos do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.1.1/sunbeam_3.1.1_aarch64-apple-darwin.tar.gz"
      sha256 "e7a415291761cafc9c28b6a4cb688934db6b493d7b37432545e433f547b661e6"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.1.1/sunbeam_3.1.1_x86_64-apple-darwin.tar.gz"
      sha256 "4806f3a8a924d7b5cb8702c628512ec2d51b9796f9d68c7e4d3c98a1b1c39090"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.1.1/sunbeam_3.1.1_aarch64-unknown-linux-gnu.tar.gz"
      sha256 "389d9cee24fb5880d02a3a5b8769ba0dff315af674af977822cae162cb804376"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.1.1/sunbeam_3.1.1_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d30856361e1a7c284202fb5a39e8e8b2cb7d54667f699fd219d83d6d5f545865"
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
