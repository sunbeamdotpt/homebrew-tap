class CargoCallgraph < Formula
  desc "Generate callgraphs for Rust workspaces using rust-analyzer"
  homepage "https://github.com/sunbeamdotpt/cargo-callgraph"
  url "https://github.com/sunbeamdotpt/cargo-callgraph/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e85cea06ef7fa892d094a60646690d7417e93216f0a127ce63c65f60a306ea7f"
  license "AGPL-3.0-or-later"
  head "https://github.com/sunbeamdotpt/cargo-callgraph.git", branch: "mainline"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cargo-callgraph --version")
  end
end
