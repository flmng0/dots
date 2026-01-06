(let [project-root (vim.fs.root "." "project.godot")]
  (when project-root
      (let [pipe-path (vim.fs.joinpath project-root "nvim.pipe")]
        (when (not (vim.uv.fs_stat pipe-path))
          (vim.fn.serverstart pipe-path)
          (print "Started server at" pipe-path)))))
            
