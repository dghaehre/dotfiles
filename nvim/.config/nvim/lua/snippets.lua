-- Snippets and abbreviations (converted from vimrc)

-- Abbreviations
vim.cmd([[abbr newp new Promise((resolve, reject) => {<CR><CR><esc>0i})<esc>0k]])
vim.cmd([[abbr iferr if err != nil {<CR><CR>}<esc>kddko]])
vim.cmd([[iab <expr> dts strftime("%a %d/%m/%Y")]])
vim.cmd([[iab <expr> planhome printf("## TODO (today) \| status:pending pro.not:vipps sch.before:%sT23:59:59 \n\n\n## DONE (today) \| status:completed pro.not:vipps end:%s", strftime("%Y-%m-%d"), strftime("%Y-%m-%d"))]])
vim.cmd([[iab <expr> planwork printf("## TODO (today) \| status:pending pro:vipps sch.before:%sT23:59:59 \n\n\n## DONE (today) \| status:completed pro:vipps end:%s", strftime("%Y-%m-%d"), strftime("%Y-%m-%d"))]])
