(fn open-in-zed []
  (let [{: get_cursor_entry : get_current_dir : select} (require :oil)
        dir (get_current_dir)
        entry (get_cursor_entry)
        file-name (. entry :name)
        entry-type (. entry :type)
        path (vim.fs.joinpath dir file-name)]
    (if (= entry-type "file")
      (do 
        (vim.fn.system (.. "zed --add " path))
        (os.exit 1))
      (select))))
  

;; File browser / editor
{1 :stevearc/oil.nvim :dependencies [:echasnovski/mini.icons]
  :opts {:keymaps
         (when vim.env.FROM_ZED
             {"<CR>"
              {:desc "Open file in Zed"
               :callback open-in-zed}})}}
       
