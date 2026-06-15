class Example < Formula
  desc "Example formula demonstrating the Sunbeam tap structure"
  homepage "https://github.com/sunbeamdotpt/example"
  url "https://github.com/sunbeamdotpt/example/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"

  # Remove or update the bottle block after running `brew dispatch-build-bottle`.
  # bottle do
  #   sha256 cellar: :any_skip_relocation, arm64_sequoia: "..."
  # end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/example"
  end

  test do
    assert_match "example v1.0.0", shell_output("#{bin}/example --version")
  end
end
