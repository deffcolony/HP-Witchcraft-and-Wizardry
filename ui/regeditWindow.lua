---Create a registry explorer window
---@param prePath string Have pre-selected path
---@param dt any delta time
---@return table Window The window object
registerRegedit = function ( prePath )
    if prePath == nil then
        prePath = "game"
    end

    local regWindow = {
            testFirstFrame = true,
            -- DATA
                StringViewer={
                    itemSelectedNum = 0,
                    tableView_width = {
                        regName = 0,
                        regString = 0,
                        regInt = 0,
                    },
                    directPath = "",
                    path = prePath,
                    lastpath = "",
                    openDeletePathWindow = false,
                    openEditReghWindow = false,
                    doubleCLickTimer = 0,
                    BackHistoryNumber = 1,
                    historyPos = 0,
                    history = {
                        {
                            path = "game",
                            viewing = true,
                        }
                    }
                },
                ListScrollContainer = {scrollfirstFrame = true,},
                regEditTextBox = {focused = false},
                regNewTextbox = {focused = false},
            --
            scrollHeight = 1500,
            scrollConHeight = 500,
            firstFrame = true,
            title = "REGISTRY EXPLORER",
            padding = 0,
            pos = {x = 180, y = 200},
            size = {w = 600, h = 628},
            minSize = {w = 600, h = 460},
            startMiddle = true,
            doNotHide = false,
            clip = false,
            content = function(window, dt_w)
                function buttonIcon(path, disabled , action)
                    UiPush()
                        local ico_w, ico_h = UiGetImageSize(path)
                        local padding = 8
                        UiWindow(ico_w+padding, ico_h+padding, false)
                        UiAlign("left top")
                        if not disabled then
                            if UiBlankButton(ico_w+padding, ico_h+padding) then
                                action()
                            end
                            if UiIsMouseInRect(ico_w+padding, ico_h+padding) then
                                if not InputDown('lmb') then
                                    UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",ico_w+padding, ico_h+padding,1,1,1,1)
                                else
                                    UiImageBox("MOD/ui/TGUI_resources/textures/outline_inner_normal.png",ico_w+padding, ico_h+padding,1,1,1,1)
                                    UiTranslate(1,1)
                                end
                            else
                                UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",ico_w+padding, ico_h+padding,1,1,1,1)
                            end
                            UiColor(1,1,1,1)
                        else
                            UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",ico_w+padding, ico_h+padding,1,1,1,1)
                            UiColor(0.1,0.1,0.1,0.8)
                        end
                        UiTranslate((ico_w+padding)/2, (ico_h+padding)/2)
                        UiAlign("center middle")
                        UiImage(path)
                    UiPop()
                end
                if window.StringViewer.path == window.StringViewer.lastpath then
                else
                    window.StringViewer.tableView_width.regName = 0
                    window.StringViewer.tableView_width.regString = 0
                    window.StringViewer.tableView_width.regInt = 0
                    window.StringViewer.lastpath = window.StringViewer.path
                end
                local listKeys = ListKeys(window.StringViewer.path)
                UiTranslate(12,0)
                uic_container( UiWidth()-24, UiHeight()-148 , true, true, false, function(window)
                    window.title = "REGISTRY EXPLORER ["..window.StringViewer.path.."]"
                    local scrollHeight = 0
                    UiTranslate(6,6)
                    for i, v in ipairs(listKeys) do scrollHeight = scrollHeight + 14 end
                    UiPush()
                        local AllowBack = false
                        -- DebugWatch("BackHistoryNumber",window.StringViewer.BackHistoryNumber)
                        for i, v in pairs(window.StringViewer.history) do
                            if window.StringViewer.historyPos == i then
                                window.StringViewer.historyPos = i
                            end
                            if i > 1 then
                                AllowBack = true
                                -- DebugWatch("BackHistoryNumber path",window.StringViewer.history[#window.StringViewer.history].path)
                                window.StringViewer.BackHistoryNumber = #window.StringViewer.history
                            else
                                AllowBack = false
                            end
                        end
                        buttonIcon("./ui/TGUI_resources/textures/arrow_left.png", true, function()
                            window.StringViewer.path = window.StringViewer.history[#window.StringViewer.history-1].path
                            -- DebugPrint('go to: '.. window.StringViewer.history[#window.StringViewer.history-1].path)
                        end)
                        UiTranslate(24,0)
                        buttonIcon("./ui/TGUI_resources/textures/arrow_right.png", true, function() end)
                        UiTranslate(24,0)
                        uic_text(window.StringViewer.path,14)
                        UiTranslate(UiWidth() - 62,0)
                        UiAlign('top right')
                        uic_text(#listKeys.." Items",14)
                    UiPop()
                    UiTranslate(0,21)
                    uic_container( UiWidth()-12, UiHeight()-36 , true, false, false, function()
                        UiImageBox('./ui/TGUI_resources/textures/outline_inner_normal_dropdown.png',UiWidth(), UiHeight(),1,1)
                        if #listKeys == 0 then
                            SetInt('TGUI.regExplorer.HoveringItem',0)
                        end
                        uic_scroll_Container(window.ListScrollContainer, UiWidth(), UiHeight(), false, scrollHeight, 0, function(_, sw,sh)
                            SetBool('TGUI.regExplorer.itemHover',false)
                            if window.StringViewer.openNewReghWindow then
                                window.StringViewer.openNewReghWindow = false
                                window.focused = false
                                    table.insert(ALL_WINDOWS_OPEN ,{
                                        firstFrame = true,
                                        title = "New registry/key",
                                        -- DATA
                                            editVal = {focused = false},
                                        -- 
                                        padding = 0,
                                        pos = {x = 180, y = 200},
                                        size = {w = 400, h = 150},
                                        minSize = {w = 0, h = 0},
                                        startMiddle = true,
                                        allowResize = false,
                                        doNotHide = true,
                                        clip = false,
                                        content = function(editWindow)
                                            UiTranslate(12,0)
                                            UiPush()
                                                uic_text( 'REG: '..GetString("TGUI.regExplorer.newDirPath"), 19)
                                                UiTranslate(0,24)
                                                uic_text( "Name: ", 19)
                                                UiPush()
                                                    UiTranslate(50,0)
                                                    local textin = uic_textbox("TGUI.regExplorer.regNew", dt_w,UiWidth()-72,editWindow.editVal )
                                                UiPop()
                                                -- end
                                            UiPop()
                                            UiTranslate(0,UiHeight())
                                            UiAlign('bottom right')
                                            UiTranslate(UiWidth()-24,-12)
                                            local txtBoxDoesNotHaveCharacters = false
                                            if #textin == 0 then
                                                txtBoxDoesNotHaveCharacters = true
                                            end
                                            uic_button_func(0,dt_w, "Close", 75, 24, false, "", function()
                                                editWindow.closeWindow = true
                                            end, nil)
                                            UiTranslate(-80,0)
                                            uic_button_func(0,dt_w, "Create", 75, 24, txtBoxDoesNotHaveCharacters, "", function()
                                                SetString(GetString("TGUI.regExplorer.newDirPath").."."..GetString('TGUI.regExplorer.regNew'),' ')
                                                SetString('TGUI.regExplorer.regNew','')
                                                editWindow.closeWindow = true
                                            end, nil)
                                        end
                                    })
                                -- end)
                            end
                            function dump_reg()
                                table.insert(ALL_WINDOWS_OPEN ,{
                                    firstFrame = true,
                                    title = "Delete path",
                                    padding = 0,
                                    pos = {x = 180, y = 200},
                                    size = {w = 400, h = 130},
                                    minSize = {w = 0, h = 0},
                                    startMiddle = true,
                                    allowResize = false,
                                    doNotHide = true,
                                    clip = false,
                                    content = function(warningWindow)
                                        UiTranslate(12,0)
                                        UiPush()
                                            uic_text("WATNING: you are about to dump a registry. Are you sure?", 24)
                                            UiTranslate(0,24)
                                            uic_checkbox("I am sure to dump this registry", "TGUI.regExplorer.dumpreg" ,500 )
                                            UiTranslate(0,24)
                                            UiText('REG: '..GetString("TGUI.regExplorer.dumpPath"))
                                        UiPop()
                                        UiAlign('bottom right')
                                        UiTranslate(0,UiHeight())
                                        UiTranslate(UiWidth()-24,-12)
                                        uic_button_func(0,dt_w, "No", 60, 24, false, "", function()
                                            warningWindow.closeWindow = true
                                        end, nil)
                                        UiTranslate(-75,0)
                                        uic_button_func(0,dt_w, "Yes", 60, 24, not GetBool('TGUI.regExplorer.dumpreg'), "", function()
                                            -- ClearKey(window.StringViewer.directPath)
                                            SetBool('TGUI.regExplorer.dumpreg',false)
                                            local keys = ListKeys(GetString("TGUI.regExplorer.dumpPath"))
                                            for i,v in ipairs(keys) do
                                                ClearKey(GetString("TGUI.regExplorer.dumpPath").."."..v)
                                                DebugPrint('delete: ' .. GetString("TGUI.regExplorer.dumpPath") .. "." .. v)
                                            end
                                            warningWindow.closeWindow = true
                                        end, nil)
                                    end
                                })

                            end
                            -- CONTEXT: NOT SELECTING ITEM
                            if GetInt('TGUI.regExplorer.HoveringItem') == 0 and InputPressed('rmb') then
                                if window.StringViewer.blockedReg == false then
                                    uic_Register_Contextmenu_at_cursor({
                                        {type = "button", text="Create registry/Key here", action=function()
                                            SetString('TGUI.regExplorer.newDirPath',window.StringViewer.path)
                                            window.StringViewer.openNewReghWindow = true
                                        end},
                                        {type = "button", text="Dump current registry", action=function()
                                            SetString('TGUI.regExplorer.dumpPath',window.StringViewer.path)
                                            dump_reg()
                                        end},
                                    }, window)
                                else
                                    uic_Register_Contextmenu_at_cursor({
                                        {type = "", disabled=true ,text="Editing Disabled"},
                                    }, window)
                                end
                            end
                            -- KEYS LISTING
                            for i, v in ipairs(listKeys) do
                                scrollHeight = scrollHeight + 14
                                UiPush()
                                    if window.StringViewer.openDeletePathWindow then
                                        -- uic_button_func(0, "Open path", 100, 24, false, "", function()
                                            window.StringViewer.openDeletePathWindow = false
                                            window.focused = false
                                            table.insert(ALL_WINDOWS_OPEN ,{
                                                firstFrame = true,
                                                title = "Delete path",
                                                padding = 0,
                                                pos = {x = 180, y = 200},
                                                size = {w = 400, h = 130},
                                                minSize = {w = 0, h = 0},
                                                startMiddle = true,
                                                allowResize = false,
                                                doNotHide = true,
                                                clip = false,
                                                content = function(warningWindow)
                                                    UiTranslate(12,0)
                                                    UiPush()
                                                        UiText('Are you sure you want to delete this registry?\nYou wont be able to undo',move)
                                                        UiTranslate(0,32)
                                                        UiText('REG: '..GetString('TGUI.regExplorer.deletePath'))
                                                    UiPop()
                                                    UiAlign('bottom right')
                                                    UiTranslate(0,UiHeight())
                                                    UiTranslate(UiWidth()-24,-12)
                                                    uic_button_func(0,dt_w, "No", 60, 24, false, "", function()
                                                        warningWindow.closeWindow = true
                                                    end, nil)
                                                    UiTranslate(-75,0)
                                                    uic_button_func(0,dt_w, "Yes", 60, 24, false, "", function()
                                                        ClearKey(window.StringViewer.directPath)
                                                        warningWindow.closeWindow = true
                                                    end, nil)
                                                end
                                            })
                                        -- end)
                                    end
                                    if window.StringViewer.openEditReghWindow then
                                        window.StringViewer.openEditReghWindow = false
                                        window.focused = false
                                            table.insert(ALL_WINDOWS_OPEN ,{
                                                firstFrame = true,
                                                title = "Edit registry",
                                                -- DATA
                                                    editRegFirstFrame = true,
                                                    editVal = {focused = false},
                                                    checkBox_see_live = false,
                                                -- 
                                                padding = 0,
                                                pos = {x = 180, y = 200},
                                                size = {w = 400, h = 150},
                                                minSize = {w = 0, h = 0},
                                                startMiddle = true,
                                                allowResize = false,
                                                doNotHide = true,
                                                clip = false,
                                                content = function(editWindow)
                                                    UiTranslate(12,0)
                                                    UiPush()
                                                        if editWindow.editRegFirstFrame then
                                                            SetString('TGUI.regExplorer.regEdit', GetString( window.StringViewer.directPath))
                                                            editWindow.editRegFirstFrame = false
                                                        end
                                                        uic_text( 'REG: '..window.StringViewer.directPath, 19)
                                                        UiTranslate(0,24)
                                                        uic_text( "Value:", 19)
                                                        UiPush()
                                                        UiTranslate(50,0)
                                                        local textin = uic_textbox("TGUI.regExplorer.regEdit", dt_w,UiWidth()-72,editWindow.editVal )
                                                        UiPop()
                                                        local isNumber = not (textin == "" or textin:find("%D"))
                                                        UiTranslate(0,24)
                                                        UiPush()
                                                            UiAlign('top right')
                                                            UiTranslate(UiWidth()-24,-48)
                                                            if isNumber then
                                                                uic_text( "int", 24)
                                                            elseif not isNumber then
                                                                uic_text( "string", 24)
                                                            end
                                                        UiPop()
                                                        UiTranslate(0,0)
                                                        -- if editWindow.checkBox_see_live then
                                                        UiPush()
                                                            uic_text( "Prev:", 24)
                                                            UiTranslate(50,0)
                                                            uic_text( GetString(window.StringViewer.directPath), 24)
                                                        UiPop()
                                                        -- end
                                                    UiPop()
                                                    UiTranslate(0,UiHeight())
                                                    UiPush()
                                                        UiTranslate(12,-28)
                                                        editWindow.checkBox_see_live=uic_checkbox("Live", editWindow.checkBox_see_live, 75)
                                                    UiPop()
                                                    UiAlign('bottom right')
                                                    UiTranslate(UiWidth()-24,-12)
                                                    uic_button_func(0,dt_w, "Close", 75, 24, false, "", function()
                                                        editWindow.closeWindow = true
                                                    end, nil)
                                                    UiTranslate(-80,0)
                                                    uic_button_func(0,dt_w, "Apply", 75, 24, editWindow.checkBox_see_live, "", function()
                                                        if isNumber then
                                                            SetInt(window.StringViewer.directPath,textin*1)
                                                        elseif not isNumber then
                                                            SetString(window.StringViewer.directPath,textin)
                                                        end
                                                        editWindow.closeWindow = true
                                                    end, nil)
                                                    if editWindow.checkBox_see_live then
                                                        if isNumber then
                                                            if (type(textin) == "number") then
                                                                SetInt(window.StringViewer.directPath,textin*1)
                                                            end
                                                        elseif not isNumber then
                                                            SetString(window.StringViewer.directPath,textin)
                                                        end
                                                    end
                                                end
                                            })
                                        -- end)
                                    end
            
                                    if UiIsMouseInRect(UiWidth(),14) then
                                        UiPush()
                                            if GetBool('TGUI.regExplorer.itemHighlight') == false then
                                                UiColor(c255(255),c255(156),c255(0),1)
                                                UiRect(UiWidth(),14)
                                            end
                                        UiPop()
                                        SetInt('TGUI.regExplorer.HoveringItem',i)
                                    else
                                        if GetInt('TGUI.regExplorer.HoveringItem') == i then
                                            SetInt('TGUI.regExplorer.HoveringItem',0)
                                        end
                                    end
                                    if i == window.StringViewer.itemSelectedNum and not GetBool('TGUI.regExplorer.itemHighlight') then
                                        UiPush()
                                            UiColor(c255(65),c255(65),c255(65),0.5)
                                            UiRect(UiWidth(),14)
                                        UiPop()
                                        if InputPressed('lmb') or InputPressed("rmb") then
                                            window.StringViewer.itemSelectedNum = 0
                                        end
                                    end
                                    if GetBool('TGUI.regExplorer.itemHighlight') == true and GetString('TGUI.regExplorer.deletePath') == window.StringViewer.path.."."..v then
                                        UiPush()
                                            UiColor(c255(65),c255(65),c255(65),0.5)
                                            UiRect(UiWidth(),14)
                                        UiPop()
                                    end
                                    if UiBlankButton(UiWidth(),14) then
                                        if regExplorer_doubleclick_timer == 0 then
                                            regExplorer_doubleclick_timer = 1
                                            window.StringViewer.itemSelectedNum = i
                                        else
                                            window.StringViewer.path = window.StringViewer.path.."."..v
                                            table.insert(window.StringViewer.history ,{
                                                path = window.StringViewer.path,
                                                viewing = true,
                                            })
                                            regExplorer_doubleclick_timer = 0
                                        end
                                    end
                                    if UiIsMouseInRect(UiWidth(),14) and InputPressed('rmb') then
                                        SetString('TGUI.regExplorer.deletePath',window.StringViewer.path.."."..v)
                                        SetBool('TGUI.regExplorer.itemHighlight', true)
                                        if window.StringViewer.blockedReg == false then
                                            uic_Register_Contextmenu_at_cursor({
                                                -- {type = "", text="PATH:"..GetString('TGUI.regExplorer.deletePath')},
                                                {type = "button", text="Open registry in new window", action=function()
                                                    SetString('TGUI.regExplorer.openNew',window.StringViewer.path.."."..v)
                                                end},
                                                {type = "button", text="Edit", action=function()
                                                    window.StringViewer.directPath = window.StringViewer.path.."."..v
                                                    window.StringViewer.openEditReghWindow = true
                                                end},
                                                {type = "button", text="Delete registry", action=function()
                                                    SetString('TGUI.regExplorer.deletePath',window.StringViewer.path.."."..v)
                                                    window.StringViewer.directPath = window.StringViewer.path.."."..v
                                                    window.StringViewer.openDeletePathWindow = true
                                                end},
                                                {type="divider"},
                                                {type = "button", text="Dump selected registry", action=function()
                                                    SetString('TGUI.regExplorer.dumpPath',window.StringViewer.path.."."..v)
                                                    dump_reg()
                                                end},
                                                {type = "button", text="Dump current registry", action=function()
                                                    SetString('TGUI.regExplorer.dumpPath',window.StringViewer.path)
                                                    dump_reg()
                                                end},
                                                {type="divider"},
                                                {type = "button", text="Create registry/Key in selected registry", action=function()
                                                    SetString('TGUI.regExplorer.newDirPath',window.StringViewer.path.."."..v)
                                                    window.StringViewer.openNewReghWindow = true
                                                end},
                                                {type = "button", text="Create registry/Key in current registry", action=function()
                                                    SetString('TGUI.regExplorer.newDirPath',window.StringViewer.path)
                                                    window.StringViewer.openNewReghWindow = true
                                                end},
                                            }, window)
                                        else
                                            uic_Register_Contextmenu_at_cursor({
                                                {type = "button", text="Open registry in new window", action=function()
                                                    SetString('TGUI.regExplorer.openNew',window.StringViewer.path.."."..v)
                                                end}
                                            }, window)
                                        end
                                    end
                                    if uic_draw_contextmenu == false then
                                        SetBool('TGUI.regExplorer.itemHighlight', false)
                                    end
                                    UiDisableInput()    
                                    uic_text(v,14)
                                    local txt_w, _ = UiGetTextSize(v)
                                    if txt_w >= window.StringViewer.tableView_width.regName then
                                        window.StringViewer.tableView_width.regName = txt_w
                                    end
                                    local txt_w, _ = UiGetTextSize(GetString( window.StringViewer.path.."."..v ))
                                    if txt_w >= window.StringViewer.tableView_width.regString then
                                        window.StringViewer.tableView_width.regString = txt_w
                                    end
                                    UiPush()
                                        UiTranslate(window.StringViewer.tableView_width.regName+20,0)
                                        uic_text( GetString( window.StringViewer.path.."."..v ),14)
                                    UiPop()
                                    UiTranslate((window.StringViewer.tableView_width.regName+30)+window.StringViewer.tableView_width.regString,0)
                                    uic_text( GetInt( window.StringViewer.path.."."..v ),14)
                            -- end
                                UiPop()
                                UiTranslate(0,14)
                            end
                            if regExplorer_doubleclick_timer == 1 then
                                SetValue('regExplorer_doubleclick_timer',0,"linear",0.3)
                            end

                        end )
                    end,false)
                end, window)
                uic_container( UiWidth()-24, 100 , true, true, false, function(window)
                    UiDisableInput()
                    UiTranslate(12,12)
                    -- UiTextButton( type( GetString(GetString('TGUI.stringViewer.path')) ),UiWidth(),14)
                    local pathMatch = window.StringViewer.path
                    local bypassBlockedReg = GetBool('TGUI.regExplorer.bypass')
                    local blockedReg = false
                    -- if string.match(pathMatch, "savegame.mod", 1) then
                    if bypassBlockedReg then
                        window.StringViewer.blockedReg = false
                    else
                        if string.match(pathMatch, "game", 1)  then
                        if string.find(pathMatch, "savegame.mod", 1) then window.StringViewer.blockedReg = false else window.StringViewer.blockedReg = true end
                        else window.StringViewer.blockedReg = false end
                    end
                    if window.StringViewer.blockedReg == false then
                        UiEnableInput()
                        UiTranslate(0,4)
                        UiPush()
                            uic_text("current registry value",24)
                            UiTranslate(150,0)
                            uic_textbox(window.StringViewer.path, dt_w,UiWidth()-(208),window.regEditTextBox, "Changes the value of current registry")
                        UiPop()
                        UiTranslate(0,26)
                        -- UiPush()
                        --     uic_text("New registry",24)
                        --     UiTranslate(150,0)
                        --     uic_textbox("TGUI.regExplorer.newDir",145,window.regNewTextbox, nil, "Create a new directory" ,dt)
                        --     UiTranslate(150,0)
                        --     uic_button_func(0,dt_w, "Create a new registry",130, 24, false, "", function()
                        --         SetString(window.StringViewer.path.."."..GetString('TGUI.regExplorer.newDir'),'')
                        --         SetString('TGUI.regExplorer.newDir','')
                        --     end, nil)
                        -- UiPop()
                    else
                        blockedReg = true
                        uic_text("Editing Disabled",14)
                        window.StringViewer.editMode = false
                        UiTranslate(0,20)
                        uic_text(window.StringViewer.path,14)
                    end
                end, window)
                UiPush()
                    UiTranslate(0,12)
                    uic_checkbox("Keep editing enabled", "TGUI.regExplorer.bypass", 140, false, "Edit everywhere")
                    UiTranslate(150,0)
                    window.doNotHide=uic_checkbox("Keep Window visible", window.doNotHide, 140, false, "Keep window visible")
                UiPop()
                UiPush()
                    UiTranslate(UiWidth()-24,8)
                    UiAlign('top right')
                    uic_button_func(0, dt_w,"Open path", 100, 24, false, "", function()
                        window.focused = false
                        table.insert(ALL_WINDOWS_OPEN ,{
                            testFirstFrame = true,
                            firstFrame = true,
                            title = "Open path",
                            txtbox_regOpenPath = {focused = false},
                            padding = 0,
                            pos = {x = 180, y = 200},
                            size = {w = 350, h = 300},
                            minSize = {w = 0, h = 0},
                            startMiddle = true,
                            allowResize = false,
                            doNotHide = true,
                            clip = false,
                            content = function(openPathWindow)
                                UiPush()
                                    UiTranslate(12,0)
                                    uic_button_func(0,dt_w, "game", 150 - 24, 24, false, "", function()
                                        window.StringViewer.path = 'game'
                                        table.insert(window.StringViewer.history ,{
                                            path = "game",
                                            viewing = true,
                                        })
                                        openPathWindow.closeWindow = true
                                    end, nil)
                                    UiTranslate(0,30)
                                    uic_button_func(0,dt_w, "options", 150 - 24, 24, false, "", function()
                                        window.StringViewer.path = 'options'
                                        table.insert(window.StringViewer.history ,{
                                            path = "options",
                                            viewing = true,
                                        })
                                        openPathWindow.closeWindow = true
                                    end, nil)
                                    UiTranslate(0,30)
                                    uic_button_func(0,dt_w, "savegame", 150 - 24, 24, false, "", function()
                                        window.StringViewer.path = 'savegame'
                                        table.insert(window.StringViewer.history ,{
                                            path = "savegame",
                                            viewing = true,
                                        })
                                        openPathWindow.closeWindow = true
                                    end, nil)
                                    UiTranslate(0,30)
                                    uic_button_func(0, dt_w,"TGUI", 150 - 24, 24, false, "", function()
                                        window.StringViewer.path = 'TGUI'
                                        table.insert(window.StringViewer.history ,{
                                            path = "TGUI",
                                            viewing = true,
                                        })
                                        openPathWindow.closeWindow = true
                                    end, nil)
                                UiPop()
                                UiPush()
                                    UiTranslate(160,0)
                                    uic_text("Custom Path", 18)
                                    UiTranslate(0,20)
                                    uic_textbox("TGUI.regExplorer.openPath",dt_w, 160, openPathWindow.txtbox_regOpenPath, nil, nil )
                                    UiTranslate(0,26)
                                    local disableButton = false
                                    if #GetString('TGUI.regExplorer.openPath') == 0 then
                                        disableButton = true
                                    end

                                    uic_button_func(0, dt_w,"Open", 60, 24, disableButton, "", function()
                                        window.StringViewer.path = GetString('TGUI.regExplorer.openPath')
                                        table.insert(window.StringViewer.history ,{
                                            path = GetString('TGUI.regExplorer.openPath'),
                                            viewing = true,
                                        })
                                        openPathWindow.closeWindow = true
                                    end, nil)
                                    UiTranslate(70,0)
                                    uic_text("items in registry: "..#ListKeys(GetString('TGUI.regExplorer.openPath')),24)
                                UiPop()
                            end
                        })
                    end, nil)
                    UiTranslate(-110,0)
                    uic_button_func(0, dt_w,"Help", 100, 24, false, "", function()
                        window.focused = false
                        table.insert(ALL_WINDOWS_OPEN ,{
                            testFirstFrame = true,
                            firstFrame = true,
                            title = "Help",
                            txtbox_regOpenPath = {focused = false},
                            helpSectionsView = 1,
                            helpSections = {
                                {
                                    title = "Why cant i see savegame.mod registry",
                                    content = function( ... )
                                        function c_txt(t)
                                            local t = uic_text(t)
                                            return t.height
                                        end
                                        local t = c_txt("It is only accessible by the mod itself")
                                        UiTranslate(0,0+t)
                                        local t = c_txt("to access the registry, copy this mod to your project directory")
                                        UiTranslate(0,0+t)
                                        local t = c_txt("you need the regExplorer code in your project ui code",100)
                                        UiTranslate(0,12+t)
                                        local t = c_txt("1. Make a local copy")
                                        UiTranslate(0,0+t)
                                        local t = c_txt("2. Copy all 3 files and the ui folder. MOD/ui/TGUI_resources are all the textures")
                                        UiPush()
                                            UiTranslate(12,0+t)
                                            local t = c_txt("TGUI_main.lua")
                                            UiTranslate(0,0+t)
                                            local t = c_txt("TGUI_manager.lua")
                                            UiTranslate(0,0+t)
                                            local t = c_txt("TGUI_ui_library.lua")
                                        UiPop()
                                        -- UiTranslate(0,0+t.height)
                                        -- local t = uic_text("")
                                    end
                                }
                            },
                            padding = 0,
                            pos = {x = 180, y = 200},
                            size = {w = 600, h = 550},
                            minSize = {w = 300, h = 400},
                            startMiddle = true,
                            -- allowResize = false,
                            -- doNotHide = true,
                            clip = false,
                            content = function(Helpindow)
                                UiPush()
                                    UiTranslate(12,0)
                                    uic_button_func(0,dt_w, "savegame.mod not opening", 180, 24, false, "", function()
                                        Helpindow.helpSectionsView = 1
                                    end, nil)
                                    UiTranslate(0,30)
                                UiPop()
                                UiTranslate(219,0)
                                UiPush()
                                    UiWindow(UiWidth()-229,UiHeight()-2,true)
                                    UiImageBox('./ui/TGUI_resources/textures/outline_inner_normal_dropdown.png',UiWidth(), UiHeight(),1,1)
                                        UiWordWrap(UiWidth())
                                        local titleText = uic_text(Helpindow.helpSections[Helpindow.helpSectionsView].title, 24, 20)
                                    
                                    UiTranslate(0,0+titleText.height)
                                    Helpindow.helpSections[Helpindow.helpSectionsView].content()
                                UiPop()
                            end
                        })
                    end, nil)

                UiPop()
            end
    }

    return regWindow
end