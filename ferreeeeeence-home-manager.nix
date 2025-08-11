{ config, pkgs, lib, ...}: 

with lib.hm.gvariant;

{
	home.packages = with pkgs; [ qutebrowser starship lazygit fzf yazi];
	programs.fzf.enable = true;
	programs.yazi = {
		enable = true;
	};
	programs.git = {
		enable = true;
		userName = "cameronrwyenberg";
		userEmail = "cameronrwyenberg@gmail.com";
	};
	programs.lazygit.enable = true;
	programs.qutebrowser = {
		enable = true;
		settings = {
			tabs.position = "left";
		};
		extraConfig = ''c.tabs.padding = {"bottom":10, "left":5, "right":5, "top":10}'';
	};
	programs.kitty = {
		enable = true;
		themeFile = "flexoki_dark";
		settings = {
			shell = ".";
		};
		font.name = "Hack Nerd Font";
	};
	programs.starship = {
		enable = true;
		settings = {
			add_newline = true;
			character = {
				success_symbol = "[➜](bold green)";
				error_symbol = "[➜](bold red)";
			};
		};
	};
	programs.nushell = {
		enable = true;
		settings = {
			show_banner = false;
		};
	};
	programs.neovim = {
		enable = true;
		extraLuaConfig = 
##################################We starting neovim config peeeeeeeeeps		
			''
			local data_dir = vim.fn.stdpath('data')
			if vim.fn.empty(vim.fn.glob(data_dir .. '/site/autoload/plug.vim')) == 1 then
				vim.cmd('silent !curl -fLo ' .. data_dir .. '/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
				vim.o.runtimepath = vim.o.runtimepath
				vim.cmd('autocmd VimEnter * PlugInstall --sync | source $MYVIMRC')
			end
			
			local vim = vim
			local Plug = vim.fn['plug#']

			vim.g.start_time = vim.fn.reltime()
			vim.loader.enable() --  SPEEEEEEEEEEED 
			vim.call('plug#begin')
--#######################################################################here we be adding plugs
			Plug('kepano/flexoki-neovim') --colourscheme
			Plug('folke/which-key.nvim') --whichkey?
			Plug('nvim-tree/nvim-web-devicons') --icons for stuff
			Plug('ibhagwan/fzf-lua')
			Plug('nvim-lualine/lualine.nvim') --statusline
			Plug('ron-rs/ron.vim') --ron syntax highlighting
			Plug('nvim-treesitter/nvim-treesitter') --improved syntax
			Plug('mfussenegger/nvim-lint') --async linter
			Plug('norcalli/nvim-colorizer.lua') --color highlight
			Plug('MeanderingProgrammer/render-markdown.nvim') --render md inline
			Plug('emmanueltouzery/decisive.nvim') --view csv files
			Plug('echasnovski/mini.files') --navigate files
			Plug('HiPhish/rainbow-delimiters.nvim')
			Plug('leath-dub/snipe.nvim')
			Plug('goolord/alpha-nvim') --pretty startup
			Plug('rust-lang/rust.vim') --supposedly needed for rustfmt to work (also see option below for /bin/bash :( )
--#######################################################################here we stop adding plugs
			vim.call('plug#end')

			vim.opt.shell = "/bin/sh" --necessary to make rustfmt work. see bottom https://github.com/rust-lang/rust.vim/issues/461 can't use nushell for now

			local alpha = require('alpha')
			local dashboard = require("alpha.themes.dashboard")
			dashboard.section.header.val = {
			
			
				[[           	  ██████╗ ██╗  ██╗              ]],
				[[           	 ██╔═══██╗██║  ██║              ]],
				[[           	 ██║   ██║███████║              ]],
				[[           	 ██║   ██║██╔══██║              ]],
				[[           	 ╚██████╔╝██║  ██║              ]],
				[[           	  ╚═════╝ ╚═╝  ╚═╝              ]],
				[[                                              ]],
				[[██████╗ ██╗   ██╗████████╗████████╗███████╗██╗]],
				[[██╔══██╗██║   ██║╚══██╔══╝╚══██╔══╝██╔════╝██║]],
				[[██████╔╝██║   ██║   ██║      ██║   ███████╗██║]],
				[[██╔══██╗██║   ██║   ██║      ██║   ╚════██║╚═╝]],
				[[██████╔╝╚██████╔╝   ██║      ██║   ███████║██╗]],
				[[╚═════╝  ╚═════╝    ╚═╝      ╚═╝   ╚══════╝╚═╝]],
				[[						]],
				[[         Well, better start working.		]],
			}
			
			dashboard.section.buttons.val = {
				dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("f", "󰍉  Find file", ":lua require('fzf-lua').files() <CR>"),
				dashboard.button("fm", "  Browse cwd", ":lua MiniFiles.open()<CR>"),
				dashboard.button("r", "  Browse src", ":e ~/.local/src/<CR>"),
				dashboard.button("s", "󰯂  Browse scripts", ":e ~/scripts/<CR>"),
				dashboard.button("c", "  Config", ":e ~/.config/nvim/<CR>"),
				dashboard.button("m", "  Mappings", ":e ~/.config/nvim/lua/config/mappings.lua<CR>"),
				dashboard.button("p", "  Plugins", ":PlugInstall<CR>"),
				dashboard.button("q", "󰅙  Quit", ":q!<CR>"),
			}
			
			dashboard.section.footer.val = function()
			  return vim.g.startup_time_ms or "[[ The garbage trolls are coming ]]"
			end
			
			dashboard.section.buttons.opts.hl = "Keyword"
			dashboard.opts.opts.noautocmd = true
			alpha.setup(dashboard.opts)
			require('alpha').setup(require'alpha.themes.dashboard'.config)

			require('mini.files').setup() --I think we need this?

			local options = {
				laststatus = 3,
				ruler = false, --disable extra numbering
				showmode = false, --not needed due to lualine
				showcmd = false,
				wrap = true, --toggle bound to leader W
				mouse = "a", --enable mouse
				clipboard = "unnamedplus", --system clipboard integration
				history = 100, --command line history
				swapfile = false, --swap just gets in the way, usually
				backup = false,
				undofile = true, --undos are saved to file
				cursorline = true, --highlight line
				ttyfast = true, --faster scrolling
				smoothscroll = true,
				title = true, --automatic window titlebar
				
				number = true, --numbering lines
				relativenumber = false, --toggle bound to leader nn
				numberwidth = 4,
			
				smarttab = true, --indentation stuff
				cindent = true,
				autoindent = false,
				tabstop = 4, --visual width of tab
			
				foldmethod = "expr",
				foldlevel = 99, --disable folding, lower #s enable
				foldexpr = "nvim_treesitter#foldexpr()",
				
				termguicolors = true,
			
				ignorecase = true, --ignore case while searching
				smartcase = true, --but do not ignore if caps are used
			
				conceallevel = 2, --markdown conceal
				concealcursor = "nc",
			
				splitkeep = 'screen', --stablizie window open/close
			}
			
			for k, v in pairs(options) do
				vim.opt[k] = v
			end
			
			vim.diagnostic.config({
				signs = false,
			})

			local snipe = require("snipe")
			snipe.setup({
			  hints = {
			    dictionary = "saflewcmpghio",
			  },
			  navigate = {
			    next_page = "J",
			    prev_page = "K",
			
			    -- You can also just use normal navigation to go to the item you want
			    -- this option just sets the keybind for selecting the item under the
			    -- cursor
			    under_cursor = "<cr>",
			
			    -- In case you changed your mind, provide a keybind that lets you
			    -- cancel the snipe and close the window.
			    ---@type string|string[]
			    cancel_snipe = "<esc>",
			
			    -- Close the buffer under the cursor
			    -- Remove "j" and "k" from your dictionary to navigate easier to delete
			    close_buffer = "d",
			
			    -- Open buffer in vertical split
			    open_vsplit = "V",
			
			    -- Open buffer in split, based on `vim.opt.splitbelow`
			    open_split = "H",
			
			    -- Change tag manually (note only works if `persist_tags` is not enabled)
			    -- change_tag = "C",
			  },
			  -- The default sort used for the buffers
			  -- Can be any of:
			  --  "last" - sort buffers by last accessed
			  --  "default" - sort buffers by its number
			  --  fun(bs:snipe.Buffer[]):snipe.Buffer[] - custom sort function, should accept a list of snipe.Buffer[] as an argument and return sorted list of snipe.Buffer[]
			  ---@type "last"|"default"|fun(buffers:snipe.Buffer[]):snipe.Buffer[]
			  sort = "default",
			})
			vim.keymap.set("n", "gb", snipe.open_buffer_menu)
			
			require("colorizer").setup({ "*" }, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				names = false, -- "Name" codes like Blue
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
			})

			require('lint').linters_by_ft = { --some of these need to be installed from package manager
			  lua = {'luac'},
			  python = {'ruff'},
			  sh = {'bash'},
			  c = {'cppcheck'},
			  rust = {'clippy'},
			  css = {'stylelint'},
			  html = {'htmlhint'},
			}

			require'nvim-treesitter.configs'.setup {
				ensure_installed = { "c", "css", "cpp", "html", "javascript", "json", "lua", "markdown", "markdown_inline", "python", "rust" },
				highlight = {
					enable = true,
			    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			    -- Using this option may slow down your editor, and you may see some duplicate highlights.
			    -- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
					init_selection = "gnn", -- set to `false` to disable one of the mappings
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
					},
				},
			}

			require('lualine').setup {
			  options = {
			    icons_enabled = true,
			    theme = 'auto',
			    component_separators = { left = '', right = ''},
			    section_separators = { left = '', right = ''},
			    disabled_filetypes = {
			      statusline = {},
			      winbar = {},
			    },
			    ignore_focus = {},
			    always_divide_middle = true,
			    always_show_tabline = true,
			    globalstatus = false,
			    refresh = {
			      statusline = 1000,
			      tabline = 1000,
			      winbar = 1000,
			      refresh_time = 16, -- ~60fps
			      events = {
			        'WinEnter',
			        'BufEnter',
			        'BufWritePost',
			        'SessionLoadPost',
			        'FileChangedShellPost',
			        'VimResized',
			        'Filetype',
			        'CursorMoved',
			        'CursorMovedI',
			        'ModeChanged',
			      },
			    }
			  },
			  sections = {
			    lualine_a = {'mode'},
			    lualine_b = {'branch', 'diff', 'diagnostics'},
			    lualine_c = {'filename'},
			    lualine_x = {'encoding', 'fileformat', 'filetype'},
			    lualine_y = {'progress'},
			    lualine_z = {'location'}
			  },
			  inactive_sections = {
			    lualine_a = {},
			    lualine_b = {},
			    lualine_c = {'filename'},
			    lualine_x = {'location'},
			    lualine_y = {},
			    lualine_z = {}
			  },
			  tabline = {},
			  winbar = {},
			  inactive_winbar = {},
			  extensions = {}
			}

			local wk = require("which-key")
			wk.add({
			{ "<leader>d", desc = "duplicate file" },
			{ "<leader>u", desc = "open url" },
			{ "<leader>f", desc = "fzf" },
			{ "<leader>g", desc = "grep" },
			{ "<leader>G", desc = "grep under cursor" },
			{ "<leader>x", desc = "chmod +x" },
			{ "<leader>t", desc = "view files" },
			{ "<leader>R", desc = "reload config" },
			{ "<leader>vs", desc = "vsplit next buf" },
			{ "<leader>w", desc = "write" },
			{ "<leader>W", desc = "toggle wrap" },
			{ "<leader>q", desc = "close buf" },
			{ "<leader>Q", desc = "close buf!" },
			{ "<leader>U", desc = "close ALL buf" },
			{ "<leader>nn", desc = "toggle relative nums" },
			{ "<leader>H", desc = "htop terminal" },
			{ "<leader>T", desc = "git status" },
			{ "<leader>F", desc = "fzf opts" },
			{ "<leader>fm", desc = "open mini files" },
			{ "gb", desc = "open snipe" },
			})

			require("fzf-lua").setup{
			file_icon_padding = ' ',
		
			keymap = {
			    -- Below are the default binds, setting any value in these tables will override
			    -- the defaults, to inherit from the defaults change [1] from `false` to `true`
			    builtin = {
			      -- neovim `:tmap` mappings for the fzf win
			      -- true,        -- uncomment to inherit all the below in your custom config
			      ["<M-Esc>"]     = "hide",     -- hide fzf-lua, `:FzfLua resume` to continue
			      ["<F1>"]        = "toggle-help",
			      ["<F2>"]        = "toggle-fullscreen",
			      -- Only valid with the 'builtin' previewer
			      ["<F3>"]        = "toggle-preview-wrap",
			      ["<F4>"]        = "toggle-preview",
			      -- Rotate preview clockwise/counter-clockwise
			      ["<F5>"]        = "toggle-preview-ccw",
			      ["<F6>"]        = "toggle-preview-cw",
			      -- `ts-ctx` binds require `nvim-treesitter-context`
			      ["<F7>"]        = "toggle-preview-ts-ctx",
			      ["<F8>"]        = "preview-ts-ctx-dec",
			      ["<F9>"]        = "preview-ts-ctx-inc",
			      ["<S-Left>"]    = "preview-reset",
			      ["<S-down>"]    = "preview-page-down",
			      ["<S-up>"]      = "preview-page-up",
			      ["<M-S-down>"]  = "preview-down",
			      ["<M-S-up>"]    = "preview-up",
			    },
			    fzf = {
			      -- fzf '--bind=' options
			      -- true,        -- uncomment to inherit all the below in your custom config
			      ["ctrl-z"]      = "abort",
			      ["ctrl-u"]      = "unix-line-discard",
			      ["ctrl-f"]      = "half-page-down",
			      ["ctrl-b"]      = "half-page-up",
			      ["ctrl-a"]      = "beginning-of-line",
			      ["ctrl-e"]      = "end-of-line",
			      ["alt-a"]       = "toggle-all",
			      ["alt-g"]       = "first",
			      ["alt-G"]       = "last",
			      -- Only valid with fzf previewers (bat/cat/git/etc)
			      ["f3"]          = "toggle-preview-wrap",
			      ["f4"]          = "toggle-preview",
			      ["shift-down"]  = "preview-page-down",
			      ["shift-up"]    = "preview-page-up",
			    },
			},
			}

			vim.cmd('silent! colorscheme flexoki-dark') --setting the colourscheme
			
			-- mappings, including plugins KEYMAPS
			
			local function map(m, k, v)
				vim.keymap.set(m, k, v, { noremap = true, silent = true })
			end
			
			-- set leader
			map("", "<Space>", "<Nop>")
			vim.g.mapleader = " "
			vim.g.maplocalleader = " "
			
			-- buffers
			map("n", "<S-l>", ":bnext<CR>")
			map("n", "<S-h>", ":bprevious<CR>")
			map("n", "<leader>q", ":BufferClose<CR>")
			map("n", "<leader>Q", ":BufferClose!<CR>")
			map("n", "<leader>U", "::bufdo bd<CR>") --close all
			map('n', '<leader>vs', ':vsplit<CR>:bnext<CR>') --ver split + open next buffer
			
			-- buffer position nav + reorder
			map('n', '<AS-h>', '<Cmd>BufferMovePrevious<CR>')
			map('n', '<AS-l>', '<Cmd>BufferMoveNext<CR>')
			map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>')
			map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>')
			map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>')
			map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>')
			map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>')
			map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>')
			map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>')
			map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>')
			map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>')
			map('n', '<A-0>', '<Cmd>BufferLast<CR>')
			map('n', '<A-p>', '<Cmd>BufferPin<CR>')
			
			-- windows - ctrl nav, fn resize
			map("n", "<C-h>", "<C-w>h")
			map("n", "<C-j>", "<C-w>j")
			map("n", "<C-k>", "<C-w>k")
			map("n", "<C-l>", "<C-w>l")
			map("n", "<F5>", ":resize +2<CR>")
			map("n", "<F6>", ":resize -2<CR>")
			map("n", "<F7>", ":vertical resize +2<CR>")
			map("n", "<F8>", ":vertical resize -2<CR>")
			
			-- fzf and grep
			map("n", "<leader>f", ":lua require('fzf-lua').files()<CR>") --search cwd
			map("n", "<leader>Fh", ":lua require('fzf-lua').files({ cwd = '~/' })<CR>") --search home
			map("n", "<leader>Fc", ":lua require('fzf-lua').files({ cwd = '~/.config' })<CR>") --search .config
			map("n", "<leader>Fl", ":lua require('fzf-lua').files({ cwd = '~/.local/src' })<CR>") --search .local/src
			map("n", "<leader>Ff", ":lua require('fzf-lua').files({ cwd = '..' })<CR>") --search above
			map("n", "<leader>Fr", ":lua require('fzf-lua').resume()<CR>") --last search
			map("n", "<leader>g", ":lua require('fzf-lua').grep()<CR>") --grep
			map("n", "<leader>G", ":lua require('fzf-lua').grep_cword()<CR>") --grep word under cursor

			-- mini.files
			map("n", "<leader>fm", ":lua MiniFiles.open()<CR>") --open minifiles

			-- misc
			map("n", "<leader>s", ":%s//g<Left><Left>") --replace all
			map("n", "<leader>t", ":NvimTreeToggle<CR>") --open file explorer
			map("n", "<leader>P", ":PlugInstall<CR>") --vim-plug
			map('n', '<leader>z', ":lua require('FTerm').open()<CR>") --open term
			map('t', '<Esc>', '<C-\\><C-n><CMD>lua require("FTerm").close()<CR>') --preserves session
			map("n", "<leader>w", ":w<CR>") --write but one less key
			map("n", "<leader>d", ":w ") --duplicate to new name
			map("n", "<leader>x", "<cmd>!chmod +x %<CR>") --make a file executable
			map("n", "<leader>mv", ":!mv % ") --move a file to a new dir
			map("n", "<leader>R", ":so %<CR>") --reload neovim config
			map("n", "<leader>u", ':silent !xdg-open "<cWORD>" &<CR>') --open a url under cursor
			map("v", "<leader>i", "=gv") --auto indent
			map("n", "<leader>W", ":set wrap!<CR>") --toggle wrap
			map("n", "<leader>l", ":Twilight<CR>") --surrounding dim
			
			-- decisive csv
			map("n", "<leader>csa", ":lua require('decisive').align_csv({})<cr>")
			map("n", "<leader>csA", ":lua require('decisive').align_csv_clear({})<cr>")
			map("n", "[c", ":lua require('decisive').align_csv_prev_col()<cr>")
			map("n", "]c", ":lua require('decisive').align_csv_next_col()<cr>")
			
			
			map("n", "<leader>H", function() --toggle htop in term
			    _G.htop:toggle()
			end)
			
			
			map("n", "<leader>ma", function() --quick make in dir of buffer
				local bufdir = vim.fn.expand("%:p:h")
				vim.cmd("lcd " .. bufdir)
				vim.cmd("!sudo make uninstall && sudo make clean install %")
			end)
			
			
			map("n", "<leader>nn", function() --toggle relative vs absolute line numbers
				if vim.wo.relativenumber then
					vim.wo.relativenumber = false
					vim.wo.number = true
				else
					vim.wo.relativenumber = true
				end
			end)

--#####################################################setting up lsps
			vim.lsp.config('rust-analyzer', {
				cmd = { 'rust-analyzer' },
				filetypes = { 'rs', 'rust' },
				root_markers = { 'Cargo.toml' },
				})
			vim.g.rustfmt_autosave = 1
			vim.lsp.enable('rust-analyzer')
			vim.lsp.inlay_hint.enable()
			vim.api.nvim_create_autocmd('LspAttach', {
			  callback = function(ev)
			    local client = vim.lsp.get_client_by_id(ev.data.client_id)
			    if client:supports_method('textDocument/completion') then
			      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
			    end
			  end,
			})
			vim.opt.completeopt = {"menuone", "noselect", "popup"}  -- hopefully stops autocomplete automatically filling the first one in
			vim.diagnostic.config({
			    virtual_lines = true,
			    -- virtual_text = true,
			    underline = true,
			    update_in_insert = false,
			    severity_sort = true,
			    float = {
			        border = "rounded",
			        source = true,
			    },
			    signs = {
			        text = {
			            [vim.diagnostic.severity.ERROR] = "󰅚 ",
			            [vim.diagnostic.severity.WARN] = "󰀪 ",
			            [vim.diagnostic.severity.INFO] = "󰋽 ",
			            [vim.diagnostic.severity.HINT] = "󰌶 ",
			        },
			        numhl = {
			            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
			            [vim.diagnostic.severity.WARN] = "WarningMsg",
			        },
			    },
			})
			'';
##################################We ending neovim config peeeeeeeps		
	};
	dconf = {
		enable = true;
		settings = {
		    "org/gnome/Connections" = {
		      first-run = false;
		    };
		
		    "org/gnome/Console" = {
		      last-window-maximised = false;
		      last-window-size = mkTuple [ 732 528 ];
		    };
		
		    "org/gnome/Extensions" = {
		      window-height = 1032;
		      window-width = 1904;
		    };
		
		    "org/gnome/control-center" = {
		      last-panel = "system";
		      window-state = mkTuple [ 957 521 false ];
		    };
		
		    "org/gnome/desktop/app-folders" = {
		      folder-children = [ "System" "Utilities" "YaST" "Pardus" ];
		    };
		
		    "org/gnome/desktop/app-folders/folders/Pardus" = {
		      categories = [ "X-Pardus-Apps" ];
		      name = "X-Pardus-Apps.directory";
		      translate = true;
		    };
		
		    "org/gnome/desktop/app-folders/folders/System" = {
		      apps = [ "org.gnome.baobab.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Logs.desktop" "org.gnome.SystemMonitor.desktop" ];
		      name = "X-GNOME-Shell-System.directory";
		      translate = true;
		    };

		    "org/gnome/desktop/app-folders/folders/Utilities" = {
		      apps = [ "org.gnome.Connections.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.font-viewer.desktop" "org.gnome.Loupe.desktop" "org.gnome.seahorse.Application.desktop" ];
		      name = "X-GNOME-Shell-Utilities.directory";
		      translate = true;
		    };
		
		    "org/gnome/desktop/app-folders/folders/YaST" = {
		      categories = [ "X-SuSE-YaST" ];
		      name = "suse-yast.directory";
		      translate = true;
		    };
		
		    "org/gnome/desktop/background" = {
		      primary-color = "#3a4ba0";
		      secondary-color = "#2f302f";
		    };
		
		    "org/gnome/desktop/input-sources" = {
		      sources = [ (mkTuple [ "xkb" "us" ]) ];
		      xkb-options = [ "caps:escape_shifted_capslock" "altwin:swap_alt_win"];
		    };
		
		    "org/gnome/desktop/interface" = {
		      clock-format = "12h";
		      clock-show-weekday = true;
		      color-scheme = "prefer-dark";
		    };
		
		    "org/gnome/desktop/notifications" = {
		      application-children = [ "gnome-power-panel" ];
		    };
		
		    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
		      application-id = "gnome-power-panel.desktop";
		    };
		
		    "org/gnome/desktop/peripherals/mouse" = {
		      natural-scroll = true;
		    };
		
		    "org/gnome/desktop/peripherals/touchpad" = {
		      two-finger-scrolling-enabled = true;
		    };
		
		    "org/gnome/desktop/screensaver" = {
		      color-shading-type = "solid";
		      picture-options = "zoom";
		      picture-uri = "file:///nix/store/ns9zmifhhrnpfc2r83kv0gnl2ni85byd-simple-blue-2016-02-19/share/backgrounds/nixos/nix-wallpaper-simple-blue.png";
		      primary-color = "#3a4ba0";
		      secondary-color = "#2f302f";
		    };

		    "org/gnome/epiphany/state" = {
		      is-maximized = false;
		      window-size = mkTuple [ 1024 768 ];
		    };
		
		    "org/gnome/evolution-data-server" = {
		      migrated = true;
		    };
		
		    "org/gnome/nautilus/preferences" = {
		      default-folder-viewer = "icon-view";
		      migrated-gtk-settings = true;
		      search-filter-time-type = "last_modified";
		    };
		
		    "org/gnome/nautilus/window-state" = {
		      initial-size = mkTuple [ 890 550 ];
		      initial-size-file-chooser = mkTuple [ 890 550 ];
		    };
		
		    "org/gnome/settings-daemon/plugins/color" = {
		      night-light-schedule-automatic = false;
		    };
		
		    "org/gnome/shell" = {
		      enabled-extensions = [ ];
		      welcome-dialog-last-shown-version = "48.2";
		    };
		
		    "org/gnome/shell/world-clocks" = {
		      locations = [];
		    };
		
		    "org/gtk/gtk4/settings/color-chooser" = {
		      custom-colors = [ (mkTuple [ 0.9254902005195618 0.3686274588108063 0.3686274588108063 1.0 ]) ];
		      selected-color = mkTuple [ true 0.3843137323856354 0.6274510025978088 0.9176470637321472 1.0 ];
		    };
		
		    "org/gtk/settings/file-chooser" = {
		      clock-format = "12h";
		    };

		};
	};

	home.stateVersion = "25.05";
}
