# Neovim Plugin Setup

This Neovim configuration uses Neovim's built-in plugin manager (`vim.pack`) introduced in version 0.12+.

## Initial Setup

Plugins will be automatically downloaded when you first launch Neovim. The plugins are stored in:
```
~/.local/share/nvim/site/pack/plugins/start/
```

## Post-Installation Steps

Some plugins require additional setup after installation:

### 1. Telescope FZF Native

Build the native extension:
```bash
cd ~/.local/share/nvim/site/pack/plugins/start/telescope-fzf-native.nvim
make
```

### 2. Treesitter Parsers

After first launch, install the required parsers:
```vim
:TSUpdate
```

Or install specific parsers:
```vim
:TSInstall lua python javascript typescript go rust
```

## Updating Plugins

To update all plugins, navigate to the pack directory and update each repository:

```bash
cd ~/.local/share/nvim/site/pack/plugins/start
for dir in */; do
  echo "Updating $dir"
  cd "$dir"
  git pull
  cd ..
done
```

Alternatively, you can use the `:PackUpdate` command if you have installed a helper plugin.

## Removing Plugins

1. Remove the plugin entry from `lua/plugins.lua`
2. Delete the plugin directory:
   ```bash
   rm -rf ~/.local/share/nvim/site/pack/plugins/start/<plugin-name>
   ```

## Troubleshooting

If plugins don't load properly:
1. Check that Neovim version is 0.12 or higher: `:version`
2. Verify plugins are in the correct directory: `~/.local/share/nvim/site/pack/plugins/start/`
3. Check for errors: `:messages`
4. Restart Neovim after making changes to plugin configuration
