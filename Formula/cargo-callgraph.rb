class CargoCallgraph < Formula
  desc "Generate callgraphs for Rust workspaces using rust-analyzer"
  homepage "https://github.com/sunbeamdotpt/cargo-callgraph"
  url "https://github.com/sunbeamdotpt/cargo-callgraph/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "77eb83bdd10c791fa158ef85e2aa5be2bd56ae2eab6d00e21051962505799037"
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
