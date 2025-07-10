if tup.getconfig("NO_FASM") ~= "" then return end

-- Build MROS Desktop Environment components
tup.rule("desktop.asm", "fasm %f %o " .. tup.getconfig("KPACK_CMD"), "desktop")
tup.rule("panel.asm", "fasm %f %o " .. tup.getconfig("KPACK_CMD"), "panel")

