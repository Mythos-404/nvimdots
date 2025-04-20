return function()
    local function text_format(symbol)
        local res = {}

        -- Helper function to add a segment
        local function add_segment(icon, content, hl_group)
            if #res > 0 then table.insert(res, { " ", "NonText" }) end
            table.insert(res, { "", "SymbolUsageRounding" })
            table.insert(res, { icon, hl_group })
            table.insert(res, { content, "SymbolUsageContent" })
            table.insert(res, { "", "SymbolUsageRounding" })
        end

        -- Add reference count if exists
        if symbol.references then
            local usage = symbol.references <= 1 and "usage" or "usages"
            local num = symbol.references == 0 and "no" or symbol.references
            add_segment("󰌹  ", ("%s %s"):format(num, usage), "SymbolUsageRef")
        end

        -- Add definition count if exists
        if symbol.definition then add_segment("󰳽  ", symbol.definition .. " defs", "SymbolUsageDef") end

        -- Add implementation count if exists
        if symbol.implementation then add_segment("󰡱  ", symbol.implementation .. " impls", "SymbolUsageImpl") end

        -- Add stacked functions indicator if needed
        local stacked_functions_content = symbol.stacked_count > 0 and ("+%s"):format(symbol.stacked_count) or ""
        if stacked_functions_content ~= "" then add_segment(" ", stacked_functions_content, "SymbolUsageImpl") end

        return res
    end

    require("symbol-usage").setup({
        implementation = { enabled = true },
        vt_position = "end_of_line",
        text_format = text_format,
    })

    require("modules.utils").gen_symbol_usage_hl()
end
