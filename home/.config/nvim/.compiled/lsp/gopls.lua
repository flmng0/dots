local gopls = require("tmthy.mason").cmd("gopls")
return {filetypes = {"go", "gomod", "gosum"}, root_markers = {"go.mod"}, cmd = {gopls}}