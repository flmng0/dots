---@meta
error("Can't require a meta-file")

---@class brandon.SessionSource
---@field bufid integer
---@field start_line integer
---@field end_line integer | nil

---@class brandon.SessionScratches
---@field source integer
---@field changed integer
---
---@alias brandon.UpdateCallback fun(state: brandon.SessionState)

---@alias brandon.SessionStage
---| 'pending' Not yet started
---| 'thinking' Still in reasoning phase
---| 'generating' Actively generating code
---| 'finished' Finished

---@alias brandon.Context
---| brandon.FileContext
---| brandon.SymbolContext

---@class brandon.FileContext
---@field file_path string Path of the file
---@field is_file boolean Used for reflection

---@class brandon.SymbolContext
---@field file_path string File path which contains the symbol
---@field range vim.Range Range which contains the symbol
---@field is_symbol boolean Used for reflection

---@class brandon.SessionState
---@field done boolean Generation complete?
---@field stage brandon.SessionStage Stage of generation
---@field reasoning string Reasoning generated so far
---@field text string Text generated so far

---@class brandon.Session
---@field id integer
---@field system vim.SystemObj | nil vim.system object
---@field cancelled boolean Whether the prompt has been cancelled
---@field scratch brandon.SessionScratches | nil Scratch buffer IDs
---@field source brandon.SessionSource Source code information (range)
---@field state brandon.SessionState State of generation
---@field callbacks brandon.UpdateCallback[] Callbacks to invoke on update
---@field namespace integer Namespace ID
---@field extmark integer | nil Extmark ID
---@field augroup integer Autocommand group
---@field messages brandon.SessionMessage[] Messages so far
