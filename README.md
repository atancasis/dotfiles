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

The install asks for a name, email, hostname and GPG signing key, and which
package sets to install. Press Return to keep the suggested answer. Run
`chezmoi init` later to change them, or add `--promptDefaults` to the install
command to skip the questions.

To pick up later changes, run `chezmoi update`. If it says the config file
template has changed, run `chezmoi init` first.

## What's included

### Shell

[zsh4humans](https://github.com/romkatv/zsh4humans) with the
[Powerlevel10k](https://github.com/romkatv/powerlevel10k) prompt, plus:

- Right Arrow accepts the whole autosuggestion, not one character.
- History drops duplicates anywhere, not only consecutive ones.
- A mistyped command name gets a suggested fix before it runs.
- Commands that don't exist are never saved to history.
- `hist d <pattern>` removes matching commands from history. Start it with a
  space, or the pattern itself is saved.
- Undo (Ctrl+/) at an empty prompt takes back the last command for fixing.
- History is backed up daily, and the last week of backups is kept.
- `z` jumps to frequently used directories, with
  [zoxide](https://github.com/ajeetdsouza/zoxide).
- `.envrc` files load on `cd`, with [direnv](https://direnv.net).
- Man pages render with [bat](https://github.com/sharkdp/bat).
- [mise](https://mise.jdx.dev) is active, so a project's `.mise.toml` pins its
  tool versions.
- `imgsizes` lists the images below the current directory with their file size
  and pixel dimensions.

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
- Language support and other extras are listed in `lazyvim.json`, except those
  that need a package set's runtimes, which `lua/config/lazy.lua` imports only
  with that set.
- [Claude Code](https://claude.com/claude-code) runs inside Neovim through the
  claudecode extra.
- Plugin versions are pinned in `lazy-lock.json`, which is symlinked into this
  repo, so `:Lazy update` shows up as a git diff to review and commit. Run it on
  a machine with every package set, or the lock drops the plugins it lacks.

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
- A mistyped git command offers the closest match and asks before running it.
- `.DS_Store` is ignored in every repository.
- Pushes to GitHub go over SSH, even from repos cloned over HTTPS.

### macOS

- The chosen hostname is applied to ComputerName, LocalHostName and HostName on
  every apply, undoing macOS's `-2` renames. Answering `none` leaves them alone.
- [Thaw](https://github.com/thaw-app/Thaw) manages the menu bar.
- [Raycast](https://www.raycast.com) opens apps, since the Dock starts empty.
- The menu bar clock shows seconds.
- Tap to click works on both the built-in and Bluetooth trackpads.
- Key repeat is faster than System Settings allows, with no accent menu.
- No auto-capitalisation, smart dashes, smart quotes, double-space periods or
  autocorrect.
- GarageBand and its sound library, iMovie, Keynote, Numbers and Pages are
  removed. All are free in the App Store, and stay if you reinstall them.
- The Dock starts empty, shows no suggested or recent apps, and hides with no
  delay or animation.
- Finder writes no `.DS_Store` files to network or USB volumes.
- Finder opens folders in list view.
- Time Machine doesn't offer new drives as backup disks.

### Tools

- Homebrew: bat, btop, chezmoi, coreutils, direnv, fd, git, glow, gnupg, ifstat,
  jq, lazygit, make, mise, Neovim, nmap, pinentry-mac, ripgrep, rsync, sops,
  telnet, tree, tree-sitter-cli, watch, websocat, wget and zoxide.
- mise: Node LTS, which LazyVim's language servers need, and Rust and Zig for
  their extras.
- `make` is GNU Make 4 and `rsync` is rsync 3, in place of macOS's frozen Make
  3.81 and its openrsync.
- btop sorts processes by PID.
- bat uses the 1337 theme, with no decorations or line wrapping.
- glow shows rendered Markdown in a pager.

### Extras

Dev tools, containers and desktop apps, installed unless you answer no:

- Containers with colima and Docker.
- kitty, with a custom app icon, and WezTerm.
- Hammerspoon sizes Ghostty's font for each display.
- Go, Python and Bun through mise, with LazyVim's Go and Python extras.
- yq, xh, jwt-cli, uv, jj, zellij, ffmpeg and Codex through Homebrew.
- Chrome ignores swipe-to-go-back and prints with the macOS dialog.
- Firefox, OBS, HandBrake, MacWhisper, The Unarchiver, Mouseless and
  Amphetamine.
- Mouseless starts at login.
- jj uses the same identity as git.
- In zellij's scroll mode, Alt with an arrow or h/j/k/l moves focus and leaves
  scroll mode.

### Work tools

Kubernetes, cloud, Java and VPN tools, installed if you answer yes:

- Git uses the work email, if you give one, everywhere except in this repo,
  which keeps the personal one.
- The GitHub and GitLab CLIs.
- Kubernetes tools: kubectl with kubecolor, kind, k9s, sofka, kubectx, stern and
  popeye.
- k9s starts without its logo or splash screen, uses the Catppuccin Mocha skin,
  opens logs at their last 10,000 lines, and has short aliases such as `dp` for
  deployments.
- sofka starts in compact mode.
- Terraform, Terragrunt, Helm, gcloud and Vault through mise, with LazyVim's
  Terraform extra.
- Ansible, Trivy and sshuttle.
- Java (Temurin 25) and Maven through mise, with LazyVim's Java extra.
- pnpm through mise, and Vitest and Playwright tests run from Neovim.
- pgcli and mycli.
- 1Password and OpenVPN Connect.

### Personal apps

Media, messaging and VPN apps, installed unless you answer no:

- Calibre, Cryptomator, KeePassXC and NordVPN.
- IINA, Plex Media Server, Spotify and Transmission.
- Telegram, Viber and WhatsApp.

## Credits

The macOS defaults started from Mathias Bynens'
[.macos](https://github.com/mathiasbynens/dotfiles/blob/main/.macos) and are
checked against [macos-defaults.com](https://macos-defaults.com).

The Ghostty cursor shader is based on Krone Corylus'
[ghostty-shader-playground](https://github.com/KroneCorylus/ghostty-shader-playground),
under the MIT License.
