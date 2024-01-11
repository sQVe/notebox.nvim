# 📥 notebox

**Notebox** is a plugin for Neovim designed to help you manage your Markdown-based notes. It is intentionally **lightweight**, adhering to the **Unix** philosophy, and focuses on streamlining the **creation and retrieval of notes**.

_Additional note-taking features, such as highlighting and LSP support, are accessible through other plugins; see the [companions] section for more information._

<br /> <!-- prettier-ignore -->

<!-- TODO: Show the features with a VHS recording. -->

<br /> <!-- prettier-ignore -->

## ✨ Key features

<!-- TODO -->

- **Key**: Value

<br /> <!-- prettier-ignore -->

## ⚡ Requirements

- [Neovim]
- [plenary.nvim]
- [telescope.nvim]

<br /> <!-- prettier-ignore -->

## 📦 Installation

### [lazy.nvim]

```lua
{
  'sQVe/notebox.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    -- Input configuration here.
    -- Refer to the configuration section below for options.
  }
},
```

### [packer.nvim]

```lua
use({
  'sQVe/notebox.nvim',
  requires = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('notebox').setup({
      -- Input configuration here.
      -- Refer to the configuration section below for options.
    })
  end,
})
```

<br /> <!-- prettier-ignore -->

## 🔌 Configuration

The following code block shows the available options and their defaults:

```lua
{
  generate_note_id = nil,
  get_open_options = nil,
  root_directory = vim.fn.expand('$HOME') .. '/notebox',
  subdirectories = {
    dailies = 'dailies',
    new_notes = 'inbox',
    templates = 'templates',
  },
}
```

<br /> <!-- prettier-ignore -->

### `generate_note_id`

A callback function that generates the id of a note. The builtin handler for this provides the following ids:

| Type  | Format            | Example                  |
| ----- | ----------------- | ------------------------ |
| Daily | `%Y%m%d-%A`       | `20230131-wednesday`     |
| Note  | `%Y%m%d-` + title | `20230131-my-note-title` |

#### Parameters

- `type`: `('daily' | 'note')?` - The note type.
- `title`: `string?` - The note title.

#### Return

Returns the note id string.

<br /> <!-- prettier-ignore -->

### `get_open_options`

A callback function that returns the options to feed into the opening process. The built-in handler supports opening the file on macOS (`open`) and Linux (`xdg-open`) in the program associated with its type.

#### Return

Returns a `table`: `{ command: string, args: string[] }` with arguments to pass to the open process.

#### Example

<!-- TODO: Display my Obsidian setup here. -->

<br /> <!-- prettier-ignore -->

### `root_directory`

A `string` value that determines the root directory for notebox.

<br /> <!-- prettier-ignore -->

### `subdirectories`

A `table` that sets sub directory names within the `root_directory`.

#### `dailies`

A `string` value that determines where daily notes will be stored.

#### `new_notes`

A `string` value that determines where new notes will be stored.

#### `templates`

A `string` value that determines where templates are stored.

The following template files are used:

1. `daily.md`: When creating a new daily note.
1. `note.md`: When creating a new note.

<br /> <!-- prettier-ignore -->

## 📗 Usage

Notebox works out-of-the-box with the `auto_start` option enabled. The following API is available under `require('notebox')` if you want to handle things manually:

<br /> <!-- prettier-ignore -->

### `require('notebox').setup`

Sets up the plugin, see [configuration] for further information.

<br /> <!-- prettier-ignore -->

### `require('notebox/note').new_note`

Create a new note.

#### Parameters

- `note_type`: `('daily' | 'note')?` - The type of note. Defaults to `'note'`.
- `note_title`: `string?` - The title of the note. The user will be prompted for the title if it is not provided.
- `use_buffer_directory`: `boolean?` - Determines whether to create the new note in the same directory as the current buffer. Defaults to `false`.

<br /> <!-- prettier-ignore -->

### `require('notebox/note').open_note`

Open the current note in the system default application.

<br /> <!-- prettier-ignore -->

### `require('notebox/telescope').find_note`

Find notes by their filename.

#### Parameters

- `root_directory`: `string?` - The root directory, defaults to `config.root_directory` config if unspecified.

<br /> <!-- prettier-ignore -->

### `require('notebox/telescope').live_grep_note`

Find notes by their content.

#### Parameters

