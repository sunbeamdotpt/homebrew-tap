class Sunbeam < Formula
  desc "CLI for the Sunbeam Compute Platform"
  homepage "https://github.com/sunbeamdotpt/cli"
  license "MIT"

  # Prebuilt release tarballs (binary + man pages + shell completions) from
  # the GitHub release — no build toolchain required. The platform's public
  # SSO client ID is baked in by the release workflow.
  on_macos do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.2.0/sunbeam_3.2.0_aarch64-apple-darwin.tar.gz"
      sha256 "51d3da958a70e2bfcda05878573dcf92b0571bc9e01b026a892c9b296220ae50"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.2.0/sunbeam_3.2.0_x86_64-apple-darwin.tar.gz"
      sha256 "8209b339cb58c942dcf046111e721e1b29b4d937075c5018f1fd50149c89f29e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.2.0/sunbeam_3.2.0_aarch64-unknown-linux-gnu.tar.gz"
      sha256 "79f0d8dda89ca1c40a904a77c4c8ba0aaadc04d69093bd7857a2944b48771adb"
    end
    on_intel do
      url "https://github.com/sunbeamdotpt/cli/releases/download/v3.2.0/sunbeam_3.2.0_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "586ad94b0d83ac7ff8854086eb5ad682bf067c887edaff3d41d29f3c3202398f"
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
