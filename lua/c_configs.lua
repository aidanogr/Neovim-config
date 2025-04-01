
--building c proj
vim.o.makeprg = "cmake -DCMAKE_BUILD_TYPE=Debug -S . -B ./build_files ; cmake --build ./build_files"


--execution
function get_executable()
    local handle = io.popen("ls -F build_files/ 2>/dev/null") -- List files with indicators (* for executables)
    if handle then
        for file in handle:lines() do
            if file:match("^[%w_.-]+%*$") or file:match("%.exe$") then
                handle:close()
                return "build_files/" .. file:gsub("%*$", "") -- Remove * if present
            end
        end
        handle:close()
    end
    return nil
end

function run_executable()
    local exe = get_executable()
    if exe then
        vim.cmd("! " .. exe)
    else
        print("No executable found in build/")
    end
end

vim.api.nvim_set_keymap("n", "<leader>rr", ":lua run_executable()<CR>", { noremap = true, silent = true })

vim.keymap.set('n', "<leader>bc", "<cmd>w<CR><cmd>make<cr>")
--vim.keymap.set('n', "<leader>e", "<cmd>!./build_files/<cr>")