- `root_directory`: `string?` - The root directory, defaults to `config.root_directory` config if unspecified.

<br /> <!-- prettier-ignore -->

## 👥 Companions

The purpose of notebox is to provide frictionless creation and retrieval of notes. It is just one piece of a larger puzzle when it comes to creating a cozy environment for managing Markdown-based notes. The remaining information in this section will give you an opinionated view on how I ([sQVe]) have set up other Neovim plugins to create my note-taking environment.

<br /> <!-- prettier-ignore -->

### LSP and completion

One essential part of any note-taking environment is the ability to easily navigate and reference other notes. The following plugins provide a rich set of features for this purpose:

<!-- TODO -->

- [nvim-lspconfig] together with [marksman]:
- [nvim-cmp]:
- [LuaSnip]:

<br /> <!-- prettier-ignore -->

### Syntax and highlighting

<!-- TODO -->

- [headlines.nvim]:
- [nvim-treesitter]:

<br /> <!-- prettier-ignore -->

## 💡 Inspiration

The following plugins inspired this plugin:

- [obsidian.nvim]
  - This plugin kick-started my note-taking journey and helped me discover my preferred method for working with markdown-based notes. See [alternatives to notebox] for a comparison.
  - It provided insights into how to open notes in Obsidian, which is the GUI note-taking application that I personally use.
- [nvim-lspconfig]
  - It provided insights into how to safely resolve the current operating system, especially when it comes to Windows.

<br /> <!-- prettier-ignore -->

## 🔀 Alternatives to notebox

There are multiple alternatives to notebox, most of which aim to provide a feature-rich or even feature-complete note-taking environment. The following plugins are excellent options if you are willing to commit to a specific workflow and don't need to assemble your environment by yourself.

- [mkdnflow.nvim]: Boosts Markdown navigation and management. Offers features inspired by Vimwiki, such as link syncing and file renaming.
- [neorg]: Provides a variety of tools for note-taking and project management in the `.norg` format, including time tracking and authoring features.
- [obsidian.nvim]: Allows writing and interacting with Obsidian vaults directly in Neovim.
- [vimwiki]: Acts as a personal wiki for Vim, facilitating note-taking, task management, and content exporting to HTML.

<br /> <!-- prettier-ignore -->

## ➕ Contributing

All contributions to notebox are greatly appreciated, whether it's a bug fix or a feature request. If you would like to contribute, please don't hesitate to reach out via the [issue tracker].

Before making a pull request, please consider the following:

- Follow the existing code style and formatting conventions.
  - Install [Stylua] to ensure proper formatting.
- Write clear and concise commit messages that describe the changes you've made.

<br /> <!-- prettier-ignore -->

## 🏁 Roadmap

- [ ] Ability to customize the template name for new notes and daily notes.
- [ ] Create a week's worth of daily notes. Useful for writing to-dos for each day of the week.
- [ ] Customize template attributes.
- [ ] Generate a list of notes created today within the daily note.
- [ ] Generate a weekly review note.
- [ ] Handle non-flat daily note structures.
- [ ] Open notes backward or forward from the current date or from the date of the current note.

[LuaSnip]: https://github.com/L3MON4D3/LuaSnip
[alternatives to notebox]: #-alternatives-to-notebox
[companion]: #-companions
[configuration]: #-configuration
[headlines.nvim]: https://github.com/lukas-reineke/headlines.nvim
[lazy.nvim]: https://github.com/folke/lazy.nvim
[marksman]: https://github.com/artempyanykh/marksman
[mkdnflow.nvim]: https://github.com/jakewvincent/mkdnflow.nvim
[neorg]: https://github.com/nvim-neorg/neorg
[neovim]: https://neovim.io
[notebox issue tracker]: https://github.com/sQVe/notebox.nvim/issues
[nvim-cmp]: https://github.com/hrsh7th/nvim-cmp
[nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[obsidian.nvim]: https://github.com/epwalsh/obsidian.nvim
[packer.nvim]: https://github.com/wbthomason/packer.nvim
[plenary.nvim]: https://github.com/nvim-lua/plenary.nvim
[stylua]: https://github.com/johnnymorganz/stylua
[telescope.nvim]: https://github.com/nvim-treesitter/nvim-treesitter
[vimwiki]: https://github.com/vimwiki/vimwiki
