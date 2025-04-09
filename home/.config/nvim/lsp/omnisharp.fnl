(fn root? [name path]
  (let [full-names ["omnisharp.json" "function.json"]
        full-iter (vim.iter full-names)]
   (not= nil
     (or 
      (name:match "%.csproj$")
      (name:match "%.sln$")
      (full-iter:find name)))))

{:cmd ["omnisharp" 
       "-z" 
       "--hostPID" (tostring (vim.fn.getpid)) 
       "DotNet:nablePackageRestore=false" 
       "--encoding" "utf-8" 
       "--languageserver"]
 :root_dir (vim.fs.root 0 root?)
 :filetypes ["cs" "vb"]
 :settings {:FormattingOptions {:EnableEditorConfigSupport true}
            :MsBuild {}
            :RoslynExtensionsOptions {}
            :Sdk {:IncludePrereleases true}}}
 
