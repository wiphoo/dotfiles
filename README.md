# dotfiles

My personal Ubuntu workstation config. Each top-level folder is a [GNU Stow](https://www.gnu.org/software/stow/) package that mirrors `$HOME`, so installing is just symlinking.

| Package    | Installs to                          | What                                          |
|------------|--------------------------------------|-----------------------------------------------|
| `wezterm`  | `~/.config/wezterm/wezterm.lua`      | [WezTerm](https://wezterm.org) terminal       |
| `bash`     | `~/.bash_profile`                    | PATH, Android/Java env                        |
| `git`      | `~/.gitconfig`                       | Identity, `meld` as difftool                  |
| `readline` | `~/.inputrc`                         | Case-insensitive tab completion               |
| `python`   | `~/.pystartup`                       | Tab completion in the Python REPL             |
| `x11`      | `~/.Xmodmap`                         | Keypad keys work with NumLock on (for NEdit)  |
| `nedit`    | `~/.nedit/nedit.rc`                  | NEdit preferences                             |

## Install

```sh
sudo apt install stow
git clone git@github.com:wiphoo/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow wezterm            # one package
stow */                 # everything
```

Stow refuses to overwrite existing files; move yours aside first (or `stow --adopt` to pull them into the repo, then `git diff`).
Remove a package with `stow -D <package>`.

## WezTerm

Leader is `Ctrl+Space` (2s timeout). Theme: Solarized Dark, 13pt, 10k scrollback.

| Keys                         | Action                       |
|------------------------------|------------------------------|
| `Ctrl+Shift+T` / `W`         | New tab / close pane         |
| `Ctrl+Shift+D` / `E`         | Split horizontal / vertical  |
| `Leader` `\` / `-`           | Split horizontal / vertical  |
| `Leader` arrows              | Move between panes           |
| `Leader` `Shift`+arrows      | Resize pane                  |
| `Leader` `=` / `Shift+-` / `0` | Font size up / down / reset |
| `Leader` `z`                 | Zoom pane                    |
| `Leader` `r`                 | Reload config                |
| `Ctrl+Shift+F`               | Search                       |

## Notes

- `git/.gitconfig` contains my name and email; change them if you reuse it.
- `bash/.bash_profile` hardcodes a Java 9 path and the Android SDK location, so adjust for your machine.

## License

[MIT](LICENSE)
