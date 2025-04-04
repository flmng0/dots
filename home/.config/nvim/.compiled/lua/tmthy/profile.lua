local profile_env_key = "TMTHY_PROFILE"
local hostname_map = {iDurian = "home"}
local or_1_ = os.getenv(profile_env_key)
if not or_1_ then
  local t_2_ = hostname_map
  if (nil ~= t_2_) then
    t_2_ = t_2_[vim.fn.hostname()]
  else
  end
  or_1_ = t_2_
end
return (or_1_ or "home")