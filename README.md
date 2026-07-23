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

Formula bumps are **automated**: when a source repo in the `sunbeamdotpt` org
publishes a release, its release workflow calls the reusable workflow
[`.github/workflows/bump-formula.yml`](./.github/workflows/bump-formula.yml),
which opens a `chore: bump <formula> to <version>` PR here. The PR runs the
usual CI and **auto-merges** once checks are green.

Manual fallback, if ever needed:

1. Bump the `url`, `version`, and `sha256` in the formula file — or run
   `scripts/bump-formula.sh Formula/<name>.rb <new-version>`, which does it
   for you (hashes come from the release's `checksums.txt`, falling back to
   downloading and hashing the asset).
2. Test the install: `brew reinstall --build-from-source ./Formula/<name>.rb`
3. Run `brew test ./Formula/<name>.rb` and `brew audit ./Formula/<name>.rb`.
4. Commit and push.

### Release contract for source repos

For a repo's releases to flow into this tap automatically, its release
workflow must:

1. Publish a **GitHub release** tagged `vX.Y.Z` with a **`checksums.txt`**
   asset in `sha256sum` format (`<sha>  <filename>`) covering every file the
   formula's `url`s reference. For source-build formulas (which use the
   `archive/refs/tags/vX.Y.Z.tar.gz` URL), include the source archive's entry
   (basename `vX.Y.Z.tar.gz`).
2. Call the reusable workflow at the end of the release pipeline:

   ```yaml
   homebrew-tap:
     needs: release
     uses: sunbeamdotpt/tap/.github/workflows/bump-formula.yml@mainline
     with:
       formula: <formula-name>          # filename under Formula/, without .rb
       version: ${{ github.ref_name }}  # vX.Y.Z — the v is stripped
     secrets:
       token: ${{ secrets.TAP_GITHUB_TOKEN }}
   ```

### Setup (already done once; documented for new repos)

1. **Token**: `TAP_GITHUB_TOKEN` must exist as a secret in this repo (for
   manual `workflow_dispatch` runs) and in every releasing repo. A personal
   access token is required both for cross-repo access and because PRs opened
   with the default `GITHUB_TOKEN` don't trigger CI. Currently this is the
   owner's `gh` OAuth token set per-repo; a fine-grained PAT scoped to
   `sunbeamdotpt/tap` (`Contents: read/write`, `Pull requests: read/write`)
   stored as an **org secret** visible to the releasing repos is the cleaner
   long-term option (setting org secrets needs the `admin:org` scope).
   Note the stored token stops working if the underlying credential is
   revoked.
2. **Repo settings** on `sunbeamdotpt/tap` (already configured):
   - **Allow auto-merge** is enabled;
   - branch protection on `mainline` requires the `tests.yml` checks
     (`test-bot` on macOS and Ubuntu) to pass before merging. This is what
     makes auto-merge wait for green CI. Direct pushes to `mainline` are
     still allowed.
3. **Smoke test** (already passed once): dispatch the workflow manually from
   the Actions tab with the current version — it should report a no-op. The
   full loop (PR opens, trust gate passes, auto-merge engages, CI runs) was
   verified with PR #1.

Auto-merge is only ever enabled for the same-repo `bump/<formula>-<version>`
branch the workflow itself just created — the step hard-fails on anything
else, so ordinary human or fork PRs are never auto-merged.

## Casks

If any tools are distributed as `.app` bundles or macOS installers, place cask definitions in [`Casks/`](./Casks).

## CI

The `.github/workflows/` directory contains workflows for testing the tap
(`tests.yml`) and for opening/auto-merging formula bump PRs from source-repo
releases (`bump-formula.yml`, see "Updating a Formula" above).
