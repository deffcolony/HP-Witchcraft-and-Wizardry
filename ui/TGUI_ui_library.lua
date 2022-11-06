--[[

████████╗░██████╗░██╗░░░██╗██╗  ██╗░░░██╗██╗  ██╗░░░░░██╗██████╗░██████╗░░█████╗░██████╗░██╗░░░██╗
╚══██╔══╝██╔════╝░██║░░░██║██║  ██║░░░██║██║  ██║░░░░░██║██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚██╗░██╔╝
░░░██║░░░██║░░██╗░██║░░░██║██║  ██║░░░██║██║  ██║░░░░░██║██████╦╝██████╔╝███████║██████╔╝░╚████╔╝░
░░░██║░░░██║░░╚██╗██║░░░██║██║  ██║░░░██║██║  ██║░░░░░██║██╔══██╗██╔══██╗██╔══██║██╔══██╗░░╚██╔╝░░
░░░██║░░░╚██████╔╝╚██████╔╝██║  ╚██████╔╝██║  ███████╗██║██████╦╝██║░░██║██║░░██║██║░░██║░░░██║░░░
░░░╚═╝░░░░╚═════╝░░╚═════╝░╚═╝  ░╚═════╝░╚═╝  ╚══════╝╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░

Name: TGUI UI Library
Version: 0.8
Author: AlexVeeBee
Credit: iaobardar (Help with the dropdown menu being on top)
How it works:
Requirements:
How to import:
]]
function init()
    nextid = 1
    currentid = 0
    CreatedWindows = {
    }
    MasterStyles = {
        borderPadding = 1,
        UiImageBox = {
            UICCONTAINER = {
                pathimgeInner = tgui_ui_assets..'/textures/outline_inner_normal.png',
                pathimgeOutter = tgui_ui_assets..'/textures/outline_outer_normal.png',
                pathimgeTab = tgui_ui_assets..'/textures/outline_outer_tab_container.png',
                BorderWidth = 1,
                BorderHeight = 1,
            },
            UISLIDER = {
                -- pathimageSliderBox = 
            }
        }
    }
end
errorMessages = {
    missing = {
    },
    WindowAlerts = {
        wrongType = "window is not a table",
        wrongType_example = "Make sure you have the parameter as the window param.\nexample: ",
    }
}

---Register mod
---@param name string
---@param options function
function TGUI_register_mod(name, options) 
    -- local itemNumber = 1
    
    -- DebugPrint('NAME: '..name)
    -- -- DebugPrint('ADDING TO LIST OF REGISTERED LIST: '..name)
    SetString('TGUI.register.mod.name',name)
    if type(options)=="function" then
        DebugPrint('function setting')
        local optionsToString_pre = {
            options
        }
        local optionsToString = tostring( optionsToString_pre )
        DebugPrint(optionsToString)
        SetString('TGUI.register.mod.options',optionsToString)
    end
    -- local RegisteredMods = ListKeys('TGUI.register.mod')

    -- for k, v in ipairs(RegisteredMods) do
    --     itemNumber = itemNumber + 1
    -- end
    -- itemNumber
    -- if not HasKey('TGUI.register.mod') then
    --     SetString('TGUI.register.mod.name',name)
    -- end

    -- if HasKey('TGUI.find.mod') then
        -- DebugPrint('[DEBUG]: This mod is already registered')
    -- else
        -- DebugPrint('[DEBUG]: Regestering')
        -- DebugPrint('[DEBUG]: Registered')
    -- end
end

function tick( ... )
    -- DebugWatch('nextid',nextid)
    -- DebugWatch('currentid',currentid)
end

local showDropDown,id_open = false, 0

---DEBUG: enable checkbox hitbox
uic_debug_checkHit = false

---Tooltip
uic_tooltip_text,uic_tooltip_enabled = "-",false
---Tooltip hover
uic_tooltip_hover_timer,uic_tooltip_hover_id = 1,0
---context menu
uic_draw_contextmenu,uic_contextMenu_getCursor,uic_isCursorInside = false, false, false
    --  {
        --      w=0,h=0,x=0,y=0,
        --      c = {

        --      }
        --      d = {

        --      }
        --  }
local draw_dropdown,draw_dropdown_contents,draw_dropdown_extra,draw_dropdown_pos = false, {}, {}, {x=0,y=0,w=0,h=0, posCalc={x=0,y=0}}
local draw_tooltip, draw_tooltip_text, draw_tooltip_pos, draw_tooltip_params  = false, "TEST TEST", {x=200,y=200,w=20,h=20, posCalc={x=0,y=0}, mouse= { x = 0, y = 0 }}, {popInTimer = 0}

uic_contextMenu_contents = {
    submenuItems = {
    },
    items = {
    }
}
-- function DrawAllWindows()
--     for i=1, #CreatedWindows do
--         UiPush()
--             UiEnableInput()
--             UiWindow(CreatedWindows[i]["size"].w ,CreatedWindows[i]["size"].h ,CreatedWindows[i]["clip"])
--             UiPush()
--                 UiAlign("top left")
--                 UiColor(c255(160), c255(160), c255(160),c200(128))
--                 UiRect(CreatedWindows[i]["size"].w ,CreatedWindows[i]["size"].h)
--                 UiFont("MOD/ui/Fonts/arialnovabd.ttf", 12)
--                 UiTranslate(16,8)
--                 UiColor(1,1,1,1)
--                 UiText(CreatedWindows[i]["title"])
--             UiPop()
--             -- UiTranslate(0,32)
--             -- UiWindow(width,height-32,clip)
--             -- -- UiRect(UiWidth(),padding)
--             -- -- UiRect(padding,UiHeight())
--             -- UiFont("MOD/ui/Fonts/arialnova.ttf", 15)
--             -- UiTranslate(padding,padding)
--             -- UiWindow(width-padding/2*4,height-32+padding/2*-4,clip)
--             -- -- UiColor(1,0,0,1)
--             -- -- UiRect(UiWidth(),UiHeight())
--             -- UiColor(1,1,1,1)
--             -- UiPush()
--             --     UiAlign("top left")
--             --     content()
--             -- UiPop()
--         UiPop()
--     end
-- end

-- 

uic_containers = {};
uic_ui = {};

function tick( ... )
    -- DebugWatch('showDropDown',showDropDown)
    -- DebugWatch('id_open',id_open)
end
---Convert to float 0 to 1 from any range
---@param c integer range of 0 to any
---@param n integer range
---@return float c Range of 0 to 1 float
function cRangeAny(c, n)
    return c/n
end

---Convert to float 0 to 1 from 255 range
---@param c integer range of 0 to 255
---@return float c Range of 0 to 1 float
function c255(c)
    return c/255
end
---Convert to float 0 to 1 from 200 range
---@param c integer range of 0 to 200
---@return float c Range of 0 to 1 float
function c200(c)
    return c/200
end

---Convert to float 0 to 1 from 100 range
---@param c integer range of 0 to 100
---@return float c Range of 0 to 1 float
function c100(c)
    return c/100
end
winfake = {
    tableColumnNames = {
        {label="1",w=0}, {label="2",w=0},
        {label="3",w=0}, {label="4",w=0},
        {label="5",w=0}, {label="6",w=0},
        {label="7",w=0}, {label="8",w=0},
    }
}

---❗ [OBSOLETE] ❗
-------
---- this function will be removed in the future
---- use uic_drawContextMenu instead
--
---This function must be called after all of the ui
---@deprecated
function uic_tooltip()
    -- UiPush()
    --     if not uic_tooltip_enabled then
    --         mouse_x,mouse_y = UiGetMousePos()
    --     end
    --     if uic_tooltip_enabled then
    --         UiFont(tgui_ui_assets.."/Fonts/TAHOMABD.TTF", 12)
    --         local t_text_w,t_text_h = UiGetTextSize(uic_tooltip_text)
    --         UiAlign('top left')
    --         UiTranslate(mouse_x,mouse_y +20)
    --         UiImageBox(tgui_ui_assets..'/textures/hint.png',t_text_w,t_text_h,1,1)
    --         UiColor(c255(136),c255(84),c255(30),1)
    --         UiText(uic_tooltip_text)
    --     end
    -- UiPop()
end

_globalContextMenu_isCursorInside = false;

