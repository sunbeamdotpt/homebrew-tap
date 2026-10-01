class Sunbeam < Formula
  desc "CLI for the Sunbeam Compute Platform"
  homepage "https://github.com/sunbeamdotpt/cli"
  license "MIT"

  # Prebuilt release tarballs (binary + man pages + shell completions) from
  # the GitHub release — no build toolchain required. The platform's public
  # SSO client ID is baked in by the release workflow.
  on_macos do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.5.0/sunbeam_3.5.0_aarch64-apple-darwin.tar.gz"
      sha256 "28238583f5c2255be59ca9e837594bb64bf7abfa7706b90fed98f937aa6483a5"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.5.0/sunbeam_3.5.0_x86_64-apple-darwin.tar.gz"
      sha256 "62bf3630a82d6235f135ebdd9e28f11779e1d0e5e9085be8eefa26ae6353a53a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.5.0/sunbeam_3.5.0_aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0feb0288c343feb10871bcc3bac1bb4979c18d1b8c26ae91c8d77f1243b8ff5f"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.5.0/sunbeam_3.5.0_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "776f39841f41d71284cf825f936a6bfc4b5ef04251e63f0a8b42d15738fe6553"
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
