# Sunbeam Homebrew Tap

A custom [Homebrew](https://brew.sh/) tap for Sunbeam tools.

## Setup

Add this tap to Homebrew:

```bash
brew tap sunbeamdotpt/tap https://github.com/sunbeamdotpt/tap.git
```

Or with SSH:

```bash
brew tap sunbeamdotpt/tap git@github.com:sunbeamdotpt/tap.git
```

## Available Formulae

| Formula | Description | Install Command |
|---------|-------------|-----------------|
| `sunbeam` | Kubernetes-based local dev stack manager (CLI) | `brew install sunbeam` |
| `sunbeam-memory` | Personal semantic memory server for AI assistants | `brew install sunbeam-memory` |
| `cargo-callgraph` | Generate callgraphs for Rust workspaces using rust-analyzer | `brew install cargo-callgraph` |

To list all available formulae in this tap:

```bash
brew search sunbeamdotpt/tap
```

## Adding a New Formula

1. Create a new Ruby file under [`Formula/`](./Formula).
2. Name the file after the tool (e.g., `my-tool.rb`).
3. Define the formula using the Homebrew formula DSL.
4. Run `brew install --build-from-source ./Formula/my-tool.rb` to test locally.
5. Run `brew test ./Formula/my-tool.rb` and `brew audit --new ./Formula/my-tool.rb` before committing.

See the [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook) for the full DSL reference.

## Updating a Formula

1. Bump the `url`, `version`, and `sha256` in the formula file.
2. Test the install: `brew reinstall --build-from-source ./Formula/my-tool.rb`
3. Run `brew test ./Formula/my-tool.rb` and `brew audit ./Formula/my-tool.rb`.
4. Commit and push.

## Casks

If any tools are distributed as `.app` bundles or macOS installers, place cask definitions in [`Casks/`](./Casks).

## CI

The `.github/workflows/` directory contains workflows for testing and publishing bottles on new releases.
