# dotfiles

Personal macOS dotfiles managed with [chezmoi](https://chezmoi.io).

## Quick start

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Axelb531/config/main/setup.sh)"
```

This will:
1. Install **Homebrew** (if missing)
2. Install **chezmoi** and **gh** via Homebrew
3. Authenticate with GitHub (`gh auth login`)
4. Run `chezmoi init --apply Axelb531/config`

## What's included

| App | Files |
|-----|-------|
| **Fish** | `config.fish`, `fish_variables`, `functions/` |
| **Helix** | `config.toml`, custom themes (`edge`, `onedark`) |
| **Zed** | `settings.json`, `keymap.json`, `themes/` |
| **iTerm2** | `com.googlecode.iterm2.plist`, `Default.json` profile |

## Post-install notes

### iTerm2
Point iTerm2 at the managed plist after applying:
**Settings → General → Preferences → Load preferences from a custom folder or URL**
→ set to `~/.config/iterm2`

## Dry run

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Axelb531/config/main/setup.sh)" -- --dry-run
```

## Updating

After changing a config file directly in `~/.config`:

```sh
chezmoi re-add <file>   # sync live file back into chezmoi source
chezmoi cd              # jump to the source repo
git add . && git commit -m "..." && git push
```
