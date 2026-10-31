return {
    "tpope/vim-fugitive",

    cmd = {
        "Git",
        "G",
        "Gdiffsplit",
        "Gvdiffsplit",
        "Gread",
        "Gwrite",
        "Gblame",
    },
    
    keys = {
        { "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
        { "<leader>dg", function()
            local current_buf = vim.api.nvim_get_current_buf()
            vim.cmd("Gdiffsplit")

            local tabpage = vim.api.nvim_get_current_tabpage()
            local windows = vim.api.nvim_tabpage_list_wins(tabpage)
            local current_win
            for _, win in ipairs(windows) do
                if vim.api.nvim_win_get_buf(win) == current_buf and vim.wo[win].diff then
                    current_win = win
                    break
                end
            end
            if not current_win then
                return
            end

            local current_pos = vim.api.nvim_win_get_position(current_win)
            local current_width = vim.api.nvim_win_get_width(current_win)
            local current_height = vim.api.nvim_win_get_height(current_win)
            local current_right = current_pos[2] + current_width
            local current_bottom = current_pos[1] + current_height
            local repository_win, orientation
            local closest_gap

            for _, win in ipairs(windows) do
                if win ~= current_win and vim.wo[win].diff
                    and vim.api.nvim_win_get_config(win).relative == "" then
                    local pos = vim.api.nvim_win_get_position(win)
                    local width = vim.api.nvim_win_get_width(win)
                    local height = vim.api.nvim_win_get_height(win)
                    local right = pos[2] + width
                    local bottom = pos[1] + height
                    local rows_overlap = math.min(bottom, current_bottom) > math.max(pos[1], current_pos[1])
                    local cols_overlap = math.min(right, current_right) > math.max(pos[2], current_pos[2])
                    local gap, direction

                    if rows_overlap and right <= current_pos[2] + 2 then
                        gap, direction = math.max(0, current_pos[2] - right), "vertical"
                    elseif rows_overlap and current_right <= pos[2] + 2 then
                        gap, direction = math.max(0, pos[2] - current_right), "vertical"
                    elseif cols_overlap and bottom <= current_pos[1] + 2 then
                        gap, direction = math.max(0, current_pos[1] - bottom), "horizontal"
                    elseif cols_overlap and current_bottom <= pos[1] + 2 then
                        gap, direction = math.max(0, pos[1] - current_bottom), "horizontal"
                    end

                    if gap and (not closest_gap or gap < closest_gap) then
                        repository_win, orientation, closest_gap = win, direction, gap
                    end
                end
            end

            if repository_win then
                local repo_pos = vim.api.nvim_win_get_position(repository_win)
                local move_to_right = orientation == "vertical" and repo_pos[2] < current_pos[2]
                local move_below = orientation == "horizontal" and repo_pos[1] < current_pos[1]
                if move_to_right or move_below then
                    local ok, status = pcall(vim.fn.win_splitmove, repository_win, current_win, {
                        vertical = orientation == "vertical",
                        rightbelow = true,
                    })
                    if not ok or status ~= 0 then
                        vim.notify("Could not reorder Fugitive diff windows", vim.log.levels.WARN)
                    end
                end
            end

            if vim.api.nvim_win_is_valid(current_win) then
                vim.api.nvim_set_current_win(current_win)
            end
        end, desc = "Git diff current file (worktree left)" },
        { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git blame" },
    },
}
