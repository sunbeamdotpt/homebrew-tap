class CargoCallgraph < Formula
  desc "Generate callgraphs for Rust workspaces using rust-analyzer"
  homepage "https://github.com/sunbeamdotpt/cargo-callgraph"
  url "https://github.com/sunbeamdotpt/cargo-callgraph/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "2afde01166dcc86354c7a958d28618b4a84e0b96d6dcb7b0a4537697c781e93e"
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
