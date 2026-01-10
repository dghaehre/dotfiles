# Neovim Plugin Setup

This Neovim configuration uses Neovim's built-in plugin manager (`vim.pack`) introduced in version 0.12+.

## Requirements

- Neovim version 0.12 or higher
- Git

## How It Works

The `vim.pack.add()` function in `lua/plugins.lua` automatically downloads and manages plugins. When you first launch Neovim after this migration, all plugins will be automatically cloned to:

```
~/.local/share/nvim/site/pack/plugins/start/
```

## Initial Setup

1. **Start Neovim**: Simply launch Neovim. All plugins will be downloaded automatically on first run.

2. **Wait for plugins to install**: The first startup may take a minute or two as all plugins are being cloned.

3. **Complete post-installation steps** (see below).

## Post-Installation Steps

Some plugins require additional setup after installation:

### 1. Telescope FZF Native

Build the native extension for better performance:
```bash
cd ~/.local/share/nvim/site/pack/plugins/start/telescope-fzf-native.nvim
make
```

### 2. Treesitter Parsers

After first launch, install the required parsers. You can either:

**Install all parsers** (as configured):
```vim
:TSUpdate
```

**Or install specific parsers** you need:
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

Or create a shell script/alias for convenience:
```bash
# Add to your shell config (.bashrc, .zshrc, etc.)
alias nvim-update-plugins='cd ~/.local/share/nvim/site/pack/plugins/start && for dir in */; do echo "Updating $dir"; cd "$dir"; git pull; cd ..; done'
```

Alternatively, you can install [pack-manager.nvim](https://github.com/mplusp/pack-manager.nvim) for enhanced management commands.

## Removing Plugins

1. Remove the plugin entry from `lua/plugins.lua`
2. Delete the plugin directory:
   ```bash
   rm -rf ~/.local/share/nvim/site/pack/plugins/start/<plugin-name>
   ```
3. Restart Neovim

## Adding New Plugins

To add a new plugin:

1. Add the plugin to `vim.pack.add({})` in `lua/plugins.lua` using the GitHub repository path:
   ```lua
   vim.pack.add({
     -- existing plugins...
     "author/plugin-name",  -- Simple string syntax for GitHub repos
   })
   ```

2. If the plugin requires configuration, add it at the bottom of `plugins.lua` or create a new file in `lua/plugins/`:
   ```lua
   pcall(require, "plugin-name")
   -- or with setup:
   local ok, plugin = pcall(require, "plugin-name")
   if ok then
     plugin.setup({
       -- your config here
     })
   end
   ```

3. Restart Neovim - the plugin will be automatically cloned

### Specifying Branches, Tags, or Commits

You can pin plugins to specific versions using the table syntax with a `version` field:

```lua
vim.pack.add({
  -- Pin to a specific branch
  { src = "author/plugin-name", version = "main" },
  { src = "author/plugin-name", version = "develop" },
  
  -- Pin to a specific tag
  { src = "nvim-telescope/telescope.nvim", version = "v0.2.0" },
  
  -- Pin to a specific commit hash
  { src = "author/plugin-name", version = "abc123def456" },
  
  -- Use semver range (if plugin supports it)
  { src = "author/plugin-name", version = "^1.0.0" },
})
```

**Examples:**
- `version = "main"` - Always use the latest commit from the main branch
- `version = "v1.2.3"` - Use a specific release tag
- `version = "cbfc3d1cdc"` - Pin to a specific commit for reproducibility
- `version = "^0.9.0"` - Use semantic versioning range (if supported)

## Troubleshooting

### Plugins don't load

1. **Check Neovim version**: Ensure you're running 0.12 or higher
   ```vim
   :version
   ```

2. **Verify plugin directory**: Check that plugins are in the correct location
   ```bash
   ls ~/.local/share/nvim/site/pack/plugins/start/
   ```

3. **Check for errors**: Look for error messages
   ```vim
   :messages
   ```

4. **Restart Neovim**: Some changes require a restart to take effect

### Plugin configuration errors

If a plugin fails to load or configure:

1. Check if the plugin has been downloaded properly
2. Review the plugin's documentation for setup requirements
3. Check if you need to run a build step (like telescope-fzf-native)
4. Look for error messages in `:messages`

### Migrating from lazy.nvim

If you're migrating from the previous lazy.nvim setup:

1. The old plugin directory was `~/.local/share/nvim/lazy/` - you can safely delete it
2. The `lazy-lock.json` file has been removed - no longer needed
3. All plugin configurations have been moved to run after `vim.pack.add()`

## Migration Notes

This configuration was migrated from lazy.nvim to use Neovim's built-in `vim.pack` plugin manager. Key differences:

- **No lazy loading**: All plugins load at startup (simpler, but slightly slower startup)
- **Manual updates**: No automatic update checks
- **Simpler configuration**: No plugin manager-specific options needed
- **Native solution**: One less dependency, using Neovim's built-in features

The trade-off is a slightly longer startup time in exchange for simplicity and using native Neovim features.
