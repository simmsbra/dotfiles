vim.api.nvim_create_autocmd('BufEnter', {
    pattern = {"*.c", "*.h"},
    callback = function(args)
        vim.treesitter.start(args.buf, 'c')
    end
})