local _itemsHovering = 0
function uic_drawContextMenu()
    if uic_draw_contextmenu then
        UiEnableInput()
        UiFont(tgui_ui_assets.."/Fonts/TAHOMA.TTF", 15)
        UiAlign('top left')
        UiPush()
        for it, c in pairs(uic_contextMenu_contents.items) do
            if c.getCursor == nil then
                local cursor_x, cursor_y = UiGetMousePos()
                if type(c.x_calc) == "number" then
                    c.x = math.floor(cursor_x)+c.x_calc
                else
                    c.x = math.floor(cursor_x)
                end
                if type(c.y_calc) == "number" then
                    c.y = math.floor(cursor_y)+c.y_calc
                else
                    c.y = math.floor(cursor_y)
                end
                c.getCursor = false
            end
            local aling_y, align_x = "top", "left"
            if c.Cuttin_alignRight then
                align_x = "right"
            end
            if c.Cuttin_alignBottom then
                aling_y = "bottom"
            end
            UiTranslate(c.x,c.y)
            UiAlign(aling_y .. " " .. align_x) 
            UiPush()
                if c.h >= UiHeight() then
                    UiWindow(c.w,UiHeight()-2,false)
                else
                    UiWindow(c.w,c.h+4,false)
                end
                UiAlign("top left")
                if UiBlankButton(c.w,c.h) then end
                if c.h >= 4 then
                    if c.itemsHovering == nil then
                        c.itemsHovering=0
                    end
                    UiPush()
                        UiColor(c255(162),c255(162),c255(162),1)
                        UiRect(c.w+24,UiHeight()+2)    
                    UiPop()
                    UiPush()
                        UiColor(1,1,1,1)
                        UiImageBox(tgui_ui_assets..'/textures/outline_outer_normal.png',c.w+24,UiHeight()+2,1,1)
                    UiPop()
                    UiPush()
                        UiTranslate(0,3)
                        for i, v in ipairs(c.c) do
                            local txt_w, _ = UiGetTextSize(v.text)
                            if c.itemHover == nil then c.itemHover = 0 end
                            if c.hoverOnce == nil then c.hoverOnce = false end
                            if v.height == nil then v.height = 0 end
                            if not v.widthChecked then
                                if uic_draw_contextmenu_row then
                                    c.w = c.w + txt_w
                                else
                                    if c.w < txt_w then c.w = txt_w 
                                        v.widthChecked = true
                                    else v.widthChecked = false
                                    end
                                end
                            end
                            -- UI RENDER 
                            if(not UiIsMouseInRect(c.w,24))then
                                if v.type == "button" or v.type == "toggle" or v.type == "submenu"then
                                    v.IsMouseHovering = false
                                end
                            end
                            if(UiIsMouseInRect(c.w+24,24)) then
                                if v.type == "button" or v.type == "toggle" or v.type == "submenu"then
                                    v.IsMouseHovering = true
                                    if not c.keepSubmenuOpen then c.itemHover = i end
                                    UiPush()
                                        if(not v.disabled) then
                                            UiColor(c255(255),c255(156),c255(0),1)
                                        else
                                            UiColor(c255(55),c255(55),c255(55),0.21)
                                        end
                                        UiTranslate(1,0)
                                        UiRect(c.w-2+24,24)
                                    UiPop()
                                    UiColor(c255(24),c255(24),c255(24),1)
                                    if v.type == "button" or v.type == "toggle" then
                                        c.hoverOnce = false
                                        c.keepSubmenuOpen = false
                                    end
                                    if v.disabled then
                                        if v.type == "submenu" then
                                            c.hoverOnce = false
                                            c.keepSubmenuOpen = false
                                        end
                                    end
                                end
                            end
                            -- uic_text(_itemsHovering)
                            if not v.disabled then
                                UiPush()
                                    UiColor(1,1,1,1)
                                    -- UiTranslate(24,0)
                                    if UiBlankButton(c.w+24,24) then
                                        if v.type == "button" or v.type == "toggle" then
                                            if v.action == nil then
                                                error("missing action variable from table `... action = function() --Code end`")
                                                uic_contextMenu_contents.items={}
                                                uic_draw_contextmenu = false
                                            end
                                        end
                                        if v.type == "button" then
                                            v.action()
                                            uic_contextMenu_contents.items={}
                                            uic_draw_contextmenu = false
                                        end
                                        if v.type == "toggle" then
                                            v.action()
                                            if type(v.key) == "string" then
                                                SetBool(v.key,not GetBool(v.key))
                                            end
                                            uic_contextMenu_contents.items={}
                                            uic_draw_contextmenu = false
                                        end
                                    end
                                    if v.type == "submenu" then
                                        if v.hoverOnce == nil then v.subButtonId = i ; v.hoverOnce = false end
                                        if v.submenuH == nil then  v.submenuH = c.h end
                                        if UiIsMouseInRect(c.w+24,24) then
                                            if _itemsHovering == 1 and c.hoverOnce == false then
                                                table.insert(uic_contextMenu_contents.items, {
                                                    w=200,h=0,x=c.w+24,y=v.submenuHeightPos,useSubemenu=true,getCursor=false,
                                                    c = v.items
                                                })
                                                c.hoverOnce = true
                                                c.keepSubmenuOpen = true
                                            end
                                        end
                                        if UiIsMouseInRect(c.w+24,24) and c.hoverOnce == true then
                                            if c.itemHover == v.subButtonId  then
                                            else
                                                c.hoverOnce = false
                                                c.keepSubmenuOpen = false
                                            end
                                        end
                                    end
                                UiPop()
                            end
                            if v.type == "toggle" then
                                if type(v.key) == "string" then if GetBool(v.key) then
                                    UiPush()
                                        UiAlign('center middle')
                                        UiTranslate(12,12)
                                        if(not v.disabled) then
                                        else
                                            UiColor(c255(55),c255(55),c255(55),1)
                                        end
                                        UiImage(tgui_ui_assets..'/textures/checkmark.png')
                                    UiPop()
                                end end
                            end
                            if v.type == 'divider' then
                                UiPush()
                                    UiTranslate(24,0)
                                    if uic_debug_contextMenu then
                                    UiPush()
                                        UiColor(1,0,0,1)
                                        UiRect(c.w-2,8)
                                    UiPop()
                                    end
                                    UiTranslate(1,3)
                                    uic_divider(c.w-2,false)
                                UiPop()
                            end
                            if v.type == "submenu" then
                                UiPush()
                                    UiAlign('center middle')
                                    UiTranslate(c.w+12,12)
                                    if(not v.disabled) then
                                    else
                                        UiColor(c255(55),c255(55),c255(55),1)
                                    end
                                    UiImage(tgui_ui_assets..'/textures/arrow_right.png')
                                UiPop()
                            end
                            
                            UiPush()
                                UiTranslate(24,0)
                                if(v.disabled ) then UiColor(c255(24),c255(24),c255(24),1) end
                                uic_text(v.text, 24)
                            UiPop()
                            UiColor(1,1,1,1)
                            if(v.disabled ) then
                                UiPush()
                                    UiColor(0.1,0.1,0.1,0.4)
                                    UiTranslate(25,1)
                                    uic_text(v.text, 24)
                                UiPop()
                            end
                            UiTranslate(0,v.height)
                            -- END UI RENDER
                        end
                    UiPop()
                    if UiIsMouseInRect(c.w+24,c.h+2) then
                        _globalContextMenu_isCursorInside = true
                        c.isCursorInside = true
                        SetBool('TGUI.contextMenu.isCursorInside', true)
                    end
                    if not UiIsMouseInRect(c.w+24,c.h+2) then
                        c.isCursorInside = false
                    end

                end
            UiPop()
            for i, v in pairs(c.c) do
                if v.type == "submenu" and v.submenuHeightPos == nil then
                    v.submenuHeightPos = c.h
                end
                if v.heightCheck == nil then
                    if v.type == "button" or v.type == "toggle" or v.type == "submenu" then
                        c.h = c.h + 24
                        v.height = 24
                    elseif v.type == "divider" then
                        c.h = c.h + 8
                        v.height = 8
                    else
                        c.h = c.h + 24
                        v.height = 24
                    end
                    v.heightCheck = true
                else
                    if c.h == 0 then for i, v in ipairs(c.c) do
                        v.heightCheck = nil
                    end end
                end
            end
        end
        UiPop()
        UiPush()
        
        _itemsHovering = 0
        for it, c in pairs(uic_contextMenu_contents.items) do
            UiPush()
            UiTranslate(-2,-2)
            UiTranslate(c.x,c.y)
            -- UiColor(1,1,1,0.3)
            -- UiRect(c.w+26,c.h+4)
            if c.useSubemenu == nil then
                if not UiIsMouseInRect(c.w+26,c.h+4) then
                    if _globalContextMenu_isCursorInside == false then
                        if InputDown('lmb') then uic_draw_contextmenu = false end
                        if InputDown('rmb') then uic_draw_contextmenu = false end
                    end
                end
            else
                pcall(function ()
                    local keepSubmenuOpen = uic_contextMenu_contents.items[it-1].keepSubmenuOpen
                    if keepSubmenuOpen == false or keepSubmenuOpen == nil then
                        table.remove(uic_contextMenu_contents.items, it)
                    end
                end)
            end
            for i, v in ipairs(c.c) do
                if v.IsMouseHovering == true then
                    _itemsHovering = _itemsHovering + 1
                end
            end
            -- if last == i then
            -- end
            UiPop()
            UiPush()
            local PosX, PosY = c.x,c.y
            -- DebugPrint(last)
            if c.checkIfCutting == nil then
                if UiWidth()-c.w-40 < PosX then
                    c.Cuttin_alignRight = true
                    -- c.x = c.x - c.w-24
                end
                if UiHeight()-c.h-40 < PosY then
                    -- c.Cuttin_alignBottom = true
                    c.y = c.y - c.h
                    if c.y < 0 then
                        c.y = 0
                    end
                end
                c.checkIfCutting = false
            end
            UiPop()
        end
        UiPop()
        _globalContextMenu_isCursorInside = false
    else
        uic_contextMenu_contents.items = {}
    end
    if draw_dropdown then
        local c = draw_dropdown_pos
        if c.getCursor == true then
            local cursor_x, cursor_y = UiGetMousePos()
            if type(c.posCalc.x) == "number" then
                c.x = math.floor(cursor_x)+c.posCalc.x
            else
                c.x = math.floor(cursor_x)
            end
            if type(c.posCalc.y) == "number" then
                c.y = math.floor(cursor_y)+c.posCalc.y
            else
                c.y = math.floor(cursor_y)
            end
            c.getCursor = false
        end
        UiPush()
            UiAlign('left top')
            UiTranslate(c.x,c.y)
            -- uic_text("lol",24, 6)
            -- DebugWatch('dropdown open'..window.tooltipId,window.open)
            local he = 24
            local scroll_width = 24
            local bu_he = 18 
            w,dropdown_height = he,bu_he
            -- if window.firstFrame then
                 for i, v in pairs(draw_dropdown_contents) do
                    w,dropdown_height = he,bu_he
                    c.h = (dropdown_height*i)
                end

            --     window.firstFrame = false
            -- end
            UiButtonImageBox("MOD",1,1,1,1,1,0)
            if draw_dropdown then
                -- UiWindow(c.w,he+dropdown_height+3,true)
                UiPush()
                    if c.goUp then
                        UiAlign('left top')
                        UiWindow(c.w,0,false)
                        UiTranslate(0,-c.h-he-3)
                        UiPush()
                            -- UiTranslate(0,he)
                            if not UiIsMouseInRect(c.w,he+c.h) then
                                if InputDown('lmb') then draw_dropdown = false end
                                if InputDown('rmb') then draw_dropdown = false end
                            end
                        UiPop()
                    else
                        UiPush()
                            UiTranslate(0,-26)
                            -- UiRect(c.w,he+c.h+4)
                            if not UiIsMouseInRect(c.w,he+c.h+4) then
                                if InputDown('lmb') then draw_dropdown = false end
                                if InputDown('rmb') then draw_dropdown = false end
                            end
                        UiPop()
                    end
                    -- UiTranslate(0,he+1)
                    UiImageBox(tgui_ui_assets.."/textures/outline_outer_special_dropdown.png",c.w,c.h+2,1,1,1,1)
                    if goUp then
                        UiAlign('left top')
                    end
                    UiTranslate(0,1)
                    for i, v in pairs(draw_dropdown_contents) do
                        UiColor(1,1,1,1)
                        if UiIsMouseInRect(c.w-scroll_width,bu_he) then
                            UiColor(c255(24),c255(24),c255(24),1)
                            UiPush()
                                UiTranslate(1,0)
                                UiColor(c255(255),c255(156),c255(0),1)
                                UiRect(c.w-2-scroll_width,bu_he)
                            UiPop()
                        end
                        UiPush()
                            -- UiTranslate(0,bu_he/2)
                            -- UiAlign('left middle')
                            -- UiText(items[i])
                            UiDisableInput()
                            uic_text(v.text,bu_he,14)
                            -- UiTextButton(v.text,TXT_w,bu_he)
                        UiPop()
                        if UiBlankButton(c.w-scroll_width,bu_he) then
                            draw_dropdown = false
                            SetString(draw_dropdown_extra.key..".dropdwon.text",v.text)
                            SetString(draw_dropdown_extra.key..".dropdwon.val",v.keyVal)
                        end
                        -- UiPush()
                        --     UiTranslate(0,-he)
                        --     UiRect(width,dropdown_height+he)
                        -- UiPop()
                        UiColor(1,1,1,1)
                        UiTranslate(0,bu_he)
                        if v.heightCheck == nil then
                            c.h = c.h*i+1
                            v.heightCheck = true
                        end
                    end
                UiPop()
            end
        UiPop()
    else
        draw_dropdown_contents = {}
    end
    if draw_tooltip then
        UiPush()
            UiFont(tgui_ui_assets.."/Fonts/TAHOMABD.TTF", 12)
            local t_text_w,t_text_h = UiGetTextSize(draw_tooltip_text)
            UiAlign('top left')
            UiTranslate(draw_tooltip_pos.mouse.x,draw_tooltip_pos.mouse.y +20)
            UiImageBox(tgui_ui_assets..'/textures/hint.png',t_text_w,t_text_h,1,1)
            UiColor(c255(136),c255(84),c255(30),1)
            UiText(draw_tooltip_text)
        UiPop()
    else
        local mouse_x,mouse_y = UiGetMousePos();
        draw_tooltip_pos.mouse.x = mouse_x;
        draw_tooltip_pos.mouse.y = mouse_y;
        draw_tooltip_text = ""
    end
end

---Creates a fake window
---@param width integer Width of the window
---@param height integer Height of the window
---@param clip boolean Clip content outside window. Default is false
---@param title string Title of the window
---@param padding integer Adds padding to all sides of the window
---@param content function function: Ui
function UiCreateWindow(width,height,clip,title,padding,content)
    UiPush()
        UiEnableInput()
        UiWindow(width ,height ,clip)
        UiPush()
            UiAlign("top left")
            UiImageBox(tgui_ui_assets..'/textures/background_fake_window.png',width ,height,4,4)
            UiFont(tgui_ui_assets.."/Fonts/TAHOMABD.TTF", 12)
            UiTranslate(16,8)
            UiColor(1,1,1,1)
            UiText(title)
        UiPop()
        UiTranslate(0,32)
        UiWindow(width,height-32,clip)
        -- UiRect(UiWidth(),padding)
        -- UiRect(padding,UiHeight())
        UiFont(tgui_ui_assets.."/Fonts/TAHOMA.TTF", 15)
        UiTranslate(padding,padding)
        UiWindow(width-padding/2*4,height-32+padding/2*-4,clip)
        -- UiColor(1,0,0,1)
        -- UiRect(UiWidth(),UiHeight())
        UiColor(1,1,1,1)
        UiPush()
            UiAlign("top left")
            content()
        UiPop()
    UiPop()
end

---Create a hitbox for tooltips to display
---@param w integer with
---@param h integer height
---@param text string text of the tooltip
---@param dt any draw param
function uic_tooltipHitbox( w,h, active ,text, dt )
    -- DebugPrint(draw_tooltip_params.popInTimer)
    UiPush()
    if active then
        if UiIsMouseInRect(w, h) then
            draw_tooltip_params.popInTimer = draw_tooltip_params.popInTimer + dt/0.1
            if draw_tooltip_params.popInTimer > 5 then
                draw_tooltip_params.popInTimer = 5
                draw_tooltip = true
            end
            draw_tooltip_text = text;
        else
            if draw_tooltip == true then
                -- draw_tooltip_params.popInTimer = 0
                -- draw_tooltip = false
            end
        end
    end
    UiPop()
end

--[[ CONTAINERS ]]

---Create a container widget
---@note There is a `UiTranslate(0,h)` at the end of the function
---@param width integer Width of the container
---@param height integer Height of the container
---@param clip boolean Clip content outside window. Default is false
---@param border boolean Adds the border to the container
---@param content function function: UI
---@param ectraContent any? Additional content to be called to the container
---@param style table? Customize the container
-- `Autotranslate`Default: "Y" -- directions: "X" or "Y". Letters must be capitalized
-- `HaveUiWindow`Default: true
-- `LabelText`Default: "" -- left empty for no label text
-- `LabelFont`Default: LabelFont = tgui_ui_assets.."/Fonts/TAHOMABD.TTF",
function uic_container(width,height,clip,border,makeinner,content, ectraContent, style)
    if style == nil then
        style = {
            Padding = 0,
            BorderPadding = 1,
            Autotranslate = "Y",
            LabelText = nil,
            LabelFont = tgui_ui_assets.."/Fonts/TAHOMABD.TTF",
        }
    else
        if style.Padding == nil then style.Padding = 0 end
        if style.BorderPadding == nil then style.BorderPadding = 1 end
        if style.Autotranslate == nil then style.Autotranslate = "Y" end
        if style.LabelText == nil then style.LabelText = nil end
        if style.LabelFont == nil then style.LabelFont = tgui_ui_assets.."/Fonts/TAHOMABD.TTF" end
    end

    UiPush()
        if border then
            if type(style.LabelText) == "nil" then
                if makeinner then
                    UiImageBox(tgui_ui_assets..'/textures/outline_inner_normal.png',width,height,1,1)
                else
                    UiImageBox(tgui_ui_assets..'/textures/outline_outer_normal.png',width,height,1,1)
                end
            else
                UiImageBox(tgui_ui_assets..'/textures/outline_outer_tab_container.png',width,height,1,1)
                UiPush()
                    UiImageBox(tgui_ui_assets..'/textures/line_white.png',8,1,0,0)
                    UiTranslate(8, 0)
                    UiPush()
                        UiTranslate(0, -12)
                        local t = uic_text(style.LabelText, 24, 13, { font = style.LabelFont });
                    UiPop()
                    UiTranslate((t.width), 0)
                    UiImageBox(tgui_ui_assets..'/textures/line_white.png',(width-t.width-9),1,0,0)
                UiPop()
            end
        end
        
        -- UiWindow(width-2,height-2,clip,true) 
        UiTranslate(style.BorderPadding, style.BorderPadding);
        UiTranslate(style.Padding, style.Padding);
        UiWindow((width+(style.BorderPadding*2)-(style.Padding*2)-3), (height+(style.BorderPadding*2)-(style.Padding*2)-3), clip, clip)
        -- if (clip) then
        -- end
        -- UiTranslate(1,1)
        -- UiTranslate(1,1)
        -- UiWindow(width,height,false)
        UiPush()
            content(ectraContent)
        UiPop()    
    UiPop()    
    if height-style.Padding < style.Padding then
        UiPush()
            UiColor(1, 0, 0, 0)
            local t = uic_text("Height too small for padding", 24, 18)
            UiColor(0.4, 0, 0, 0.8)
            UiRect(width, t.height)
        UiPop()
        UiPush()
            uic_text("Height too small for padding", 24, 18)
        UiPop()
    end
    if style.Autotranslate == "Y" then
        UiTranslate(0,height)
    end
    if style.Autotranslate == "X" then
        UiTranslate(width,0)
    end
end

---@param w integer width of the menubar
---@param items table What should show in the menubar `{title = "Text", contents = {TGUI.contextmenu format}}`
---@contextmenu format: `{type = "(empty is just text)"|"divider"|"button"|"toggle"|"submenu"`(to insert items do ,`items = {--[[TGUI.contextmenu format]]}`)`}`
---@param extraContent any? Additional content to be called to the menubar
---@param customization table? `table` customize the menubar
---- `showBorder` Default: true
---- `AllBorders` Default: false
---- `borderTop` Default: true
---- `borderBottom` Default: true
---- `textPadding` Default: 4 - padding is located left and right of the text
function uic_menubar(w, items ,extraContent , customization)
    if customization == nil then
        customization = {
            showBorder = true,
            AllBorders = false,
            borderTop = true,
            borderBottom = true,
            textPadding = 4
        }
    end
    if type(customization) == "table" then
        if customization.showBorder == nil then customization.showBorder = true end
        if customization.AllBorders == nil then customization.AllBorders = false end
        if customization.textPadding == nil then customization.textPadding = 4 end
        if customization.borderTop == nil then customization.borderTop = true end
        if customization.borderBottom == nil then customization.borderBottom = true end
    else
        error("customization is not a table type")
    end
    UiPush()
        UiPush()
            for i, v in ipairs(items) do
                if type(v.title) == "string" then
                    v.label = v.title
                end
                UiAlign('top left')
                UiFont(tgui_ui_assets..'/Fonts/TAHOMA.TTF',13)
                UiColor(0,0,0,0)
                local t = uic_text(v.label, 24, 13)
                UiColor(1,1,1,1)
                if UiIsMouseInRect(t.width+customization.textPadding*2,t.height) then
                    UiPush()
                        UiColor(c255(255),c255(156),c255(0),1)
                        UiRect(t.width+customization.textPadding*2,t.height)
                    UiPop()
                    UiColor(0,0,0,1)
                end
                UiPush()
                    UiTranslate(customization.textPadding,0)
                    uic_text(v.label, 24, 13)
                UiPop()
                if UiBlankButton(t.width+customization.textPadding*2,t.height) then
                    UiPush()
                        UiWindow(w,t.height,true)
                        local cursor_x, cursor_y = UiGetMousePos()
                        if uic_draw_contextmenu == false then
                            uic_Register_Contextmenu_at_cursor(v.contents,-cursor_x,-cursor_y+24)
                            SetInt('TGIO.menubar.itemHover', i)
                        end
                    UiPop()
                end
                -- if uic_draw_contextmenu then
                --     if GetInt('TGIO.menubar.itemHover') == not i then
                --         if UiIsMouseInRect(t.width+customization.textPadding*2,t.height) then
                --             UiPush()
                --             UiWindow(w,t.height,true)
                --             local cursor_x, cursor_y = UiGetMousePos()
                --             uic_Register_Contextmenu_at_cursor(v.contents,-cursor_x,-cursor_y+24)
                --             SetInt('TGIO.menubar.itemHover', i)
                --         end

                --         UiPop()
                --     end
                -- end
                if uic_debug_show_hitboxes_menubar then
                    UiPush()
                        UiColor(1,0,1,1)
                        UiRect(t.width,t.height)
                    UiPop()
                end
                UiTranslate(t.width+customization.textPadding*2,0)
            end
        UiPop()
        if customization.showBorder then
            if not customization.AllBorders then
                if customization.borderBottom then
                    UiPush()
                        UiTranslate(0,23)
                        UiImageBox(tgui_ui_assets..'/textures/line_dark.png',w,1,0,0)
                    UiPop()
                end
                if customization.borderTop then
                    UiImageBox(tgui_ui_assets..'/textures/line_white.png',w,1,0,0)
                end
            else
                UiImageBox(tgui_ui_assets..'/textures/outline_outer_normal.png',w,24,1,1)
            end
        end
    UiPop()
