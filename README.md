# dotfiles

My macOS setup, managed with [chezmoi](https://chezmoi.io).

## Install

On a fresh Mac:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$TMPDIR" init -a --use-builtin-git=true atancasis
```

From an existing clone:

```sh
./install.sh
```

The install asks for a name, email, hostname and GPG signing key. Press Return
to keep the suggested answer. Run `chezmoi init` later to change them, or add
`--promptDefaults` to the install command to skip the questions.

To pick up later changes, run `chezmoi update`.

## What's included

### Shell

[zsh4humans](https://github.com/romkatv/zsh4humans) with the
[Powerlevel10k](https://github.com/romkatv/powerlevel10k) prompt, plus:

- Right Arrow accepts the whole autosuggestion, not one character.
- History drops duplicates anywhere, not only consecutive ones.
- Commands that don't exist are never saved to history.
- History is backed up daily, and the last week of backups is kept.
- `z` jumps to frequently used directories, with
  [zoxide](https://github.com/ajeetdsouza/zoxide).
- `.envrc` files load on `cd`, with [direnv](https://direnv.net).
- Man pages render with [bat](https://github.com/sharkdp/bat).
- [mise](https://mise.jdx.dev) is active, so a project's `.mise.toml` pins its
  tool versions.

### Terminal

[Ghostty](https://ghostty.org):

- Kanagawa Bones theme and FiraCode Nerd Font with ligatures.
- A cursor trail shader that only renders when the terminal updates, so it costs
  nothing at idle.
- Unfocused splits show a thin bar cursor instead of Ghostty's hollow box.

### Editor

[LazyVim](https://www.lazyvim.org) on Neovim:

- Kanagawa with a transparent background, matching the terminal.
- Only yanks reach the macOS clipboard; deletes and changes stay in Neovim.
- Language support and other extras are listed in `lazyvim.json`.
- [Claude Code](https://claude.com/claude-code) runs inside Neovim through the
  claudecode extra.
- Plugin versions are pinned in `lazy-lock.json`, which is symlinked into this
  repo, so `:Lazy update` shows up as a git diff to review and commit.

### Git

- Commits are GPG-signed, with pinentry-mac asking for the passphrase.
- `git pull` rebases, stashing local changes first.
- `git lg` shows the history as a graph.
- The first `git push` of a new branch sets its upstream, with no `-u`.
- Fetching prunes branches deleted on the remote.
- Diffs use the histogram algorithm, and conflicts also show the original lines
  (zdiff3).
- Conflict resolutions are recorded and reused (rerere).
- `git branch` lists the most recently committed branches first.
- `.DS_Store` is ignored in every repository.

### macOS

- The chosen hostname is applied to ComputerName, LocalHostName and HostName.
  Answering `none` leaves them alone.
- [Ice](https://icemenubar.app) manages the menu bar.
- The menu bar clock shows seconds.
- Tap to click works on both the built-in and Bluetooth trackpads.
- Key repeat is faster than System Settings allows, with no accent menu.
- No auto-capitalisation, smart dashes, smart quotes, double-space periods or
  autocorrect.
- The Dock hides with no delay or animation.
- Finder writes no `.DS_Store` files to network or USB volumes.
- Time Machine doesn't offer new drives as backup disks.

### Tools

- Homebrew: bat, btop, chezmoi, coreutils, direnv, fd, git, glow, gnupg, ifstat,
  lazygit, make, mise, Neovim, nmap, pinentry-mac, ripgrep, rsync, sops, telnet,
  tree, tree-sitter-cli, watch, websocat, wget and zoxide.
- mise: Node LTS, which LazyVim's language servers need, and Rust and Zig for
  their extras.
- `make` is GNU Make 4 and `rsync` is rsync 3, in place of macOS's frozen Make
  3.81 and its openrsync.

### Preferences

Things I use but don't need on every machine:

- Containers with colima and Docker.
- kitty, with a custom app icon, and WezTerm.
- Hammerspoon sizes Ghostty's font for each display.
- Go, Python and Bun through mise, with LazyVim's Go and Python extras.
- jq, yq, xh, jwt-cli, uv, jj, zellij, ffmpeg and Codex through Homebrew.
- Chrome ignores swipe-to-go-back and prints with the macOS dialog.
- Firefox, OBS, HandBrake, MacWhisper, The Unarchiver, Mouseless and
  Amphetamine.
- `imgsizes` lists the images below the current directory with their file size
  and pixel dimensions.

## Credits

The macOS defaults started from Mathias Bynens'
[.macos](https://github.com/mathiasbynens/dotfiles/blob/main/.macos) and are
checked against [macos-defaults.com](https://macos-defaults.com).

The Ghostty cursor shader is based on Krone Corylus'
[ghostty-shader-playground](https://github.com/KroneCorylus/ghostty-shader-playground),
under the MIT License.
