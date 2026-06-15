class CargoCallgraph < Formula
  desc "Generate callgraphs for Rust workspaces using rust-analyzer"
  homepage "https://github.com/sunbeamdotpt/cargo-callgraph"
  url "https://github.com/sunbeamdotpt/cargo-callgraph/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e31a4ffdf0fb4613fd3666b2e1ea6144eab3bf78b88ef76a4010252ce688c37c"
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