end
---@alias ScrollContainerStyling # Table ScrollContainerStyling
---| "clip" # Default: false -- Whether to clip the content or not | Teardown api description: Clip content outside window

---Make a scroll container
---@param window table The root window
---@param w integer width of the scroll area
---@param h integer height of the scroll area
---@param border boolean whether to have the border or not
---@param scroll_height integer How much this container can be scrolled
---@param scroll_width integer How much this container can be scrolled
---@param content function Content to the scroll area container
---@param style? ScrollContainerStyling Style the scroll area 
---@param extraContent? any Additional content to be called to the container
function uic_scroll_Container(window,w,h,border,scroll_height, scroll_width, content, style, extraContent, customization)
    if style == nil then style = {clip = false} end
    if style.clip == nil then style.clip = false end
    -- if style.scrollbar == nil then style.scrollbar = true end
    if window.scrollfirstFrame == nil or window.scrollfirstFrame == true  then
        window.scrollXPos = 0
        window.scrollYPos = 0
        --
        window.mouse_pos_thum = {}
        window.pos_thum = {}
        --
        window.mouse_pos_thum.lastMouse = { x = 0, y = 0 }
        window.mouse_pos_thum.mouse = { x = 0, y = 0 }
        window.mouse_pos_thum.deltaMouse = { x = window.mouse_pos_thum.mouse.x - window.mouse_pos_thum.lastMouse.x, y = window.mouse_pos_thum.mouse.y - window.mouse_pos_thum.lastMouse.y }            
        window.mouse_pos_thum.mouseMoved = window.mouse_pos_thum.deltaMouse.x ~= 0 or window.mouse_pos_thum.deltaMouse.y ~= 0
        --
        window.pos_thum.lastMouse = { x = 0, y = 0 }
        window.pos_thum.mouse = { x = 0, y = 0 }
        window.pos_thum.deltaMouse = { x = window.pos_thum.mouse.x - window.pos_thum.lastMouse.x, y = window.pos_thum.mouse.y - window.pos_thum.lastMouse.y }            
        window.pos_thum.mouseMoved = window.pos_thum.deltaMouse.x ~= 0 or window.pos_thum.deltaMouse.y ~= 0
        --
        window.scrollfirstFrame = false
    end

    local scrollY = window.scrollYPos
    local scrollX = window.scrollXPos
    UiPush()
        if border then
            UiImageBox(tgui_ui_assets..'/textures/outline_outer_normal.png',w,h,1,1)
        end
        UiPush()
            local max_scroll_Y = 0
            local max_scroll_X = 0
            if scroll_width > w then
                scroll_height = scroll_height + 17
                max_scroll_Y = max_scroll_Y + 17
            end
        
            if scroll_height > h then
                max_scroll_Y = h - scroll_height else
                max_scroll_Y = 0
            end
            if UiIsMouseInRect(w,h) and not InputDown('shift') then
                local scrollY = InputValue('mousewheel')*10
                local scrollTest = 0
                scrollTest = window.scrollYPos + scrollY
                if window.scrollYPos >= 0 then
                    window.scrollYPos = 0
                end
                if window.scrollYPos <= max_scroll_Y then
                    window.scrollYPos = max_scroll_Y
                end
                if scrollY > -1 then
                    if scrollTest < 1 then
                        window.scrollYPos = window.scrollYPos + scrollY
                    else
                        window.scrollYPos = 0
                    end
                end
                if scrollY < 1 then
                    if scrollTest+1 > max_scroll_Y then
                        window.scrollYPos = window.scrollYPos + scrollY
                    else
                        window.scrollYPos = max_scroll_Y
                    end
                end
            else
                if window.scrollYPos >= 0 then
                    window.scrollYPos = 0
                end
                if window.scrollYPos <= max_scroll_Y then
                    window.scrollYPos = max_scroll_Y
                end
            end
            if scroll_width > w then
                max_scroll_X = w - scroll_width else
                max_scroll_X = 0
            end
            if UiIsMouseInRect(w,h) and InputDown('shift') then
                local scrollX = InputValue('mousewheel')*10
                local scrollTest = 0
                scrollTest = window.scrollXPos + scrollX
                if window.scrollXPos >= 0 then
                    window.scrollXPos = 0
                end
                if window.scrollXPos <= max_scroll_X then
                    window.scrollXPos = max_scroll_X
                end
                if scrollX > -1 then
                    if scrollTest < 1 then
                        window.scrollXPos = window.scrollXPos + scrollX
                    else
                        window.scrollXPos = 0
                    end
                end
                if scrollX < 1 then
                    if scrollTest+1 > max_scroll_X then
                        window.scrollXPos = window.scrollXPos + scrollX
                    else
                        window.scrollXPos = max_scroll_X
                    end
                end
            else
                if window.scrollXPos >= 0 then window.scrollXPos = 0 end
                if window.scrollXPos <= max_scroll_X then window.scrollXPos = max_scroll_X end
            end
        UiPop()
        local is_overflow_Y = false
        local is_overflow_X = false
        if scroll_height > h then is_overflow_Y = true end
        if scroll_width > w then is_overflow_X = true end
        if UiIsMouseInRect(w,h) or window.keepScrolling == true then
        else
            UiDisableInput()
        end
        UiPush()
            local scrollAreaContainer_w = 0
            local scrollAreaContainer_h = 0

            local window_w = w
            local window_h = h
            --
            if scroll_height > h then
                scrollAreaContainer_w = 18
                window_w = w-17
                window_h = scroll_height-17
            else
                max_scroll_Y = 0
            end
            --
            if scroll_width > w then
                scrollAreaContainer_h = 18
                window_w = scroll_width-17
            else
                max_scroll_X = 0
            end
            --
            uic_container(w-2,h-1, true, false, false, function()
                UiWindow(w-scrollAreaContainer_w,h-scrollAreaContainer_h,true,true)
                if scroll_width > w-2 then UiTranslate(scrollX,0) end
                if scroll_height > h-2 then UiTranslate(0,scrollY) end
                UiWindow(window_w,window_h,style.clip, style.clip)
                content(extraContent,scrollX,scrollY)
            end)
        UiPop()
        UiPush()
        do 
            UiPush()    
                local addY = 0
                if is_overflow_X then
                    addY = 17
                end

                if is_overflow_Y == false then
                    UiColor(1,1,1,0.3)
                end
                UiAlign('center middle')
                UiPush()    
                    UiTranslate(w-(17/2),10)
                    UiImage(tgui_ui_assets..'/textures/arrow_up.png',image)
                UiPop()
                UiPush()    
                    UiTranslate(w-(17/2),h-10-addY)
                    UiImage(tgui_ui_assets..'/textures/arrow_down.png',image)
                UiPop()
            UiPop()
            if is_overflow_X then
                UiPush()    
                    UiAlign('center middle')
                    UiPush()    
                        UiTranslate(11,h-(17/2))
                        UiImage(tgui_ui_assets..'/textures/arrow_left.png',image)
                    UiPop()
                    UiPush()    
                        UiTranslate(w-(11+17),h-(17/2))
                        UiImage(tgui_ui_assets..'/textures/arrow_right.png',image)
                    UiPop()
                UiPop()
            end
            -- Scrollbars
            if is_overflow_Y then
                UiPush()    
                    -- local factor = scroll_height/(h-20)
                    UiAlign('top left')
                    UiTranslate(0,17)
                    UiTranslate(w-17,0)
                    UiColor(c255(191), c255(191), c255(191), 0.5)
                    UiRect(17,h-34-addY)
                    
                    local bar_scroll_Y=scrollY*((h-34-addY)/(scroll_height))
                    local viewportRatio_height = h / scroll_height
                    local scrollY_bar_height = math.max(0, math.floor((h-34-addY)*viewportRatio_height))
                    UiColor(c255(191), c255(191), c255(191), 1)
                    UiTranslate(0,-bar_scroll_Y)
                    UiColor(1,1,1,1) --scrollY
                    -- if (scroll_bar_height+h-(17*2)) > 1 then
                    -- window.oldscrollYPos = window.scrollYPos
                    UiImageBox(tgui_ui_assets..'/textures/outline_inner_normal.png',17,(scrollY_bar_height),1,1)
                    if GetBool("TGUI.interactingWindow") == false then
                        UiPush()
                        -- UiWindow(17,scroll_bar_height,false)
                        if UiIsMouseInRect(17,scrollY_bar_height) or window.keepScrolling == true and InputDown('lmb') then
                            UiPush()
                                UiAlign('center middle')
                                UiTranslate(window.mouse_pos_thum.mouse.x, window.mouse_pos_thum.mouse.y)
                                -- UiRect(window.deltaMouse.x, window.deltaMouse.y)
                                -- UiWindow(200,scroll_bar_height,false)
                                -- UiColor(1,1,0,0.3)
                                -- UiRect(750,scroll_bar_height+750)
                                if UiIsMouseInRect(750,scrollY_bar_height+750) and InputDown('lmb') then 
                                    window.pos_thum.mouse.x, window.pos_thum.mouse.y = UiGetMousePos()
                                    window.pos_thum.deltaMouse = { x = window.pos_thum.mouse.x - window.pos_thum.lastMouse.x, y = window.pos_thum.mouse.y - window.pos_thum.lastMouse.y }            
                                    window.pos_thum.mouseMoved = window.pos_thum.deltaMouse.x ~= 0 or window.pos_thum.deltaMouse.y ~= 0                                
                                    local vec2d = ui2DAdd(-scrollY, window.pos_thum.deltaMouse).y
                                    window.scrollYPos = -vec2d
                                    if window.scrollYPos >= 0 then
                                        window.scrollYPos = 0
                                    end
                                    if window.scrollYPos <= max_scroll_Y then
                                        window.scrollYPos = max_scroll_Y
                                    end                    
                                    -- DebugWatch('Scroll',InputValue("mousedy")/(scroll_height/h))
                                    -- local mouseWheel = InputDown('')
                                    -- window.scrollYPos = window.scrollYPos-InputValue("mousedy")+(h-34*scroll_bar_height)
                                    window.keepScrolling = true
                                end
                            UiPop()
                        end
                        if UiIsMouseInRect(17,scrollY_bar_height) and window.keepScrolling == false and not InputDown('lmb') then
                            window.mouse_pos_thum.mouse.x, window.mouse_pos_thum.mouse.y = UiGetMousePos()
                        end
                        UiAlign('center middle')
                        if InputReleased('lmb') or not UiIsMouseInRect(750,scrollY_bar_height+750) then
                            window.keepScrolling = false
                        end
                        UiPop()
                    end
                    -- else
                        -- UiImageBox('MOD/ui/TGUI_resources/textures/outline_inner_normal.png',17,2,1,1)
                    -- end
                UiPop()
            else
            end
            if is_overflow_X then
                UiTranslate(0,-1)
                UiAlign('top left')
                UiTranslate(17,h-17)
                UiColor(c255(191), c255(191), c255(191), 0.5)
                UiRect(w-(34+17),17)

                local bar_scroll_X=scrollX*((w-(34+17))/(scroll_width))
                local viewportRatio_width = w / scroll_width
                local scrollX_bar_height = math.max(0, math.floor((w-(34+17))*viewportRatio_width))
                
                UiTranslate(-bar_scroll_X,0)
                UiImageBox(tgui_ui_assets..'/textures/outline_inner_normal.png',(scrollX_bar_height),17,1,1)
            else
            end
            function ui2DAdd(a, b)
                return { x = a + b.x, y = a + b.y }
            end                
        end
        UiPop()
    UiPop()
end

