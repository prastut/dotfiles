# dotfiles

iTerm-style Cmd shortcuts for herdr running inside [Ghostty](https://ghostty.org) on macOS.

## Install

```sh
git clone https://github.com/prastut/dotfiles.git ~/Dev/dotfiles
~/Dev/dotfiles/install.sh
```

Then press `cmd+shift+,` in Ghostty to reload its config, and open a new shell.

`install.sh` backs up anything it replaces as `<file>.bak-<timestamp>` and is safe to run twice.

## Shortcuts

| Key | Sends | herdr action |
|---|---|---|
| cmd+d | ctrl+b, v | split side by side |
| cmd+shift+d | ctrl+b, - | split top and bottom |
| cmd+t | ctrl+b, c | new tab |
| cmd+w | ctrl+b, x | close pane |
| cmd+b | ctrl+b, b | toggle sidebar (collapse/expand) |
| cmd+1 … cmd+9 | ctrl+b, 1 … 9 | go to tab 1-9 |
| cmd+shift+[ | ctrl+b, p | previous tab |
| cmd+shift+] | ctrl+b, n | next tab |
| cmd+s | ctrl+s | save (in micro) |

**cmd+w kills whatever is running in the pane, agents included, without asking.** It also no longer closes Ghostty windows; use cmd+q or the red button.

Not mapped on purpose:

- **cmd+z** stays Ghostty's undo. Sending ctrl+z would suspend Claude Code, Codex and other programs.
- **cmd+c / cmd+v** stay Ghostty's copy and paste.

These assume herdr's default prefix (`ctrl+b`) and default keys. If you changed them, edit `ghostty/config.ghostty`, otherwise the Cmd keys silently stop working or type stray letters.

Ghostty can't tell whether herdr is running, so outside herdr these keys send ctrl+b plus a letter to the shell (cursor moves left one character and a letter is typed). Harmless, just delete it.

## What gets installed

- `ghostty/config.ghostty` is symlinked to `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`.
- `zsh/herdr.zsh` is sourced from `~/.zshrc`. It sets `setopt noflowcontrol` so ctrl+s never freezes the shell.

## Undo

1. Delete the symlinked Ghostty config, or restore its `.bak-<timestamp>` file.
2. Remove the `source .../zsh/herdr.zsh` line from `~/.zshrc`.
3. Reload Ghostty (`cmd+shift+,`) and open a new shell.
