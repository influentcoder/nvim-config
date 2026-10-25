# Neovim config

My Neovim configuration, using [lazy.nvim](https://github.com/folke/lazy.nvim) for plugins.

These steps set it up from scratch on **Debian 13** (x86_64). Differences for Debian 12 are called out where they matter.

Apart from the system packages, everything installs into your home directory, mostly `~/.local/bin`. That's the standard place for per-user programs: it needs no `sudo`, and Debian's default `~/.profile` adds it to `PATH` when the folder exists.

## 1. System packages

```bash
sudo apt install git curl build-essential ripgrep fuse3
```

| Package | Used by |
|---|---|
| `git` | lazy.nvim, to install plugins; gitsigns and fugitive |
| `curl`, `build-essential` | nvim-treesitter, to download and compile parsers |
| `ripgrep` | Telescope's file search and live grep |
| `fuse3` | running the Neovim AppImage |

To copy and paste through the system clipboard (the `+` register), also install `wl-clipboard` on Wayland or `xclip` on X11.

## 2. Neovim

Neovim **0.12 or later** is required (nvim-treesitter needs it).

```bash
mkdir -p ~/.local/bin
```

If `~/.local/bin` didn't exist before, log out and back in so it's added to your `PATH`.

Download the AppImage as `~/.local/bin/nvim`:

```bash
curl -fLo ~/.local/bin/nvim https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
```

```bash
chmod u+x ~/.local/bin/nvim
```

```bash
nvim --version
```

To update Neovim later, run the same `curl` command again.

Where FUSE isn't available, such as in a container, set `APPIMAGE_EXTRACT_AND_RUN=1` before running `nvim`.

## 3. tree-sitter CLI

nvim-treesitter needs the `tree-sitter` CLI, version **0.26.1 or later**, to compile parsers. Debian's `tree-sitter-cli` package is too old.

On Debian 13, download the prebuilt binary:

```bash
curl -fL https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz | gunzip > ~/.local/bin/tree-sitter
```

```bash
chmod u+x ~/.local/bin/tree-sitter
```

On Debian 12, the prebuilt binary needs a newer glibc than Debian 12 has. Build it with Cargo instead, which needs [Rust](https://rustup.rs):

```bash
cargo install --locked tree-sitter-cli
```

## 4. This config

If you already have a Neovim setup, move `~/.config/nvim` and `~/.local/share/nvim` out of the way first.

```bash
git clone https://github.com/influentcoder/nvim-config.git ~/.config/nvim
```

## 5. Plugins and parsers

Start `nvim`. On the first start, lazy.nvim installs itself and every plugin, at the versions pinned in `lazy-lock.json`.

Then nvim-treesitter downloads and compiles the parsers listed in [nvim-treesitter.lua](lua/guillaume/plugins/nvim-treesitter.lua), in the background. Wait for the `Language installed` messages to stop, then restart `nvim`.

To check that the parsers are installed:

```vim
:checkhealth nvim-treesitter
```

The full `:checkhealth` also reports warnings that don't matter for this config: luarocks (no plugin needs it), the node, perl, python and ruby providers, and `fd` (Telescope uses ripgrep).

## 6. Font

nvim-tree shows file icons, which need a [Nerd Font](https://www.nerdfonts.com) set as your terminal's font. Without one, icons show up as boxes or question marks.

## 7. Language servers (optional)

Language servers give you completion, go-to-definition, diagnostics and so on. The config enables a server for each language below; install only the ones for the languages you use. If a server isn't installed, Neovim shows a "Spawning language server … failed" error when you open a file of that type; everything else keeps working.

Some of them install through other tools:

- [uv](https://docs.astral.sh/uv/): `curl -LsSf https://astral.sh/uv/install.sh | sh`
- Node.js: `sudo apt install nodejs npm`, then `npm config set prefix ~/.local` so global packages land in `~/.local/bin`
- [Go](https://go.dev/doc/install), with `~/go/bin` on your `PATH`
- [Rust](https://rustup.rs), through rustup

| Language | Server | Install |
|---|---|---|
| C, C++ | clangd | `sudo apt install clangd` |
| Python | pylsp | `uv tool install 'python-lsp-server[all]'` |
| Go | gopls | `go install golang.org/x/tools/gopls@latest` |
| YAML | yaml-language-server | `npm install -g yaml-language-server` |
| JavaScript, TypeScript | ts_ls | `npm install -g typescript@6 typescript-language-server` |
| Rust | rust-analyzer | `rustup component add rust-analyzer` |
| Lua | lua_ls | see below |

lua-language-server isn't packaged for Debian. Download a release from [its releases page](https://github.com/LuaLS/lua-language-server/releases) (replace the version with the latest one):

```bash
mkdir -p ~/.local/opt/lua-language-server
```

```bash
curl -fL https://github.com/LuaLS/lua-language-server/releases/download/3.19.2/lua-language-server-3.19.2-linux-x64.tar.gz | tar -xz -C ~/.local/opt/lua-language-server
```

```bash
ln -s ~/.local/opt/lua-language-server/bin/lua-language-server ~/.local/bin/lua-language-server
```

ts_ls needs TypeScript **6 or older**. TypeScript 7 no longer includes `tsserver`, which ts_ls runs, so with only TypeScript 7 installed the server fails to start.

To see which servers are running for the current file:

```vim
:checkhealth vim.lsp
```

## 8. Debuggers (optional)

| Language | Debugger | Install |
|---|---|---|
| Go | Delve | `go install github.com/go-delve/delve/cmd/dlv@latest` |
| Python | debugpy | nothing beyond [uv](https://docs.astral.sh/uv/): it fetches debugpy when a debug session starts |

## Updating

- **Plugins:** `:Lazy update`, then commit the updated `lazy-lock.json`.
- **Parsers:** `:TSUpdate`.
- **Neovim:** run the `curl` command from step 2 again.