---Create a tab container widget
---@note There is a `UiTranslate(0,h)` at the end of the function
---@param window table Get the window object for the widget
---@param w integer Width of the container tab
---@param h integer Height of the container tab
---@param clip boolean Clip content outside window. Default is false
---@param border boolean Adds the border of the tab container
---@param contents table Create ui with different tabs: 
---```
--- format: contents
---{ 
---  ["open_default"]=1, 
---  {
---    ["title"]="text",
---    ["Content"]=function() end
---  } , ... 
---}
--```
---@param extraContent? any Additional content to be called to the container and all the available tabs
---@param style? table Style the tab container
-----------
---## style
---- `tabHeight` default: 25, Height of the tabs
---- `tabPaddingRight` default: 20, Padding right of the tabs for the text
---- `tabPaddingLeft` default: 0, Padding left of the tabs for the text
---- `tabTextSize` default: 15, Text size of the tab
-----------
---@param dt? any Delta Time
function uic_tab_container(window, w,h,clip,border,contents, extraContent, style, dt)
    -- if window.tabFirstFrame == true or window.tabFirstFrame == nil then
        if style == nil then
            style = {
                tabHeight = 25,
                tabPaddingRight = 20,
                tabPaddingLeft = 0,
                tabTextSize = 15
            }
        else
            if style.tabHeight == nil then style.tabHeight = 25 end
            if style.tabPaddingRight == nil then style.tabPaddingRight = 20 end
            if style.tabPaddingLeft == nil then style.tabPaddingLeft = 0 end
            if style.tabTextSize == nil then style.tabTextSize = 13 end
        end
    -- end
    local line_width = w
    UiPush()
        UiWindow(w,h,clip,clip)
        UiPush()
            local all_tab_width = 0
            local tab_height = style.tabHeight
            local right_padding = style.tabPaddingRight
            local left_padding = style.tabPaddingLeft
            UiPush()
                UiTranslate(0,tab_height-1)
                if border then
                    UiImageBox(tgui_ui_assets..'/textures/outline_outer_tab_container.png',w,h-tab_height-1,1,1)
                end
            UiPop()
            UiButtonImageBox('MOD',0,0,0,0,0,0)
            
            if window.tabFirstFrame == true or window.tabFirstFrame == nil then
                window.tabOpen = contents["open_default"]
                window.overflow = false
                window.tabScroll = 0
                window.tabFirstFrame = false
                window.tabFade = 0
            end
            if dt then
                window.tabFade = window.tabFade + dt/0.2
                if window.tabFade > 1 then
                    window.tabFade = 1
                end
            else
                window.tabFade = 1
            end
            UiPush()
            UiWindow(w,tab_height+1,true)
            if window.overflow then if UiIsMouseInRect(w,tab_height+1) then else UiDisableInput() end end
            UiTranslate(window.tabScroll,0)
            for i, v in ipairs(contents) do
                if v.title then else v.title = "Title Here" end
                
                UiPush()
                    UiFont(tgui_ui_assets.."/Fonts/TAHOMA.TTF", style.tabTextSize)
                    tab_width = 0 
                    tab_text_w,_ = UiGetTextSize(v.title)
                    UiPush()
                        local removeHeight = 3
                        if window.tabOpen == i then removeHeight = 0 end
                        UiAlign('bottom left')
                        UiTranslate(0,tab_height)
                        tab_width = tab_text_w+right_padding+left_padding
                        UiWindow(width,height,clip)
                        UiImageBox(tgui_ui_assets..'/textures/outline_outer_tab.png',tab_width,tab_height-removeHeight,1,1)
                        UiPush()
                            UiTranslate(style.tabPaddingLeft, 0)
                            uic_text(v.title,tab_height-removeHeight, style.tabTextSize)
                        UiPop()
                        if UiBlankButton(tab_width,tab_height-removeHeight) then window.tabOpen = i; if dt then window.tabFade = 0 end end
                        if removeHeight == 3 then UiImageBox(tgui_ui_assets..'/textures/line_white.png',tab_width,1,0,0) end
                        UiAlign('top left')
                        UiPush()
                            -- DebugPrint(#contents.." == "..i)
                            last = #contents - 0
                            if last > i then
                                UiPush()
                                    UiTranslate(tab_width,-1)
                                    UiImageBox(tgui_ui_assets..'/textures/line_white.png',1,1,0,0)
                                UiPop()        
                            end
                            UiPush()
                                UiTranslate(0,0)
                                if window.tabOpen == i then
                                    UiPush()
                                        UiTranslate(tab_width-1,-1)
                                        UiImageBox(tgui_ui_assets..'/textures/line_dark.png',1,1,0,0)
                                    UiPop()
                                    if window.tabOpen >= 2 then
                                        UiPush()
                                            UiTranslate(0,-1)
                                            UiImageBox(tgui_ui_assets..'/textures/line_white.png',1,1,0,0)
                                        UiPop()
                                    end
                                end
                            UiPop()        
                        UiPop()        
                    UiPop()
                UiPop()
                all_tab_width = all_tab_width + (tab_width + 1)
                line_width = line_width - (tab_width + 1)
                UiTranslate(tab_width + 1)
            end
            UiPop()
            if w <= all_tab_width then
                window.overflow = true
                local max_scroll = all_tab_width-2 - w
                if window.tabScroll >= -max_scroll+1 then
                    UiPush()
                        UiAlign('left middle')
                        UiPush()
                            UiTranslate(w+5,tab_height/2)
                            UiImage(tgui_ui_assets..'/textures/tabs_arrow_right.png',image)
                        UiPop()
                        UiAlign('left top')
                        UiTranslate(w,0)
                        if UiBlankButton(10,tab_height) then
                            local scroll = -10
                            window.tabScroll = window.tabScroll + scroll
                        end
                    UiPop()
                end
                if window.tabScroll <= -1 then
                    UiPush()
                    UiAlign('right middle')
                        UiPush()
                            UiTranslate(-5,tab_height/2)
                            UiImage(tgui_ui_assets..'/textures/tabs_arrow_left.png',image)
                        UiPop()
                        UiAlign('right top')
                        if UiBlankButton(10,tab_height) then
                            local scroll = 10
                            window.tabScroll = window.tabScroll + scroll
                        end
                    UiPop()
                end

                if UiIsMouseInRect(w,tab_height+1) then
                    local scroll = InputValue('mousewheel')*10
                    local scrollTest = 0
                    scrollTest = window.tabScroll + scroll
                    -- window.tabScroll = window.tabScroll + scroll
                    if window.tabScroll >= 0 then
                        window.tabScroll = 0
                    end
                    if window.tabScroll <= -max_scroll then
                        window.tabScroll = -max_scroll
                    end
                    if scroll > -1 then
                        if scrollTest < 1 then
                            window.tabScroll = window.tabScroll + scroll
                        else
                            window.tabScroll = 0
                        end
                    end
                    if scroll < 1 then
                        if scrollTest+1 > -max_scroll then
                            window.tabScroll = window.tabScroll + scroll
                        else
                            window.tabScroll = -max_scroll
                        end
                    end
                else
                    if window.tabScroll >= 0 then
                        window.tabScroll = 0
                    end
                    if window.tabScroll <= -max_scroll then
                        window.tabScroll = -max_scroll
                    end
                end
            end
        UiPop()
        UiPush()
        if w > all_tab_width then
            UiTranslate(all_tab_width,tab_height-1)
            UiImageBox(tgui_ui_assets..'/textures/line_white.png',line_width,1,0,0)
        end
        UiPop()    
        if(border) then
            UiTranslate(1,tab_height)
            UiWindow(w-2,h-tab_height-3,true)
        end
        -- uic_text(window.tabOpen)
        UiPush()
            if #contents >= 0 then
                if not UiIsMouseInRect(w,h) then
                    UiDisableInput()
                end
                UiColorFilter(1, 1, 1, window.tabFade)
                -- local s, e = pcall(function() 
                    if (extraContent ==not nil) then
                    contents[window.tabOpen].Content(extraContent)
                    else contents[window.tabOpen].Content("Missing Contents");
                    end
                -- end)
                -- if not s then
                    -- error("Tab Container\nYour content is missing within the tab function\nAdd `Content = function() end` with a title to the contents table");
                -- end
            else
                uic_text("Empty Table Contents", 18, 15);
                UiWordWrap(w)
                UiTranslate(0, 24)
                uic_text("Add `Content = function() end` with a title to the table", 18, 15);
            end
        UiPop()
    UiPop()    
    UiTranslate(0,h)
end

---Table view
---@param window table
---@param dt number delta time
---@param w integer width of the table container
---@param h integer height of the table container
---@param clip boolean clip the container
---@param border boolean add border
---@param makeinner boolean invert the texture
---@param nameContents table list of Names
---```
----- format: list of names
---{label = "Name", w=0}
---```
---@param itemsContents table List of items 
---```
----- format: List of items
---{ (string|number)...}
---```
---@param options table options - Returns with the itemnumber in the table and the items that are selected
---- `onLeftClick` function to run on left click
---- `onRightClick` function to run on right click
---- `onDoubleClick` function to run on double click
function uic_tableview_container(window,dt,w,h,clip,border,makeinner,nameContents,itemsContents, options)
    if nameContents.elementFirstFrame == true then
        if window.firstFrame == nil then
            error("Tableview Container: The Window param is being reset while being redrawn\nPlease make sure you have setup the table outside the contents param of the window",0);
        else
            -- Remove elementFirstFrame from the namecontents
            table.remove(nameContents, 1)  
            window.checkComplete = true  
        end
    end
    if nameContents.elementFirstFrame == nil then
        if window.checkComplete == true then 
        else
            nameContents.elementFirstFrame = true
        end
    end
    -- local s, r = pcall()
    if window.firstFrame == nil or window.firstFrame == {} then
        window.totalWidth = 0
        window.totalHeight = 0
        window.firstFrame = false
        window.tableScroll = {}
        window.scroll_height = 0
        window.itemDoubleClick = {
            itemNumber = -1,
            time = 0,
            doubleClick = false
        }
    end
    window.totalWidth = 0
    if window.checkComplete == true then
        DebugWatch("window.itemDoubleClick.time", window.itemDoubleClick.time)
        if window.itemDoubleClick.time > 0 then
            window.itemDoubleClick.time = window.itemDoubleClick.time - dt/1
            if window.itemDoubleClick.time <= 0 then
                window.itemDoubleClick.time = 0
                window.itemDoubleClick.itemNumber = -1
                window.itemDoubleClick.doubleClick = false
            end
        end
        UiPush()
            if border then
                UiPush()
                    UiColor(c255(93),c255(93),c255(93),0.5)
                    UiRect(w,h)
                UiPop()
                if makeinner then
                    UiImageBox(tgui_ui_assets..'/textures/outline_inner_normal.png',w,h,1,1)
                else
                    UiImageBox(tgui_ui_assets..'/textures/outline_outer_normal.png',w,h,1,1)
                end
            end
            for i, v in ipairs(nameContents) do
                window.totalWidth = window.totalWidth + v.w
            end
            UiTranslate(1,1)

            UiPush()
                UiTranslate(0,h-30)
                uic_text(window.totalWidth, 17, 10)
            UiPop()
            if window.totalWidth > w then
                UiWindow(w-2,h-2,true)
            end
            UiPush()
                for i , v in pairs(itemsContents) do
                    window.totalHeight = 17*i
                end
            UiPop()
            UiTranslate(0,0)
            UiPush()
                uic_container(w, h, true, false, false, function()
                uic_scroll_Container(window.tableScroll, w-1, h-1, false, window.totalHeight+17, window.totalWidth+17 , function()
                    -- UiWindow(UiWidth(),UiHeight()-17,false)
                    UiPush()
                    for k , v in pairs(nameContents) do
                        if type(v) == "boolean" then
                            break
                        end
                        local text = uic_text(v.label, 17, 10)
                        UiPush()
                            UiFont(text.font,text.size)
                            local txt_w, _ = UiGetTextSize(v.label)
                        UiPop()
                        UiImageBox(tgui_ui_assets..'/textures/outline_outer_normal.png',v.w,17,1,1)
                        if v.w <= txt_w then v.w = txt_w end
                        UiTranslate(v.w,0)
                    end
                    -- UiImageBox(tgui_ui_assets..'/textures/outline_outer_normal.png',w-window.totalHeight,17,1,1)
                    UiPop()
                    UiTranslate(0,17)
        
                    for i, v in ipairs(itemsContents) do
                        local item = v
                        UiPush()
                            if UiIsMouseInRect(w,17) then
                                UiPush()
                                    UiColor(c255(255),c255(156),c255(0),1)
                                    UiRect(w,17)
                                UiPop()
                                UiColor(0,0,0,1)
                                if InputPressed('rmb') then
                                    if type(options.onItemRightClick) == "function" then
                                        options.onItemRightClick(i,v)
                                    end
                                end
                                if InputPressed('lmb') then
                                    if window.itemDoubleClick.time <= 0 then
                                        if type(options.onItemClick) == "function" then
                                            options.onItemClick(i,v)
                                        end
                                    end
                                    if window.itemDoubleClick.doubleClick == true then
                                        if type(options.onItemClick) == "function" then
                                            options.onItemClick(i,v)
                                        end
                                    end
                                end
                                -- Double click
                                if InputPressed('lmb') then
                                    if i == not window.itemDoubleClick.itemNumber then
                                        DebugPrint("Item number is not the same")
                                        if type(options.onItemClick) == "function" then
                                            options.onItemClick(i,v)
                                        end
                                    end

                                    if type(options.onItemDoubleClick) == "function" then
                                        if window.itemDoubleClick.itemNumber == i then
                                            if window.itemDoubleClick.time >= 0 then
                                                if window.itemDoubleClick.doubleClick == false then
                                                    -- DebugPrint("Double Click")
                                                    window.itemDoubleClick.time = -0.1
                                                    window.itemDoubleClick.itemNumber = -1
                                                    window.itemDoubleClick.doubleClick = true
                                                    options.onItemDoubleClick(i,v)
                                                else
                                                    -- DebugPrint("Double Click: too many clicks")
                                                    window.itemDoubleClick.time = 0.5
                                                end
                                            end
                                        end
                                    end
                                    if window.itemDoubleClick.time <= 0 then
                                        window.itemDoubleClick.itemNumber = i
                                        window.itemDoubleClick.time = 0.5
                                    end
                                end
                            end
                            for iInner, vInner in ipairs(item) do
                                local rowWidth = nameContents[iInner].w
                                local text, txtType = {}, type(vInner);
                                
                                UiPush()
                                    if txtType == "string" or txtType == "number"  then
                                        text = uic_text(vInner, 17, 15)
                                    else
                                        text = uic_text(txtType, 17, 15)
                                    end
                                UiPop()
                                UiFont(text.font,text.size)
                                local txt_w, _ = UiGetTextSize(vInner)
                                if rowWidth <= txt_w then
                                    nameContents[iInner].w = txt_w
                                end
                                UiTranslate(rowWidth,0)
                            end
                        UiPop()
                        UiTranslate(0,17)
                        window.totalHeight = window.totalHeight + 17
                    end
                end , {
                    clip = false,
                })
                end, nil, {HaveUiWindow = false})
                
                -- SCROLL CONTAINER
                do
                    -- if style.scrollbar == nil then style.scrollbar = true end
                    if window.scrollfirstFrame == nil or window.scrollfirstFrame == true  then
                        window.scrollXPos = 0
                        window.scrollYPos = 0
                        --
                        window.mouse_pos_thum = {}
                        window.pos_thum = {}
                        --
                        window.mouse_pos_thum.lastMouse = { x = 0, y = 0 }
                        window.mouse_pos_thum.mouse = { x = 0, y = 0 }
                        window.mouse_pos_thum.deltaMouse = { x = window.mouse_pos_thum.mouse.x - window.mouse_pos_thum.lastMouse.x, y = window.mouse_pos_thum.mouse.y - window.mouse_pos_thum.lastMouse.y }            
                        window.mouse_pos_thum.mouseMoved = window.mouse_pos_thum.deltaMouse.x ~= 0 or window.mouse_pos_thum.deltaMouse.y ~= 0
                        --
                        window.pos_thum.lastMouse = { x = 0, y = 0 }
                        window.pos_thum.mouse = { x = 0, y = 0 }
                        window.pos_thum.deltaMouse = { x = window.pos_thum.mouse.x - window.pos_thum.lastMouse.x, y = window.pos_thum.mouse.y - window.pos_thum.lastMouse.y }            
                        window.pos_thum.mouseMoved = window.pos_thum.deltaMouse.x ~= 0 or window.pos_thum.deltaMouse.y ~= 0
                        --
                        window.scrollfirstFrame = false
                    end
        
                    local scrollY = window.scrollYPos

                    local max_scroll_Y = 500
                    if window.scroll_height > h then
                        max_scroll_Y = h - window.scroll_height else
                        max_scroll_Y = 0
                    end
                    if UiIsMouseInRect(w,h) and not InputDown('shift') then
                        local scrollY = InputValue('mousewheel')
                        local scrollTest = 0
                        scrollTest = window.scrollYPos + scrollY
                        if window.scrollYPos >= 0 then
                            window.scrollYPos = 0
                        end
                        if window.scrollYPos <= max_scroll_Y then
                            window.scrollYPos = max_scroll_Y
                        end
                        if scrollY > -1 then
                            if scrollTest < 1 then
                                window.scrollYPos = window.scrollYPos + scrollY
                            else
                                window.scrollYPos = 0
                            end
                        end
                        if scrollY < 1 then
                            if scrollTest+1 > max_scroll_Y then
                                window.scrollYPos = window.scrollYPos + scrollY
                            else
                                window.scrollYPos = max_scroll_Y
                            end
                        end
                    else
                        if window.scrollYPos >= 0 then
                            window.scrollYPos = 0
                        end
                        if window.scrollYPos <= max_scroll_Y then
                            window.scrollYPos = max_scroll_Y
                        end
                    end
                end
            UiPop()
        UiPop()
    end
end

---Listox 
---@param window table
---@param w integer width of the listbox container
---@param h integer height of the listbox container
---@param clip boolean clip the container
---@param border boolean add border
---@param makeinner boolean invert the texture
---@param contents table items
---@param options table options for the listbox
--- ```
----- format: options
---{
---  Key = string|table ,
---  --for singleSelect, item will be stored in the key (GetString(key)).
---  --for multiSelect, there will multiple keys ((key).multiSelect.(item))
---  multiSelect = boolean (default false), -- if true, the listbox will be multiSelect.
---  onSelect = function(item) 
---   --[[Code goes here]]
---  end,
---  onDeSelect = function(item) 
---   --[[Code goes here]]
---  end,
---}
----- format: options
---```
function uic_listBox_container(window,w,h_items_visible,clip,border,makeinner, contents, options)
    scroll_height = h_items_visible*19
    if options == nil or options == {} then
        options = {}
    else
        if options.key == nil then error("Element: uic_listBox_container\nYou must specify a key",0) end
        if options.multiSelect == nil then options.multiSelect = false end
        if options.onSelect == nil then options.onSelect = function() end end
        if options.onDeSelect == nil then options.onDeSelect = function() end end
    end
    if window.scrollcontainer == nil then
        window.scrollcontainer = {};
        window.scrollcontainer.scroll_height = 0;
    end
    -- if window.scrollcontainer.scroll_height == nil then
    --     window.scrollcontainer.scroll_height = 500;
    -- end
    UiPush()
        if border then
            UiPush()
                UiColor(c255(93),c255(93),c255(93),0.5)
                UiRect(w+1,(h_items_visible*19)+2)
            UiPop()
            if makeinner then
                UiImageBox(tgui_ui_assets..'/textures/outline_inner_normal.png',w+1,(h_items_visible*19)+2,1,1)
            else
                UiImageBox(tgui_ui_assets..'/textures/outline_outer_normal.png',w+1,(h_items_visible*19)+2,1,1)
            end
        end
        UiTranslate(1,1)
        UiPush()
            do
                -- if style.scrollbar == nil then style.scrollbar = true end
                if window.scrollcontainer.scrollfirstFrame == nil or window.scrollcontainer.scrollfirstFrame == true  then
                    window.scrollcontainer = {};
                    window.scrollcontainer.showScrollbar = false;
                    window.scrollcontainer.showWidth = 0;
                    --
                    window.scrollcontainer.scrollYPos = 0
                    --
                    window.scrollcontainer.contentsScroll = 0;
                    window.scrollcontainer.contentsScrollbar = 0;
                    --
                    window.scrollcontainer.mouse_pos_thum = {};
                    window.scrollcontainer.pos_thum = {};
                    --
                    window.scrollcontainer.mouse_pos_thum.lastMouse = { x = 0, y = 0 };
                    window.scrollcontainer.mouse_pos_thum.mouse = { x = 0, y = 0 };
                    window.scrollcontainer.mouse_pos_thum.deltaMouse = { x = window.scrollcontainer.mouse_pos_thum.mouse.x - window.scrollcontainer.mouse_pos_thum.lastMouse.x, y = window.scrollcontainer.mouse_pos_thum.mouse.y - window.scrollcontainer.mouse_pos_thum.lastMouse.y };
                    window.scrollcontainer.mouse_pos_thum.mouseMoved = window.scrollcontainer.mouse_pos_thum.deltaMouse.x ~= 0 or window.scrollcontainer.mouse_pos_thum.deltaMouse.y ~= 0;
                    --
                    window.scrollcontainer.pos_thum.lastMouse = { x = 0, y = 0 };
                    window.scrollcontainer.pos_thum.mouse = { x = 0, y = 0 };
                    window.scrollcontainer.pos_thum.deltaMouse = { x = window.scrollcontainer.pos_thum.mouse.x - window.scrollcontainer.pos_thum.lastMouse.x, y = window.scrollcontainer.pos_thum.mouse.y - window.scrollcontainer.pos_thum.lastMouse.y };
                    window.scrollcontainer.pos_thum.mouseMoved = window.scrollcontainer.pos_thum.deltaMouse.x ~= 0 or window.scrollcontainer.pos_thum.deltaMouse.y ~= 0;
                    --
                    window.scrollcontainer.scrollfirstFrame = false
                end
            
        
                local max_scroll_Y = h_items_visible;
                local contentsScroll = window.scrollcontainer.contentsScroll;
                local scrollY = window.scrollcontainer.scrollYPos;
                local is_overflow_Y = false;
                -- DebugPrint(max_scroll_Y)

                if #contents > (h_items_visible) then
                    max_scroll_Y = (#contents - h_items_visible) window.scrollcontainer.showWidth = 17; is_overflow_Y = true; else
                    max_scroll_Y = 0; window.scrollcontainer.showWidth = 0; is_overflow_Y = false;
                end
                


                if UiIsMouseInRect(w,h_items_visible*19) then
                    window.scrollcontainer.contentsScroll = window.scrollcontainer.contentsScroll - InputValue("mousewheel");
                end
                if window.scrollcontainer.contentsScroll <= 0 then
                    window.scrollcontainer.contentsScroll = 0
                end
                if window.scrollcontainer.contentsScroll >= max_scroll_Y then
                    window.scrollcontainer.contentsScroll = max_scroll_Y
                end
                UiPush()
                    UiWindow(w-1 , h_items_visible*19, true, true)

                    function clamp(value, mi, ma)
                        if value < mi then value = mi end
                        if value > ma then value = ma end
                        return value
                    end

                    -- TODO: make a scroll system like pysimplegui instead
                    -- Normal Scrollbar
                    if is_overflow_Y then
                        UiPush()    
                            -- local factor = scroll_height/(h-20)
                            UiAlign('top left')
                            UiTranslate(0,17)
                            UiTranslate(w-17,0)
                            UiColor(c255(191), c255(191), c255(191), 0.5)
                            UiRect(17,(h_items_visible*19)-34)
                            
                            local bar_scroll_Y=scrollY*((h_items_visible-34)/(#contents))
                            local viewportRatio_height = h_items_visible / #contents
                            local scrollY_bar_height = math.max(0, math.floor((h_items_visible*19-34)*viewportRatio_height))
                            UiColor(c255(191), c255(191), c255(191), 1)
                            UiTranslate(0,-bar_scroll_Y)
                            UiColor(1,1,1,1) --scrollY
                            DebugPrint(bar_scroll_Y)
                            -- if (scroll_bar_height+h-(17*2)) > 1 then
                            -- window.oldscrollYPos = window.scrollYPos
                            UiImageBox(tgui_ui_assets..'/textures/outline_inner_normal.png',17,(scrollY_bar_height),1,1)
                            -- if GetBool("TGUI.interactingWindow") == false then
                                UiPush()
                                -- UiWindow(17,scroll_bar_height,false)
                                if UiIsMouseInRect(17,scrollY_bar_height) or window.scrollcontainer.keepScrolling == true and InputDown('lmb') then
                                    UiPush()
                                        UiAlign('center middle')
                                        UiTranslate(window.scrollcontainer.mouse_pos_thum.mouse.x, window.scrollcontainer.mouse_pos_thum.mouse.y)
                                        -- UiRect(window.deltaMouse.x, window.deltaMouse.y)
                                        -- UiWindow(200,scroll_bar_height,false)
                                        -- UiColor(1,1,0,0.3)
                                        -- UiRect(750,scroll_bar_height+750)
                                        if UiIsMouseInRect(750,scrollY_bar_height+750) and InputDown('lmb') then 
                                            window.scrollcontainer.pos_thum.mouse.x, window.scrollcontainer.pos_thum.mouse.y = UiGetMousePos()
                                            window.scrollcontainer.pos_thum.deltaMouse = { x = window.scrollcontainer.pos_thum.mouse.x - window.scrollcontainer.pos_thum.lastMouse.x, y = window.scrollcontainer.pos_thum.mouse.y - window.scrollcontainer.pos_thum.lastMouse.y }            
                                            window.scrollcontainer.pos_thum.mouseMoved = window.scrollcontainer.pos_thum.deltaMouse.x ~= 0 or window.scrollcontainer.pos_thum.deltaMouse.y ~= 0                                
                                            local vec2d = ui2DAdd(-scrollY, window.scrollcontainer.pos_thum.deltaMouse).y
                                            window.scrollcontainer.scrollYPos = vec2d
                                            if window.scrollcontainer.scrollYPos >= 0 then
                                                window.scrollcontainer.scrollYPos = 0
                                            end
                                            if window.scrollcontainer.scrollYPos <= max_scroll_Y then
                                                window.scrollcontainer.scrollYPos = max_scroll_Y
                                            end                    
                                            -- DebugWatch('Scroll',InputValue("mousedy")/(scroll_height/h))
                                            -- local mouseWheel = InputDown('')
                                            -- window.scrollYPos = window.scrollYPos-InputValue("mousedy")+(h-34*scroll_bar_height)
                                            window.scrollcontainer.keepScrolling = true
                                        end
                                    UiPop()
                                end
                                if UiIsMouseInRect(17,scrollY_bar_height) and window.scrollcontainer.keepScrolling == false and not InputDown('lmb') then
                                    window.scrollcontainer.mouse_pos_thum.mouse.x, window.scrollcontainer.mouse_pos_thum.mouse.y = UiGetMousePos()
                                end
                                UiAlign('center middle')
                                if InputReleased('lmb') or not UiIsMouseInRect(750,scrollY_bar_height+750) then
                                    window.scrollcontainer.keepScrolling = false
                                end
                                UiPop()
                            -- end
                            -- else
                                -- UiImageBox('MOD/ui/TGUI_resources/textures/outline_inner_normal.png',17,2,1,1)
                            -- end
                        UiPop()
                    else
                    end

                    -- Virtual Scrollbar 

                    if is_overflow_Y then
                        -- UiPush()
                        --     local height_snap_test = #contents+h_items_visible; 
                        --     UiTranslate(0, -window.scrollcontainer.contentsScroll*19)
                        --     UiPush()
                        --         UiTranslate(32, 0)
                        --         UiText("scroll: "..UiHeight()/(#contents-h_items_visible+1), opt_move)
                        --     UiPop()
                        --     for i=1, (#contents-h_items_visible)+1 do
                        --         UiRect(12, UiHeight()/(#contents-h_items_visible+1))
                        --         UiTranslate(3, UiHeight()/(#contents-h_items_visible+1))
                        --         -- UiImageBox(tgui_ui_assets..'/textures/outline_inner_normal.png',17,(h_items_visible*19)/i,1,1)
                        --     end
                        -- UiPop()
                    end
                    for i=1,h_items_visible do
                        local s, r = pcall(function( ... )
                            local v = contents[i+contentsScroll];
                            UiPush()
                                UiPush()
                                    UiColor(0,0,0,0)
                                    local text = uic_text(v.text , 17, 15)
                                UiPop()
                                if options.multiSelect then
                                    if HasKey(options.key..".multiSelect."..v.keyItem) then
                                        UiPush()
                                            UiColor(c255(255),c255(156),c255(0),1)
                                            UiRect(UiWidth() - window.scrollcontainer.showWidth,19)
                                        UiPop()     
                                    end
                                else
                                    if GetString(options.key) == v.keyItem then
                                        UiPush()
                                            UiColor(c255(255),c255(156),c255(0),1)
                                            UiRect(UiWidth()  - window.scrollcontainer.showWidth,19)
                                        UiPop()     
                                    end
                                end

                                local text = uic_text(v.text , 17, 15)

                                if UiBlankButton(UiWidth()  - window.scrollcontainer.showWidth,text.height) then
                                    if options.multiSelect then
                                        if HasKey(options.key..".multiSelect."..v.keyItem) then
                                            ClearKey(options.key..".multiSelect."..v.keyItem)
                                        else
                                            SetString(options.key..".multiSelect."..v.keyItem, v.text)
                                        end
                                    else
                                        SetString(options.key,v.keyItem)
                                    end
                                end
                            UiPop()
                            UiTranslate(0,19)
                        end)

                        if not s then
                            UiPop()
                            UiPop() 
                            UiPush()
                                if window.scrollcontainer.contentsScroll < 0 then
                                    local text = uic_text("ERROR!" , 19, 15)
                                end
                            UiPop()
                            UiTranslate(0,19)
                        end
                                -- endþ
                                -- else
                        --     if GetString(options.key) == v.text then
                        --         UiPush()
                        --             UiColor(c255(255),c255(156),c255(0),1)
                        --             UiRect(UiWidth(),text.height)
                        --         UiPop()     
                        --     end
                        -- end
                    end
                UiPop()
            end
        UiPop() 
    UiPop()
    UiTranslate(0, h_items_visible*19);
end

---Make a tree of items
---@param window table Window table
---@param options table options for the treeview
---- `key` - where the items should be stored
---- `multiSelect` - able to select nultiple items at once
---@param w integer height of the tree container
---@param h_items_visible integer height of the tree container
---@param contents table contents for the tree
---@param style? table Style the container
---- `style.BackgroundColor` default: `{r=93,g=93,b=93,a=0.5}` - color range: 255 - alpha: 200
---- `style.Border` default: false - show border around the container
---- `style.BorderInnder` default: false - change the texture to make it inner 
---- `style.BorderPadding` default: 1 - change the borderWidth and borderHeight 
---- `style.Padding` default: 1 - change the borderWidth and borderHeight 
function uic_treeView_container(window,options,w,h_items_visible,onClick,contents,style)
    if style == nil then 
        style = {
            BackgroundColor = {r=93,g=93,b=93,a=100},
            Border = true,
            BorderInnder = true,
            BorderPadding = 1,
            BackgroundTextureInner = tgui_ui_assets.."/textures/outline_inner_normal.png",
            BackgroundTextureOutter = tgui_ui_assets.."/textures/outline_outer_normal.png",
            Padding = 0
        }
    else
        if style.BackgroundColor == nil then style.BackgroundColor = {r=93,g=93,b=93,a=100} end
        if style.Border == nil then style.Border = true end
        if style.BorderInnder == nil then style.BorderInnder = true end
        if style.BorderPadding == nil then style.BorderPadding = 1 end
        if style.BackgroundTextureInner == nil then BackgroundTextureInner = tgui_ui_assets.."/textures/outline_inner_normal.png" end
        if style.BackgroundTextureOutter == nil then BackgroundTextureOutter = tgui_ui_assets.."/textures/outline_outer_normal.png" end
        if style.Padding == nil then style.Padding = 0 end
    end
    local totalHeight = 0;
    UiPush()
        if window.treefirstframe == nil or window.treefirstframe == true then
            window.contentHeight = 0
            window.scrollfirstFrame = true
            -- 
            window.treefirstframe = false
        end
        if style.Border then
            UiPush()
                UiColor(c255(style.BackgroundColor.r),c255(style.BackgroundColor.g),c255(style.BackgroundColor.b),c200(style.BackgroundColor.a))
                UiRect(w+1,(h_items_visible*19)+2)
            UiPop()
            if style.BorderInnder then
                UiImageBox(style.BackgroundTextureInner,w+1,(h_items_visible*19)+2,style.BorderPadding,style.BorderPadding)
            else
                UiImageBox(style.BackgroundTextureOutter,w+1,(h_items_visible*19)+2,style.BorderPadding,style.BorderPadding)
            end
        end
        window.contentHeight = 0
        -- UiTranslate(style.BorderPadding, style.BorderPadding);
        UiTranslate(style.Padding, style.Padding);
        UiWindow((w+(style.Padding*2)), ((h_items_visible*19)+(style.Padding*2)+2), true, true)

        function displayName( t )
            UiPush()
                uic_text( t , 19, 13)
            UiPop()
        end
        function pre_displayTree(content, extra)
            local path = extra
            if type(content) == "table" then
                window.contentHeight = window.contentHeight + 19;
                if content.hidden == false then for i, v in ipairs(content) do pre_displayTree(v, path.."."..content.itemText) end end
            elseif type(content) == "string" then
                window.contentHeight = window.contentHeight + 19;
            end
        end
        for i, v in ipairs(contents) do pre_displayTree(v, "") end

        -- for i, v in ipairs(contents) do

        -- end
        function displayTree(content, extra, index,...)
            local path = extra
            UiPush()
                local _, c = path:gsub("%.+", "");
                UiTranslate(-19*c, 0)
                if options.multiSelect then
                    if HasKey(options.key..".multiSelect."..path:gsub("%.+","-").."-"..index) then
                        UiPush()
                            UiColor(c255(255),c255(156),c255(0),1)
                            UiRect(UiWidth(),19)
                        UiPop()     
                    end
                else
                    if type(content) == "string" then
                        if GetString(options.key) == "root"..path.."."..content then
                            UiPush()
                                UiColor(c255(255),c255(156),c255(0),1)
                                UiRect(UiWidth(),19)
                            UiPop()
                        end
                    end
                end
            UiPop()
            if type(content) == "table" then
                -- UiImage("path", opt_x0, opt_y0, opt_x1, opt_y1)
                UiPush()
                    UiTranslate(19/2, 19/2)
                    UiAlign("center middle")
                    if UiBlankButton(19, 19) then
                        if content.hidden == nil then content.hidden = false else
                            content.hidden = not content.hidden
                        end
                    end
                    if content.hidden == false then
                        UiImage(tgui_ui_assets.."/textures/arrow_down.png")
                    else
                        UiImage(tgui_ui_assets.."/textures/arrow_right.png")
                    end
                UiPop()
                UiTranslate(19, 0)
                displayName( content.itemText )
                UiTranslate(0, 19)
                window.contentHeight = window.contentHeight + 19;
                if content.hidden == false then
                    for i, v in ipairs(content) do
                        displayTree(v, path.."."..content.itemText, i)
                    end
                end
                UiTranslate(-19, -19)
            elseif type(content) == "string" then
                window.contentHeight = window.contentHeight + 19;
                if UiBlankButton(w, 19) then
                    if options.multiSelect then
                        if HasKey(options.key..".multiSelect."..path:gsub("%.+","-").."-"..index) then
                            ClearKey(options.key..".multiSelect."..path:gsub("%.+","-").."-"..index)
                        else
                            SetString(options.key..".multiSelect."..path:gsub("%.+","-").."-"..index, content)
                        end
                    else
                        SetString(options.key,"root"..path.."."..content)
                    end
                    onClick( "root"..path.."."..content );
                end
                displayName( content )
            end
            UiTranslate(0, 19)
        end
        uic_scroll_Container(window, w,UiHeight(), false, window.contentHeight, 0, function()
            if not UiIsMouseInRect(UiWidth(), window.contentHeight) then
                UiDisableInput()
            end
            for i, v in ipairs(contents) do
                displayTree(v, "", i)
            end
        end)
    UiPop()
end
---[[ WIDGETS ]]
    
---Display text
---@param Text string Simple, display the text
---@param height integer Height for the the `UiTextButton`
---@param fontSize? integer Size of the text
---@param customization? table you can only change the font path
---- `font` default: tgui_ui_assets.."/Fonts/TAHOMA.TTF", Font path
---- use the function `UiColor()` to change the color of the text
---@return table fontPathAndSize Get the font path and the size that is used to draw.
---- {font, size -- font size, width ,height}
function uic_text( Text, height, fontSize, customization )
    if customization == nil then
        customization = {
            font = tgui_ui_assets.."/Fonts/TAHOMA.TTF"
        }
    end
    if height == nil then height = 15 end
    if fontSize == nil then fontSize = 13 end
    UiPush() 
        UiFont(customization.font, fontSize)
        local txt_w, txt_h = UiGetTextSize(Text)
        UiDisableInput()
        if uic_debug_buttontextWidth then
            UiPush()
                UiColor(1,1,0,0.3)
                UiRect(txt_w,height)
            UiPop()
        end
        UiButtonImageBox('MOD',0,0,0,0,0,0)
        UiTextButton(Text,txt_w,height)
    UiPop()
    local finalHeight;
    if txt_h >= height then finalHeight = txt_h
    else finalHeight = height end
    return {font=customization.font, size=fontSize, width=txt_w ,height=finalHeight}
end

--- Create a checkbox
---@param text string Display text
---@param key string|table Key for the checkbox
---@param hitWidth integer Changes width of the hitbox for the checkbox
---@param beDisabled? boolean Make it disabled and unchecable
---@param toolTipText? string Display a tooltip when hovering over the checkbox
---@param style? table Style the checkbox
function uic_checkbox(text, key, hitWidth, beDisabled, toolTipText, style)
    if type( style ) == not "table" then
        error( "style must be a table", 0 )
    end
    if style == nil or style == {} then
        style = {
            font = tgui_ui_assets.."/Fonts/TAHOMA.TTF",
            fontSize = 13,
            enabledColor =  {r=255,g=255,b=255,a=1},
            disabledColor = {r=0.5,g=0.5,b=0.5,a=1},
            disabledColorShadow = {r=60,g=60,b=60,a=0.4},
            hoverColor =    {r=0.95,g=0.95,b=0.95,a=1},
            activeColor =   {r=255,g=255,b=255,a=1},
        }
    else
        if style.font == nil then style.font = tgui_ui_assets.."/Fonts/TAHOMA.TTF" end
        if style.fontSize == nil then style.fontSize = 13 end
        if style.enabledColor == nil then style.enabledColor = {r=255,g=255,b=255,a=1} end
        if style.disabledColor == nil then style.disabledColor = {r=0.5,g=0.5,b=0.5,a=1} end
        if style.disabledColorShadow == nil then style.disabledColorShadow = {r=60,g=60,b=60,a=0.4} end
        if style.hoverColor == nil then style.hoverColor = {r=0.95,g=0.95,b=0.95,a=1} end
        if style.activeColor == nil then style.activeColor = {r=1,g=1,b=1,a=1} end
    end
    UiPush()
        UiWindow(0,12,false	)
        UiAlign('left top')
        UiFont(tgui_ui_assets.."/Fonts/TAHOMA.TTF", 13)
        UiButtonImageBox('',1,1,1,1,1,1)
        UiImageBox(tgui_ui_assets.."/textures/outline_inner_special_checkbox.png",12, 12,1,1,1,1)
        UiButtonImageBox(' ',0,0,0,0,0,0)
        tx_s_w,no_v_h = UiGetTextSize(text)
        -- check if the text is bigger than the hitbox
        if tx_s_w > hitWidth then
            hitWidth = tx_s_w
        end
        UiPush()
            UiColor(1,1,1,1)
            UiTranslate(-6,-4)
            if uic_debug_show_hitboxes_checkbox then
                UiColor(1,1,1,0.2)
                UiRect(6 + no_v_h + hitWidth,20)
                UiColor(1,1,1,1)
            end
            if not beDisabled then 
                if UiBlankButton(6 + no_v_h + hitWidth,20) then
                    if type(key) == "string" then
                        SetBool(key,not GetBool(key))
                    end
                    if type(key) == "boolean" then
                        if key then
                            return false
                        else
                            return true
                        end
                    end
                end
            end
        UiPop()
        if type(key) == "string" then
            if GetBool(key) then
                UiImage(tgui_ui_assets..'/textures/checkmark.png')
            else
                UiTranslate(-6,-4)
                if UiIsMouseInRect(6 + no_v_h + hitWidth,20) then
                    UiColor(0.95,0.95,0.95,1)
                end
                UiTranslate(6,4)
            end
        end
        if type(key) == "boolean" then
            if key then
                UiImage(tgui_ui_assets..'/textures/checkmark.png')
            else
                UiTranslate(-6,-4)
                if UiIsMouseInRect(6 + no_v_h + hitWidth,20) then
                    UiColor(style.hoverColor.r,style.hoverColor.g,style.hoverColor.b,1)
                end
                UiTranslate(6,4)
            end
        end
        UiAlign('left middle')
        UiTranslate(12,5)
        UiDisableInput()
        if beDisabled then
            UiColor(style.disabledColor.r, style.disabledColor.g, style.disabledColor.b, style.disabledColor.a)
        end
        uic_text(text, 24)
        if( beDisabled ) then
            UiPush()
                UiColor(c255(style.disabledColorShadow.r), c255(style.disabledColorShadow.g), c255(style.disabledColorShadow.b), style.disabledColorShadow.a)
                UiTranslate(1,1)
                uic_text(text, 24)
            UiPop()
        end
    UiPop()
    if type(key) == "boolean" then
        return key
    end
end
-- UPDATE HISTORY --
--[[
    18/9/22 - Add a 'not' prefix to the SetInt line
]]


---Create a radio button
---@param key string Connected keys for the radio button
---@param setString string Set this string when the radio button is pressed
---@param Text string Display text to the right of the radio button
---@param hitWidth integer Changes width of the hitbox for the radio button
---@param beDisabled? boolean Make it disabled and unchecable
---@param style? table Style of the radio button
---- `font` default: tgui_ui_assets.."/Fonts/TAHOMA.TTF", Font path	
---- `fontSize` default: 13, Font size
---- `enabledColor` default: {1,1,1,1}, Color of the radio button when enabled
---- `disabledColor` default: {0.5,0.5,0.5,1}, Color of the radio button when disabled
---- `hoverColor` default: {0.95,0.95,0.95,1}, Color of the text when hovering over the radio button
---- `activeColor` default:  {1,1,1,1}, Color of the text when active
---- ⚠ Colors will be changed to 255 format
---@param toolTipText? string Display text when hovering over the radio button
function uic_radio_button( key, setString, Text, hitboxWidth, beDisabled, style, toolTipText )
    if type( style ) == not "table" then
        error( "style must be a table", 0 )
    end
    if style == nil or style == {} then
        style = {
            font = tgui_ui_assets.."/Fonts/TAHOMA.TTF",
            fontSize = 13,
            enabledColor =  {r=255,g=255,b=255,a=1},
            disabledColor = {r=0.5,g=0.5,b=0.5,a=1},
            disabledColorShadow = {r=60,g=60,b=60,a=0.4},
            hoverColor =    {r=0.95,g=0.95,b=0.95,a=1},
            activeColor =   {r=255,g=255,b=255,a=1},
        }
    else
        if style.font == nil then style.font = tgui_ui_assets.."/Fonts/TAHOMA.TTF" end
        if style.fontSize == nil then style.fontSize = 13 end
        if style.enabledColor == nil then style.enabledColor = {r=255,g=255,b=255,a=1} end
        if style.disabledColor == nil then style.disabledColor = {r=0.5,g=0.5,b=0.5,a=1} end
        if style.disabledColorShadow == nil then style.disabledColorShadow = {r=60,g=60,b=60,a=0.4} end
        if style.hoverColor == nil then style.hoverColor = {r=0.95,g=0.95,b=0.95,a=1} end
        if style.activeColor == nil then style.activeColor = {r=1,g=1,b=1,a=1} end
    end
    UiPush()
        UiAlign('top left')
        if uic_debug_show_hitboxes_checkbox then
            UiPush()
                UiTranslate(-3, -3)
                UiColor(1,1,1,0.2)
                UiRect(9 + hitboxWidth,17)
            UiPop()
        end
        UiImage(tgui_ui_assets..'/textures/outline_inner_selection_radio.png')
        if GetString(key) == setString then
            UiImage(tgui_ui_assets..'/textures/outline_inner_selection_radio_mark.png')
        else
            UiTranslate(-3, -3)
            if UiIsMouseInRect(9 + hitboxWidth,17) then
                UiColor(0.95,0.95,0.95,1)
            end
            UiTranslate(3, 3)
        end
        UiPush()
            UiTranslate(-3, -3)
            if UiBlankButton(9+hitboxWidth,17) then
                if not beDisabled then
                    SetString(key,setString)
                    -- SetString(key, setString)
                end
            end
        UiPop()
        if beDisabled then
            UiColor(style.disabledColor.r, style.disabledColor.g, style.disabledColor.b, style.disabledColor.a)
        else
            UiColor(c255(style.enabledColor.r), c255(style.enabledColor.g), c255(style.enabledColor.b), style.enabledColor.a)
        end
        UiTranslate(16,-7)
        uic_text(Text, 24, style.fontsize, {
            font = style.font
        })
        if( beDisabled ) then
            UiPush()
                UiColor(c255(style.disabledColorShadow.r), c255(style.disabledColorShadow.g), c255(style.disabledColorShadow.b), style.disabledColorShadow.a)
                UiTranslate(1,1)
                uic_text(Text, 24, style.fontsize, {
                    font = style.font
                })
            UiPop()
        end
    UiPop()
end

---❗ [OBSOLETE] ❗
-------
---- this function will be removed in the future
---- use uic_button_func instead
--
---Create a button 
---@param buttinid integer id of the button
---@param text string Display text on the button
---@param width integer Width of the button
---@param height integer Height of the button
---@param disabled? boolean Disable the button
---@return boolean boolean Returns true if the button is released, none otherwise
---@deprecated
function uic_button(buttinid, text, width, height, disabled, toolTipText)
    UiPush()
        UiWindow(width, height, false)
        UiAlign("left top")
        UiFont(tgui_ui_assets.."/Fonts/TAHOMA.TTF", 14)
        if disabled then
            UiDisableInput()
        end
        UiPush()
            if not disabled then
                if UiIsMouseInRect(width, height) then
                    if not InputDown('lmb') then
                        UiImageBox(tgui_ui_assets.."/textures/outline_outer_normal.png",width, height,1,1,1,1)
                    else
                        UiImageBox(tgui_ui_assets.."/textures/outline_inner_normal.png",width, height,1,1,1,1)
                        UiTranslate(1,1)
                    end
                else
                    UiImageBox(tgui_ui_assets.."/textures/outline_outer_normal.png",width, height,1,1,1,1)
                end
                UiColor(1,1,1,1)
            else
                UiImageBox(tgui_ui_assets.."/textures/outline_outer_normal.png",width, height,1,1,1,1)
                UiColor(0.1,0.1,0.1,0.8)
            end
        
            UiTranslate(6,0)
            local w,h = UiGetTextSize(text)
            UiButtonImageBox('MOD',0,0,0,0,0,0)
            if UiTextButton(text,w,height) then return true end
        UiPop()    
        UiButtonImageBox("MOD",1,1,1,1,1,0)
        if UiBlankButton(width, height) then return true end

        if UiIsMouseInRect(width, height) then
            if toolTipText ~= nil then
                if uic_tooltip_enabled == false then
                    if uic_tooltip_hover_timer == 1 then
                        SetValue('uic_tooltip_hover_timer',0,"linear",0.75)
                        -- currentid = nextid
                        -- nextid = nextid +1

                        uic_tooltip_hover_id = buttinid
                        uic_tooltip_text = toolTipText
                    end
                    if uic_tooltip_hover_timer == 0 then
                        uic_tooltip_enabled = true
                    end
                end
            end
        else
            if not UiIsMouseInRect(width, height) then
                if uic_tooltip_hover_timer == 0 then
                    uic_tooltip_hover_timer = 1
                    uic_tooltip_enabled = false
                end
            end
            if uic_tooltip_hover_id == buttinid then
                if uic_tooltip_hover_timer == 0 then
                    uic_tooltip_hover_timer = 1
                    uic_tooltip_enabled = false
                end
            end
        end
    UiPop()
end
---Create a button
---@param window table Window
---@param dt any Delta time
---@param text string Display text on the button
---@param width integer Width of the button
---@param height integer Height of the button
---@param disabled boolean Disable the button
---@param tooltip string Show tooltip on the button -- not in use at the moment
---@param onClick function Do something when on the button on click
---@param extraContent? any Additional content to be called to the button
---@param style? table Customize the button
---- `fontPath` Defailt: tgui_ui_assets.."/Fonts/TAHOMA.TTF", Font
---- `fontSize` Defailt: 14, size of the text
---- `textcolornormal` Defailt: `{r=255,g=255,b=255,a=200}`, color of the text when not disabled
---- `textcolordisabled` Defailt: {g=24,b=24,a=160} , color of the text when disabled
function uic_button_func(window, dt, text, width, height, disabled, tooltip, onClick, extraContent ,style)
    if type(window) == "table" then
        if window == not nil then
            if window.tooltipActive == nil then window.tooltipActive = false end
        end
    end
    if style == nil then
        style = {
            fontPath = tgui_ui_assets.."/Fonts/TAHOMA.TTF",
            fontSize = 14,
            textcolornormal = {r=255,g=255,b=255,a=200},
            textcolordisabled = {r=24,g=24,b=24,a=160},
        }
    else
        if style.fontPath == nil then style.fontPath = tgui_ui_assets.."/Fonts/TAHOMA.TTF" end
        if style.fontSize == nil then style.fontSize = 14 end
        if style.textcolornormal == nil then style.textcolornormal = {r=255,g=255,b=255,a=200} end
        if style.textcolornormal == nil then style.textcolordisabled = {r=30,g=255,b=30,a=160} end
    end
    UiPush()
        UiWindow(width, height, false)
        UiAlign("left top")
        UiFont(style.fontPath, style.fontSize)
        if disabled then
            UiDisableInput()
        end
        UiPush()
            if not disabled then
                if UiIsMouseInRect(width, height) then
                    if not InputDown('lmb') then
                        UiImageBox(tgui_ui_assets.."/textures/outline_outer_normal.png",width, height,1,1,1,1)
                    else
                        UiImageBox(tgui_ui_assets.."/textures/outline_inner_normal.png",width, height,1,1,1,1)
                        UiTranslate(1,1)
                    end
                else
                    UiImageBox(tgui_ui_assets.."/textures/outline_outer_normal.png",width, height,1,1,1,1)
                end
                UiColor(c255(style.textcolornormal.r),c255(style.textcolornormal.g),c255(style.textcolornormal.b),c200(style.textcolornormal.a))
            else
                UiImageBox(tgui_ui_assets.."/textures/outline_outer_normal.png",width, height,1,1,1,1)
                UiColor(c255(style.textcolordisabled.r),c255(style.textcolordisabled.g),c255(style.textcolordisabled.b),c200(style.textcolordisabled.a))
            end
        
            UiTranslate(6,0)
            local w,h = UiGetTextSize(text)
            UiButtonImageBox('MOD',0,0,0,0,0,0)
            if(disabled) then
                UiPush()
                    UiColor(0.1,0.1,0.1,0.4)
                    UiTranslate(1,1)
                    if UiTextButton(text,w,height) then end
                UiPop()
            end
            UiDisableInput()
            if UiTextButton(text,w,height) then end
        UiPop()    
        UiButtonImageBox("MOD",1,1,1,1,1,0)
        if UiBlankButton(width, height+1) then onClick(extraContent) end
        if type(window) == "table" then
            uic_tooltipHitbox( width,height,window.tooltipActive ,tooltip, dt )
            if allowSpecialKeys == nil then allowSpecialKeys = {enabled = false} end
            if UiIsMouseInRect(width, height) then 
                if tooltip then draw_tooltip_text = tooltip; window.tooltipActive = true end
            else
                if window.tooltipActive then
                    draw_tooltip = false
                    draw_tooltip_params.popInTimer = 0
                    window.tooltipActive = false
                end
            end
        end

    UiPop()
end

---Create spin button
---@param key string
---@param direction string Display what direction this buttons
---@param disabled? boolean Disable to buttons
---@param onClick? function
---@param config? table
function uic_spinbuttons( key, direction, disabled, onClick, config )
    if config == nil then config = {
        min = nil, max = nil, autotranslate = nil, increments = 1
    } else
        if config.min == nil then config.min = nil end
        if config.max == nil then config.max = nil end
        if config.autotranslate then config.autotranslate = nil end 
        if config.increments == nil then config.increments = 1 end
        if config.buttonDirection == nil then config.buttonDirection = "Y" end
    end


    function buttonIcon(path, disabled , action)
        UiPush()
            local ico_w, ico_h = UiGetImageSize(path)
            local padding = 8
            UiWindow(ico_w+padding, ico_h+padding, false)
            UiAlign("left top")
            if not disabled then
                UiPush()
                UiTranslate(0,0)
                if UiBlankButton(ico_w+padding, ico_h+padding) then
                    action()
                end
                UiPop()
                UiPush()
                    if UiIsMouseInRect(ico_w+padding, ico_h+padding) then
                        if not InputDown('lmb') then
                            UiImageBox(tgui_ui_assets.."/textures/outline_outer_normal.png",ico_w+padding, ico_h+padding,1,1,1,1)
                        else
                            UiImageBox(tgui_ui_assets.."/textures/outline_inner_normal.png",ico_w+padding, ico_h+padding,1,1,1,1)
                            UiTranslate(1,1)
                        end
                    else
                        UiImageBox(tgui_ui_assets.."/textures/outline_outer_normal.png",ico_w+padding, ico_h+padding,1,1,1,1)
                    end
                UiPop()
                UiColor(1,1,1,1)
            else
                UiImageBox(tgui_ui_assets.."/textures/outline_outer_normal.png",ico_w+padding, ico_h+padding,1,1,1,1)
                UiColor(0.1,0.1,0.1,0.8)
            end
            UiTranslate((ico_w+padding)/2, (ico_h+padding)/2)
            UiAlign("center middle")
            UiImage(path)
        UiPop()
    end

    UiPush()
        local i = GetInt(key);
        local UPButtonDisabled = false;
        local DOWNButtonDisabled = false;
        if not disabled then
            if type(config.min) == "number" then if config.min >= i then DOWNButtonDisabled = true; end end
            if type(config.max) == "number" then if config.max <= i then UPButtonDisabled = true; end end
            if config.min == not nil then DOWNButtonDisabled = true; end    
            if config.max == not nil then UPButtonDisabled = true; end
        else
            UPButtonDisabled = true;
            DOWNButtonDisabled = true;
            UiColorFilter(1,1,1, 0.5)
        end
        function AddNum()
            if onClick == not nil then onClick() end
            if config.max == nil or config.max-1 >= i then 
                SetInt(key, i+config.increments)
            end
        end
        function LowerNum()
            if onClick == not nil then onClick() end
            if config.min == nil or config.min+1 <= i then 
                SetInt(key, i-config.increments)
            end
        end

        if config.buttonDirection == "X" then
            buttonIcon(tgui_ui_assets.."/textures/arrow_left.png", DOWNButtonDisabled, function()
                LowerNum()
            end)
            UiTranslate(18, 0)
            buttonIcon(tgui_ui_assets.."/textures/arrow_right.png", UPButtonDisabled, function()
                AddNum()
            end)
        else
            buttonIcon(tgui_ui_assets.."/textures/arrow_up.png", UPButtonDisabled, function()
                AddNum()
            end)
            UiTranslate(0, 18)
            buttonIcon(tgui_ui_assets.."/textures/arrow_down.png", DOWNButtonDisabled, function()
                LowerNum()
            end)
        end
        
    UiPop()
end

---Create spin controls
---@param key string key for the number
---@param w number
---@param disabled? boolean
---@param onClick? function
---@param config? table
function uic_spincontrol(key, direction, w, disabled, onClick, config)
    if config == nil then config = {
        min = nil, max = nil, autotranslate = false, increments = 1
    } end
    if config then
        if config.min == nil then config.min = nil end
        if config.max == nil then config.max = nil end
        if config.autotranslate == nil then config.autotranslate = false end 
        if config.increments == nil then config.increments = 1 end
    end

    function buttonIcon(path, disabled , action)
        UiPush()
            local ico_w, ico_h = UiGetImageSize(path)
            local paddingW = 8
            local paddingH = 4
            UiWindow(ico_w+paddingW, ico_h+paddingH, false)
            UiAlign("left top")
            if not disabled then
                UiPush()
                    UiTranslate(0,0)
                    if UiBlankButton(ico_w+paddingW, ico_h+paddingH) then
                        action()
                    end
                UiPop()
                UiPush()
                    if UiIsMouseInRect(ico_w+paddingW, ico_h+paddingH) then
                        if not InputDown('lmb') then
                            UiImageBox(tgui_ui_assets.."/textures/outline_outer_normal.png",ico_w+paddingW, ico_h+paddingH,1,1,1,1)
                        else
                            UiImageBox(tgui_ui_assets.."/textures/outline_inner_normal.png",ico_w+paddingW, ico_h+paddingH,1,1,1,1)
                            UiTranslate(1,1)
                        end
                    else
                        UiImageBox(tgui_ui_assets.."/textures/outline_outer_normal.png",ico_w+paddingW, ico_h+paddingH,1,1,1,1)
                    end
                UiPop()
                UiColor(1,1,1,1)
            else
                UiImageBox(tgui_ui_assets.."/textures/outline_outer_normal.png",ico_w+paddingW, ico_h+paddingH,1,1,1,1)
                UiColor(0.1,0.1,0.1,0.8)
            end
            UiTranslate((ico_w+paddingW)/2, (ico_h+paddingH)/2)
            UiAlign("center middle")
            UiImage(path)
        UiPop()
    end

    UiPush()
        UiPush()
            local i = GetInt(key);
            local UPButtonDisabled = false;
            local DOWNButtonDisabled = false;
            if not disabled then
                if type(config.min) == "number" then if config.min >= i then DOWNButtonDisabled = true; end end
                if type(config.max) == "number" then if config.max <= i then UPButtonDisabled = true; end end
                if config.min == not nil then DOWNButtonDisabled = true; end    
                if config.max == not nil then UPButtonDisabled = true; end
            else
                UPButtonDisabled = true;
                DOWNButtonDisabled = true;
                UiColorFilter(1,1,1, 0.5)
            end
            buttonIcon(tgui_ui_assets.."/textures/arrow_up.png", UPButtonDisabled, function()
                if onClick == not nil then onClick() end
                if config.max == nil or config.max-1 >= i then 
                    SetInt(key, i+config.increments)
                end
            end)
            UiTranslate(0, 12)
            buttonIcon(tgui_ui_assets.."/textures/arrow_down.png", DOWNButtonDisabled, function()
                if onClick == not nil then onClick() end
                if config.min == nil or config.min+1 <= i then 
                    SetInt(key, i-config.increments)
                end
            end)
        UiPop()
        UiTranslate(0, 0)
        UiPush()
            UiTranslate(17, 0)
            UiImageBox(tgui_ui_assets.."/textures/outline_inner_normal_dropdown.png", w, 24, 1, 1)
            -- TODO:make a textbox for a editable spin controls
            uic_text(GetInt(key), 24, 13)
        UiPop()
    UiPop()
end


---Make a divider ( like an hr in html )
---- ⚠ note: This function does not include `UiPush()` and `UiPop()`
---@param width integer Width of the divider
---@param flip boolean? Flup the divider texture
function uic_divider(width, flip)
    if flip then return UiImageBox(tgui_ui_assets..'/textures/line_outer.png',width,2,1,1) end
    return UiImageBox(tgui_ui_assets..'/textures/line_inner.png',width,2,1,1)
end

---Create a dropdown menu
---- ⚠ note: A registry will be added to the key: `.dropdwon.val` and `.dropdwon.text`
---@param width integer Width of the dropdown menu and window
---@param key string Key for each dropdown menu (if all keys are the same for all dropdown menus, every one of them will show the same selected item)
---@param items table List of items to display
---@param toolTipText string? not in use |Create a tooltip
function uic_dropdown(width, key, items, toolTipText)
    local he, scroll_width = 24, 24
    UiPush()
        UiFont(tgui_ui_assets.."/Fonts/TAHOMA.TTF", 13)
        UiImageBox(tgui_ui_assets.."/textures/outline_inner_normal_dropdown.png",width, he,1,1,1,1)
        UiColor(1,1,1,1)
        UiPush()
            UiAlign('top right')
            UiTranslate(0,0)
            UiTranslate(width-(scroll_width/2),he/2)
            UiAlign('center middle')
            UiImage(tgui_ui_assets.."/textures/dropdown_arrow.png")
        UiPop()
        UiPush()
            UiTranslate(0,he/2)
            UiAlign("left middle")
            uic_text(GetString(key..".dropdwon.text"), 24)
        UiPop()
        -- UiRect(width, he)
        if UiBlankButton(width, he) then
            draw_dropdown_pos.getCursor = true
            local cursor_x, cursor_y = UiGetMousePos()
            if draw_dropdown then draw_dropdown = false else
                draw_dropdown = true
                
                draw_dropdown_pos.posCalc.x = -cursor_x
                draw_dropdown_pos.posCalc.y = -cursor_y + 25
                
                draw_dropdown_contents = items
                draw_dropdown_pos.w = width
                draw_dropdown_extra = {
                    key=key
                }
            end
        end
    UiPop()    
end

---Create a progress bar like a loading bar
---@param w integer How many bars should there be
---@param current integer The current position of the progress
---@param total integer The total there is
---@param style? table Style the ui
---- `barColor` default: `{ r=255, g=156, b=0, a=1}`, color the bars
---- `BackgroundImageStyle.image` default: `tgui_ui_assets.."/textures/outline_inner_normal_dropdown.png"` background and border 
function uic_progressBar( w,current, total, style )
    if style == nil or style == {} then 
        style = {
            barColor = { r=255, g=156, b=0, a=1},
            BackgroundImageStyle = {
                image = tgui_ui_assets.."/textures/outline_inner_normal_dropdown.png",
            }
        }
    else
        if style.barColor == nil then style.barColor = { r=255, g=156, b=0, a=1} end
    end
    if style.BackgroundImageStyle == nil then 
        style.BackgroundImageStyle = {}
        if style.BackgroundImageStyle.image == nil then
            style.BackgroundImageStyle.image = tgui_ui_assets.."/textures/outline_inner_normal_dropdown.png"
        end
    end
    UiPush()
        if style.BackgroundImageStyle.image then
            UiPush()
                UiImageBox(style.BackgroundImageStyle.image,w*(11)+5, 24,1,1,1,1)
            UiPop()
        end
        UiTranslate(1,1);
        UiTranslate(2,3);
        UiPush()
            -- Credit: 1ssnl.
            local size = 9;local padding = 2;local progress = current/total;local j = w
            for i=1, j do
            if progress < i/j then break end
            UiPush()
            UiColor(c255(style.barColor.r), c255(style.barColor.g), c255(style.barColor.b), style.barColor.a)
            UiRect(9, 16)
            UiPop()        
            UiTranslate(size+padding, 0)
            end
        UiPop()
    UiPop()
end

---create slider
---@param window table the current window - make a table for this slider
---@param key string value
---@param range table `{min, max}`
---@param roundv number Round the value
---@param tooltip? string tooltip text
---@return number Value Slider value
---@return boolean Done Is done dragging
function uic_slider(window, dt ,w ,key,range,roundv, tooltip)
    local s, e = pcall(function() 
        if type(window) == "table" then 
        if window.tooltipActive == nil then window.tooltipActive = false end
        else error("slider Element: "..errorMessages.WindowAlerts.wrongType.."\n"..errorMessages.WindowAlerts.wrongType_example.."`content = function(window) ... uic_slider(window,...)`", 0) end
        -- DebugPrint(type(dt))
        if type(dt) == "number" then else 
            error("slider Element\ndt is not the corresponding type\nType:"..type(dt).." What is suspended to be: Number")
        end
        -- else error("window is missing/not the corresponding type.\nType:"..type(window)..". Make sure you have attached the first parameter with window ( the function parameter name ).") end
        -- Code from: Artzert´s Utilies -- Cedited: Artzert
        local function round(x, n)
            n = math.pow(10, n or 0); x = x * n; if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
            return x / n
        end
        
        local function optionsSlider(w,val, min, max, roundd)
            UiPush()
                val = (val-min) / (max-min)
                local done = false
                UiImageBox(tgui_ui_assets.."/textures/slider/outline_inner_sliderbar.png", w, 4, 1, 1)
                UiAlign("left middle")
                UiTranslate(-8, 2)
                val, done = UiSlider(tgui_ui_assets.."/textures/slider/Slider.png", "x", val*w, 0, w) / w
                UiTranslate(w*val, 23)
                val = round(val*(max-min)+min, roundd)
            UiPop()
            return val, done
        end
        --

        UiPush()
            UiWindow(w, 0, false)
            UiAlign("top left")
            UiPush()
                UiAlign("left middle")
                UiTranslate(0, 2)
                uic_tooltipHitbox( w,16,window.tooltipActive ,tooltip, dt )
                if allowSpecialKeys == nil then allowSpecialKeys = {enabled = false} end
                if UiIsMouseInRect(w, 16) then 
                    if tooltip then draw_tooltip_text = tooltip; window.tooltipActive = true end
                else
                    if window.tooltipActive then
                        draw_tooltip = false
                        draw_tooltip_params.popInTimer = 0
                        window.tooltipActive = false
                    end
                end
            UiPop()
            local val,done = optionsSlider(w ,GetInt(key) ,range[1], range[2], roundv)
            SetInt(key, val)
        UiPop()
        return val, done
    end)
    if not s then error("Slider Element\n"..e, 0) end
end

backspace_Timer = 5
backspace_Timer_cut = 0.1

function custom_UiInputText( string, w, h, window, dt )
    -- UiRect(w,h)
    local chars = {
        lower = "abcdefghijklmnopqrstuvwxyz1234567890-=[];',./`",
        upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+{}:\"<>?~"
    }

    if UiBlankButton(w,h) and window.focused == false then
        window.focused = true
    end
    if not UiIsMouseInRect(w,h) and InputPressed('lmb') and window.focused then
        window.focused = false
    end
    if window.focused then
        if dt then
            if InputDown('backspace') then
                backspace_Timer = backspace_Timer - dt/0.1
                if backspace_Timer <= 0 then
                    backspace_Timer = 0
                    -- --
                    backspace_Timer_cut = backspace_Timer_cut - dt/0.1
                    if backspace_Timer_cut <= 0 then
                        backspace_Timer_cut = 0.1
                        return string:sub(1, -2)
                    end
                end
            end
        end
        if not InputDown('backspace') then backspace_Timer = 5 end
    end
    if window.focused then
        if InputPressed("delete") or InputPressed('backspace') then
            return string:sub(1, -2)
        end
        if InputPressed("space") then
            return string.." "
        end
        for i = 0, string.len(chars.lower), 1 do
            local currLetter = string.sub(chars.lower, i, i)
    
            if(InputPressed(currLetter)) then
                if(InputDown("shift")) then
                    currLetter = string.sub(chars.upper, i, i)
                end

                return string .. currLetter
                -- lastInputTime = GetTime()
            end
        end 
    end

    return string
end

---Text Input
---@info Hright of textbox is 24
---@param key string Key for the input
---@param dt any delta time
---@param width integer width of the input
---@param window table Root window for the textbox
---@param style? table Style the textbox
---- `textAlgin` default: `left`, align text
---- `fontSize` default: 15, text size
---- `font` default: tgui_ui_assets.."/Fonts/TAHOMABD.TTF", Font path
---- `textColor` default: {r=255, g=255, b=255}
---- color range: rgb: 0 to 255
---@param tooltip? string Tooltip text
---@return string inputText Text input string
function uic_textbox(key , dt, width, window, tooltip, style )
    if type(window) == "table" then
    else
        error("TextBox Element: WINDOW MISSING\nA Window with a table is required for this to function as intended", 0)
    end
    if dt then else 
        error("TextBox Element: dt MISSING\nThis parameter is required for this to function as intended\nhave `function draw(dt) end` at the start of the draw function and the param to this element param", 0)
    end
    if window then
        if window.focused == nil then window.focused =false end
    end
    if style == nil then
        style = {
            textAlgin = "left",
            fontSize = 15,
            font = tgui_ui_assets.."/Fonts/TAHOMA.TTF",
            textColor = {r=255, g=255, b=255}
        }
    else
        if style.textAlgin == nil then style.textAlgin = "left" end
        if style.fontSize == nil then style.fontSize = 15 end
        if style.font == nil then style.font = tgui_ui_assets.."/Fonts/TAHOMA.TTF" end
        if style.textColor == nil then style.textColor = {r=255, g=255, b=255} end
    end
    UiPush()
        uic_tooltipHitbox( width,24,window.tooltipActive ,tooltip, dt )
        if allowSpecialKeys == nil then allowSpecialKeys = {enabled = false} end
        if UiIsMouseInRect(width, 24) then 
            if tooltip then draw_tooltip_text = tooltip; window.tooltipActive = true end
        else
            if window.tooltipActive then
                draw_tooltip = false
                draw_tooltip_params.popInTimer = 0
                window.tooltipActive = false
            end
        end
        UiFont(style.font, 15)
        UiImageBox(tgui_ui_assets.."/textures/outline_inner_normal_dropdown.png",width, 24,1,1,1,1)
        local tW,tH = UiGetTextSize(GetString(key))
        UiPush()
            UiDisableInput()
            UiAlign('top right')
            UiTranslate(width,0)
            UiButtonImageBox('MOD',0,0,0,0,0,0)
            UiFont(tgui_ui_assets.."/Fonts/TAHOMABD.TTF", 12)
            UiTranslate(0,1)
            UiColor(0,0,0,1)
            UiRect(13,22)
            UiColor(1,1,1,1)
            UiTextButton('EN',13,22)
        UiPop()
        SetString(key, custom_UiInputText(GetString(key), width , 24 , window, dt))
        if tW >= width-13 then
            if style.textAlgin == 'center' then
                UiWindow(width,24,true,true)
                UiTranslate(width-tW-13,0)
            elseif style.textAlgin == 'left' then
                UiWindow(width,24,true, true)
                UiTranslate(width-tW-13,0)
            end
        else end
        if style.textAlgin == 'right' then
            UiWindow(width,24,true,true)
            UiTranslate(width-tW-13,0)
        end
        UiTranslate(0,0)
        UiAlign('top left')
        UiDisableInput()
        UiPush()
            if style.textAlgin == 'center' then
                if tW <= width-13 then
                    UiTranslate((width/2)-8, 0);
                    UiAlign("top center")
                end
            elseif style.textAlgin == 'right' then

            end
            UiColor(c255(style.textColor.r), c255(style.textColor.g), c255(style.textColor.b), 1)
            uic_text(GetString(key),24,style.fontSize, {
                font = style.font,
            })
        UiPop()
        local inputReturn = GetString(key)
    UiPop()
    return inputReturn
end

-- function uic_Register_Contextmenu_at_cursor( contents, extraContents, row )
function uic_Register_Contextmenu_at_cursor( contents, x_calc, y_calc )
    if not x_calc then
        x_calc = 0
    end
    if not y_calc then
        y_calc = 0
    end
    uic_contextMenu_getCursor = true
    uic_draw_contextmenu = true
    uic_draw_contextmenu_row = false
    uic_contextMenu_contents.items = {}
    table.insert(uic_contextMenu_contents.items, {
        w=200, h=0, x_calc=x_calc, y_calc=y_calc,
        c = contents,
    })
end
function uic_Register_Contextmenu_at_pos( x, y, contents, extraContents )
    -- dividers
    uic_contextMenu_getCursor = false
    uic_draw_contextmenu = true
    uic_draw_contextmenu_row = false
    uic_contextMenu_contents.items = {}
    
    table.insert(uic_contextMenu_contents.items, {
        w=200, h=0, x=x,y=y, getCursor = false,
        c = contents,
        extrac = extraContents
    })
end
function BoolToString(b) 
    return b and "True" or "False";
end


--###############--


--[[
████████╗░██████╗░██╗░░░██╗██╗  ░██████╗░░█████╗░███╗░░░███╗███████╗  ███╗░░░███╗███████╗███╗░░██╗██╗░░░██╗
╚══██╔══╝██╔════╝░██║░░░██║██║  ██╔════╝░██╔══██╗████╗░████║██╔════╝  ████╗░████║██╔════╝████╗░██║██║░░░██║
░░░██║░░░██║░░██╗░██║░░░██║██║  ██║░░██╗░███████║██╔████╔██║█████╗░░  ██╔████╔██║█████╗░░██╔██╗██║██║░░░██║
░░░██║░░░██║░░╚██╗██║░░░██║██║  ██║░░╚██╗██╔══██║██║╚██╔╝██║██╔══╝░░  ██║╚██╔╝██║██╔══╝░░██║╚████║██║░░░██║
░░░██║░░░╚██████╔╝╚██████╔╝██║  ╚██████╔╝██║░░██║██║░╚═╝░██║███████╗  ██║░╚═╝░██║███████╗██║░╚███║╚██████╔╝
░░░╚═╝░░░░╚═════╝░░╚═════╝░╚═╝  ░╚═════╝░╚═╝░░╚═╝╚═╝░░░░░╚═╝╚══════╝  ╚═╝░░░░░╚═╝╚══════╝╚═╝░░╚══╝░╚═════╝░
Name: TGUI Game Menu
Tags: Ui Library
]]
-- -@return integer height Height of the menu

---Make a list of buttons
---@param t table A controller for the list of buttons and the height 
---@param width integer Width of the menu 
---@param contents table Lists of buttons
---@param extraContent any Additional content to be called to the list
---@param style table? `table` customize the menu style
---- `textAlgin` Default: "left" params: "left"|"center"|"right"
---- `buttonHeight` Default: 14 `number`
---- `fontSize` Default: 13 `number`
---- `font` Default: `tgui_ui_assets.."/Fonts/TAHOMABD.TTF"` - `string`
---```
----- format: contents
---{
--- {
---  text = "text", 
---  action = function(extraContent) end
--- }, 
--- ...
---}
---```
function uic_CreateGameMenu_Buttons_list(t, width ,contents, extraContent, style)
    if style == nil then
        style = {textAlgin = "left", buttonHeight = 14, fontSize = 13, font = tgui_ui_assets.."/Fonts/TAHOMABD.TTF", centerButtons = false}
    else
        if style.textAlgin == nil    then style.textAlgin = "left"   end
        if style.buttonHeight == nil then style.buttonHeight = 14    end
        if style.fontSize == nil     then style.fontSize = 13        end
        if style.font == nil         then style.font = tgui_ui_assets.."/Fonts/TAHOMABD.TTF" end
        if style.centerButtons == nil then style.centerButtons = false end
    end

    local UIC_height = 0
    UiPush()
        UiWindow(width,t.h,false)
        for i,v in ipairs(contents) do
            if style.textAlgin == "left"   then UiAlign("top left")    end
            if style.textAlgin == "center" then UiAlign('top center')  end
            if style.textAlgin == "right"  then UiAlign('top right')   end
            if UiBlankButton(width,style.buttonHeight) then 
                if v.action == nil then  --[[NO ACTION]] else v.action(extraContent) end
            end
            if uic_debug_show_hitboxes_gameMenu then
                UiPush()
                    UiColor(0,0,1,0.5)
                    UiRect(width,14)
                UiPop()
            end
            UiPush()
                uic_text(v.text, style.buttonHeight, style.fontSize, {
                    font = style.font
                })
            UiPop()
            if style.buttonHeight < 20 then
                UiTranslate(0,28)
                UIC_height = UIC_height + 24
            else
                UIC_height = UIC_height + (style.buttonHeight+4)
                UiTranslate(0,style.buttonHeight+8)
            end
        end
    UiPop()
    if style.centerButtons then t.h = UIC_height end
    return UIC_height
end

uilib = {}
function uilib:new()
    local self = {

    }

    self.method = function(e,d)
        UiRect(24,24)
    end

    return self
    -- return {
    -- }
end