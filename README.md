# dotfiles

**Use iTerm's Cmd shortcuts to drive herdr inside Ghostty on macOS. One command installs them, backs up what it replaces, and is easy to undo.**

It rests on three points:

1. **Your muscle memory keeps working.** cmd+d, cmd+t, cmd+w, cmd+1…9 do in herdr what they did in iTerm, and cmd+c / cmd+z work inside micro.
2. **Setup takes one command.** Clone the repo and run `install.sh`; it backs up anything it replaces.
3. **The limits are small and known.** There are a few edge cases, each with a simple fix, and undo takes four steps.

## 1. Your muscle memory keeps working

Each Cmd key sends herdr's prefix (`ctrl+b`) plus a herdr key, so herdr handles the action instead of Ghostty creating its own splits and tabs.

**Panes**

| Key | Sends | herdr action |
|---|---|---|
| cmd+d | ctrl+b, v | split side by side |
| cmd+shift+d | ctrl+b, - | split top and bottom |
| cmd+w | ctrl+b, x | close pane |

**Tabs**

| Key | Sends | herdr action |
|---|---|---|
| cmd+t | ctrl+b, c | new tab |
| cmd+1 … cmd+9 | ctrl+b, 1 … 9 | go to tab 1-9 |
| cmd+shift+[ | ctrl+b, p | previous tab |
| cmd+shift+] | ctrl+b, n | next tab |

**Other**

| Key | Sends | Action |
|---|---|---|
| cmd+b | ctrl+b, b | toggle herdr sidebar (collapse/expand) |
| cmd+s | ctrl+s | save (in micro) |

**Inside micro**

| Key | Action |
|---|---|
| cmd+c | copy micro's selection |
| cmd+z | undo |

Why this needs micro config: herdr captures the mouse, so Ghostty never holds a selection and passes cmd+c/cmd+z through as kitty-protocol sequences (`ESC[99;9u`, `ESC[122;9u`). micro can't parse them and would type `99;9u` into the file. `micro/bindings.json` binds those exact sequences to Copy and Undo.

These are left alone on purpose:

- **cmd+z** is never turned into ctrl+z, which would suspend Claude Code, Codex and other programs. It undoes only inside micro, via micro's own bindings.
- **cmd+c / cmd+v** stay Ghostty's copy and paste.

## 2. Setup takes one command

```sh
git clone https://github.com/prastut/dotfiles.git ~/Dev/dotfiles
~/Dev/dotfiles/install.sh
```

Then press `cmd+shift+,` in Ghostty to reload its config, and open a new shell.

The installer:

- symlinks `ghostty/config.ghostty` to `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`, so editing either one edits the repo
- symlinks `micro/bindings.json` to `~/.config/micro/bindings.json` (restart micro to pick it up)
- adds one line to `~/.zshrc` that sources `zsh/herdr.zsh`, which sets `setopt noflowcontrol` so ctrl+s (cmd+s) never freezes the shell
- backs up anything it replaces as `<file>.bak-<timestamp>`, and is safe to run twice

## 3. The limits are small and known

| Limitation | What happens | Fix |
|---|---|---|
| **cmd+w kills the pane.** | Whatever runs in the pane, including an agent, is killed without asking. cmd+w also no longer closes Ghostty windows. | Use cmd+q or the red button to close windows. |
| **Ghostty can't tell if herdr is running.** | Outside herdr, a Cmd key moves the cursor left one character and types a stray letter. | Harmless, just delete it. |
| **A herdr menu or mode is open.** | Goto picker, settings, copy or resize mode may read the letter as their own command. | Press Esc, then the shortcut again. |
| **You changed herdr's prefix or keys.** | Shortcuts silently stop working or type stray letters. | Update the matching lines in `ghostty/config.ghostty`. |
| **cmd+9** | Goes to tab 9, not the last tab as in iTerm. herdr has no "last tab" key. | None needed. |

**Undo**

1. Delete the symlinked Ghostty config, or restore its `.bak-<timestamp>` file.
2. Delete the symlinked `~/.config/micro/bindings.json`, or restore its `.bak-<timestamp>` file.
3. Remove the `source .../zsh/herdr.zsh` line from `~/.zshrc`.
4. Reload Ghostty (`cmd+shift+,`), restart micro and open a new shell.
