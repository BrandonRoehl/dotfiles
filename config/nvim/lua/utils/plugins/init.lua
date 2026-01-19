-- Load custom helpers
require("utils")
-- Register custom events before setup
Utils.lazy.lazy_file()
Utils.lazy.register_custom_event("LazyDap", "LspPreEnable", "LspPostEnable")

return {}
