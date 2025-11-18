local wiki_1 = {
  path = "~/Dropbox/vimwiki/markdown/",
  ext = ".md",
  syntax = "markdown",
}

local wiki_2 = {
  path = "~/Dropbox/vimwiki/vattuonet",
  ext = ".md",
  index = "_index",
  syntax = "markdown",
  custom_wiki2html = "~/code/dotfiles/wiki2html.sh",
  path_html = "~/code/vattuonet/public",
}

vim.g.vimwiki_list = { wiki_1, wiki_2 }
vim.g.vimwiki_auto_chdir = 1
