--[[

████████╗░██████╗░██╗░░░██╗██╗  ██╗░░░██╗██╗  ██╗░░░░░██╗██████╗░██████╗░░█████╗░██████╗░██╗░░░██╗
╚══██╔══╝██╔════╝░██║░░░██║██║  ██║░░░██║██║  ██║░░░░░██║██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚██╗░██╔╝
░░░██║░░░██║░░██╗░██║░░░██║██║  ██║░░░██║██║  ██║░░░░░██║██████╦╝██████╔╝███████║██████╔╝░╚████╔╝░
░░░██║░░░██║░░╚██╗██║░░░██║██║  ██║░░░██║██║  ██║░░░░░██║██╔══██╗██╔══██╗██╔══██║██╔══██╗░░╚██╔╝░░
░░░██║░░░╚██████╔╝╚██████╔╝██║  ╚██████╔╝██║  ███████╗██║██████╦╝██║░░██║██║░░██║██║░░██║░░░██║░░░
░░░╚═╝░░░░╚═════╝░░╚═════╝░╚═╝  ░╚═════╝░╚═╝  ╚══════╝╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░

Name: TGUI UI Library
Version: 0.4
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
uic_tooltip_hover_timer,uic_tooltip_hover_id = 1,0


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

function tick( ... )
    -- DebugWatch('showDropDown',showDropDown)
    -- DebugWatch('id_open',id_open)
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

---This function must be called after all of the ui
function uic_tooltip()
    UiPush()
        if not uic_tooltip_enabled then
            mouse_x,mouse_y = UiGetMousePos()
        end
        if uic_tooltip_enabled then
            UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMABD.TTF", 12)
            local t_text_w,t_text_h = UiGetTextSize(uic_tooltip_text)
            UiAlign('top left')
            UiTranslate(mouse_x,mouse_y +20)
            UiImageBox('MOD/ui/TGUI_resources/textures/hint.png',t_text_w,t_text_h,1,1)
            UiColor(c255(136),c255(84),c255(30),1)
            UiText(uic_tooltip_text)
        end
    UiPop()
end

---Creates a window
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
            UiColor(c255(160), c255(160), c255(160),c200(128))
            UiRect(width ,height)
            UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMABD.TTF", 12)
            UiTranslate(16,8)
            UiColor(1,1,1,1)
            UiText(title)
        UiPop()
        UiTranslate(0,32)
        UiWindow(width,height-32,clip)
        -- UiRect(UiWidth(),padding)
        -- UiRect(padding,UiHeight())
        UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF", 15)
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

--[[ widgets ]]

---Create a container widget
---@note There is a `UiTranslate(0,h)` at the end of the function
---@param width integer Width of the container
---@param height integer Height of the container
---@param clip boolean Clip content outside window. Default is false
---@param border boolean Adds the border to the container
---@param content function function: UI
---@param ectraContent any Additional content to be called to the container
function uic_container(width,height,clip,border,makeinner,content, ectraContent)
    UiPush()
        UiWindow(width,height,clip)
        if border then
            if makeinner then
                UiImageBox('MOD/ui/TGUI_resources/textures/outline_inner_normal.png',width,height,1,1)
            else
                UiImageBox('MOD/ui/TGUI_resources/textures/outline_outer_normal.png',width,height,1,1)
            end
        end
        if(border) then
            UiTranslate(6,6)
            UiWindow(width-12,height-12,clip)
        end
        UiPush()
            content(ectraContent)
        UiPop()    
    UiPop()    
    UiTranslate(0,height)
end


---Make a scroll container
---@param window table The the window
---@param w integer width of the scroll area
---@param h integer height of the scroll area
---@param border boolean whether to have the border or not
---@param scroll_height integer How much this container can be scrolled
---@param content function Content to the scroll area container
---@param extraContent any Additional content to be called to the container
function uic_scroll_Container(window,w,h,border,scroll_height, content, extraContent)
    if window.scrollfirstFrame then
        window.scrollPos = 0
        
        window.scrollfirstFrame = false
    end
    
    local scroll = window.scrollPos
    UiPush()
        if border then
            UiImageBox('MOD/ui/TGUI_resources/textures/outline_outer_normal.png',w,h,1,1)
        end
        UiPush()
            local max_scroll = 0
            if scroll_height > h then
                max_scroll = h - scroll_height else
                max_scroll = 0
            end
            if UiIsMouseInRect(w,h) then
                if UiIsMouseInRect(w,h) then
                    local scroll = InputValue('mousewheel')*10
                    local scrollTest = 0
                    scrollTest = window.scrollPos + scroll
                    if window.scrollPos >= 0 then
                        window.scrollPos = 0
                    end
                    if window.scrollPos <= max_scroll then
                        window.scrollPos = max_scroll
                    end
                    if scroll > -1 then
                        if scrollTest < 1 then
                            window.scrollPos = window.scrollPos + scroll
                        end
                    end
                    if scroll < 1 then
                        if scrollTest+1 > max_scroll then
                            window.scrollPos = window.scrollPos + scroll
                        end
                    end
                end
            end
        UiPop()
        local is_overflow = false
        if scroll_height > h then
            is_overflow = true
        end
        if UiIsMouseInRect(w,h) then
        else
            UiDisableInput()
        end
        UiPush()
            UiPush()
                UiPush()    
                    if is_overflow == false then
                        UiColor(1,1,1,0.3)
                    end
                    UiAlign('center middle')
                    UiPush()    
                        UiTranslate(w-(17/2),10)
                        UiImage('MOD/ui/TGUI_resources/textures/arrow_up.png',image)
                    UiPop()
                    UiPush()    
                        UiTranslate(w-(17/2),h-10)
                        UiImage('MOD/ui/TGUI_resources/textures/arrow_doen.png',image)
                    UiPop()
                UiPop()
                if is_overflow then
                    UiPush()    
                        -- scrollAndDrag( w,h, scroll_height, 5, 1, window )
                        -- -- 191 W:17

                        -- NOTE: Scroll bar size will go to one px height if the value goes under 1
                        -- TODO: make the scroll bar really accurate on how big the scroll area is
                        local factor = scroll_height/(h-20)

                        UiAlign('top left')
                        UiTranslate(0,17)
                        UiTranslate(w-17,0)
                        UiColor(c255(191), c255(191), c255(191), 0.5)
                        UiRect(17,h-17-17)
                        local factor;
                        local bar_scroll=scroll*((h-34)/(scroll_height-34))

                        local viewportRatio = h / scroll_height
                         
                        local scroll_bar_height = math.max(34, math.floor((h-34)*viewportRatio))

                        -- local scroll_bar_height=(max_scroll*(h-34)/scroll_height)
                        -- local scroll_bar_height=math.min(scroll_bar_height,h)
                        UiColor(c255(191), c255(191), c255(191), 1)
                        UiTranslate(0,-bar_scroll)
                        UiColor(1,1,1,1)
                        -- if (scroll_bar_height+h-(17*2)) > 1 then
                            UiImageBox('MOD/ui/TGUI_resources/textures/outline_inner_normal.png',17,(scroll_bar_height-7),1,1)
                        -- else
                            -- UiImageBox('MOD/ui/TGUI_resources/textures/outline_inner_normal.png',17,2,1,1)
                        -- end
                    UiPop()
                else
                end
            UiPop()
            UiWindow(w,h-1,true)
            if scroll_height > h then
                UiWindow(w-17,scroll_height-5,false)
                UiTranslate(0,scroll)
            else
                max_scroll = 0
            end
            content(extraContent)
        UiPop()
    UiPop()
end

---Create a tab container widget
---@note There is a `UiTranslate(0,h)` at the end of the function
---@param window function Get the window object for the widget
---@param w integer Width of the container tab
---@param h integer Height of the container tab
---@param clip boolean Clip content outside window. Default is false
---@param border boolean Adds the border of the tab container
---@param contents table Create ui with different tabs: `{["open_default"]=1 [0] = {["title"]="text",["content"]=function() end}, ...}`
---@param extraContent any Additional content to be called to the container and all the available tabs
function uic_tab_container(window, w,h,clip,border,contents, extraContent)
    local line_width = w
    UiPush()
        UiWindow(w,h,clip)
        UiPush()
            UiPush()
                UiTranslate(0,24)
                if border then
                    UiImageBox('MOD/ui/TGUI_resources/textures/outline_outer_tab_container.png',w,h-24,1,1)
                end
            UiPop()
            UiButtonImageBox('MOD',0,0,0,0,0,0)
            
            local all_tab_width = 0
            local tab_height = 25
            local right_padding = 20
            if window.tabFirstFrame == true then
                window.tabOpen = contents["open_default"]
                window.overflow = false
                window.tabScroll = 0
                window.tabFirstFrame = false
            end
            UiPush()
            UiWindow(w,tab_height+1,true)
            if window.overflow then
                if UiIsMouseInRect(w,tab_height+1) then else
                    UiDisableInput()
                end
            end
            UiTranslate(window.tabScroll,0)
            for i=1,#contents do
                UiPush()
                    tab_width = 0 
                    tab_text_w,_ = UiGetTextSize(contents[i]["title"])
                    UiPush()
                        local removeHeight = 3
                        if window.tabOpen == i then
                            removeHeight = 0
                        end
                        UiAlign('bottom left')
                        UiTranslate(0,tab_height)
                        tab_width = tab_text_w+right_padding
                        UiWindow(width,height,clip)
                        UiImageBox('MOD/ui/TGUI_resources/textures/outline_outer_tab.png',tab_width,tab_height-removeHeight,1,1)
                        UiTextButton(contents[i]["title"],tab_text_w,tab_height-removeHeight)
                        if UiBlankButton(tab_width,tab_height-removeHeight) then 
                            window.tabOpen = i
                        end
                        if removeHeight == 3 then
                            UiImageBox('MOD/ui/TGUI_resources/textures/line_white.png',tab_width,1,0,0)
                        end
                        UiAlign('top left')
                        UiPush()
                            -- DebugPrint(#contents.." == "..i)
                            last = #contents - 0
                            if last > i then
                                UiPush()
                                    UiTranslate(tab_width,-1)
                                    UiImageBox('MOD/ui/TGUI_resources/textures/line_white.png',1,1,0,0)
                                UiPop()        
                            end
                            UiPush()
                                UiTranslate(0,0)
                                if window.tabOpen == i then
                                    UiPush()
                                        UiTranslate(tab_width-1,-1)
                                        UiImageBox('MOD/ui/TGUI_resources/textures/line_dark.png',1,1,0,0)
                                    UiPop()
                                    if window.tabOpen >= 2 then
                                        UiPush()
                                            UiTranslate(0,-1)
                                            UiImageBox('MOD/ui/TGUI_resources/textures/line_white.png',1,1,0,0)
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
                            UiImage('MOD/ui/TGUI_resources/textures/tabs_arrow_right.png',image)
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
                            UiImage('MOD/ui/TGUI_resources/textures/tabs_arrow_left.png',image)
                        UiPop()
                        UiAlign('right top')
                        if UiBlankButton(10,tab_height) then
                            local scroll = 10
                            window.tabScroll = window.tabScroll + scroll
                        end
                    UiPop()
                end

                if window.tabScroll >= 0 then
                    window.tabScroll = 0
                end
                if window.tabScroll <= -max_scroll then
                    window.tabScroll = -max_scroll
                end
                if UiIsMouseInRect(w,tab_height+1) then
                    local scroll = InputValue('mousewheel')*10
                    window.tabScroll = window.tabScroll + scroll
                end
            end
        UiPop()
        UiPush()
        if w > all_tab_width then
            UiTranslate(all_tab_width-1,24)
            UiImageBox('MOD/ui/TGUI_resources/textures/line_white.png',line_width,1,0,0)
        end
        UiPop()    
        if(border) then
            UiTranslate(1,tab_height)
            UiWindow(w-2,h-tab_height-1,true)
        end
        UiPush()
            contents[window.tabOpen]["Content"](extraContent)
        UiPop()
    UiPop()    
    UiTranslate(0,h)
end

---[[ UI ]]

---Create a checkbox
---@param text string Display text
---@param key string Key for the checkbox
---@param hitWidth integer Changes width of the hitbox for the checkbox
---@param beDisabled boolean Make it disabled and unchecable
function uic_checkbox(text, key, hitWidth, beDisabled, toolTipText)
    UiPush()
        UiWindow(0,12,false	)
        UiAlign('left top')
        UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF", 15)
        UiButtonImageBox('',1,1,1,1,1,1)
        UiImageBox("MOD/ui/TGUI_resources/textures/outline_inner_special_checkbox.png",12, 12,1,1,1,1)
        UiButtonImageBox(' ',0,0,0,0,0,0)
        tx_s_w,no_v_h = UiGetTextSize(text)
        UiPush()
            UiColor(1,1,1,1)
            UiTranslate(-6,-4)
            if uic_debug_checkHit then
                UiColor(1,1,1,0.2)
                UiRect(6 + no_v_h + hitWidth,20)
                UiColor(1,1,1,1)
            end
            if UiBlankButton(6 + no_v_h + hitWidth,20) then
                if GetBool(key) then
                    SetBool(key,false)
                else
                    SetBool(key,true)
                end
            end
        UiPop()
        if GetBool(key) then
            UiImage('MOD/ui/TGUI_resources/textures/checkmark.png')
        else
            UiTranslate(-6,-4)
            if UiIsMouseInRect(6 + no_v_h + hitWidth,20) then
                UiColor(0.95,0.95,0.95,1)
            end
            UiTranslate(6,4)
        end
        UiAlign('left middle')
        UiTranslate(12,5)
        UiDisableInput()
        if UiTextButton(text,0,12) then end
    UiPop()
end

---Create a button
---@param buttinid integer id of the button
---@param text string Display text on the button
---@param width integer Width of the button
---@param height integer Height of the button
---@param disabled integer Disable the button
---@return boolean boolean Returns true if the button is released, none otherwise
function uic_button(buttinid, text, width, height, disabled, toolTipText)
    UiPush()
        UiWindow(width, height, false)
        UiAlign("left top")
        UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF", 14)
        if disabled then
            UiDisableInput()
        end
        UiPush()
            if not disabled then
                if UiIsMouseInRect(width, height) then
                    if not InputDown('lmb') then
                        UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",width, height,1,1,1,1)
                    else
                        UiImageBox("MOD/ui/TGUI_resources/textures/outline_inner_normal.png",width, height,1,1,1,1)
                        UiTranslate(1,1)
                    end
                else
                    UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",width, height,1,1,1,1)
                end
                UiColor(1,1,1,1)
            else
                UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",width, height,1,1,1,1)
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
---@param buttinid integer id of the button
---@param text string Display text on the button
---@param width integer Width of the button
---@param height integer Height of the button
---@param disabled integer Disable the button
---@param onClick function Do something when on the button on click
---@param extraContent any Additional content to be called to the button
function uic_button_func(buttinid, text, width, height, disabled, toolTipText, onClick, extraContent)
    UiPush()
        UiWindow(width, height, false)
        UiAlign("left top")
        UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF", 14)
        if disabled then
            UiDisableInput()
        end
        UiPush()
            if not disabled then
                if UiIsMouseInRect(width, height) then
                    if not InputDown('lmb') then
                        UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",width, height,1,1,1,1)
                    else
                        UiImageBox("MOD/ui/TGUI_resources/textures/outline_inner_normal.png",width, height,1,1,1,1)
                        UiTranslate(1,1)
                    end
                else
                    UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",width, height,1,1,1,1)
                end
                UiColor(1,1,1,1)
            else
                UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_normal.png",width, height,1,1,1,1)
                UiColor(0.1,0.1,0.1,0.8)
            end
        
            UiTranslate(6,0)
            local w,h = UiGetTextSize(text)
            UiButtonImageBox('MOD',0,0,0,0,0,0)
            if UiTextButton(text,w,height) then onClick(extraContent) end
        UiPop()    
        UiButtonImageBox("MOD",1,1,1,1,1,0)
        if UiBlankButton(width, height) then onClick(extraContent) end

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


---Make a divider ( like an hr in html )
---@note This function does not include `UiPush()` and `UiPop()`
---@param width integer Width of the divider
---@param flip boolean Flup the divider texture
function uic_divider(width, flip)
    if flip then return UiImageBox('MOD/ui/TGUI_resources/textures/line_outer.png',width,2,1,1) end
    return UiImageBox('MOD/ui/TGUI_resources/textures/line_inner.png',width,2,1,1)
end

dropdown_height = 0 
---Create a dropdown menu
---@note A registry will be added to the key: `.dropdwon.val`
---@param id integer Id makes it able to check if other dropdown menus are open and automatically closes one if opened
---@param width integer Width of the dropdown menu and window
---@param key string Key for each dropdown menu (if all keys are the same for all dropdown menus, every one of them will show the same selected item)
---@param items table List of items to display
---@param items_keys table List of items to set the current key value, example "`key.item = 'item 1'` or `savegame.quote = 'I'd like to have a coffee'` "
---@param goUp boolean Instead of the dropdown menu spawning below, it spawns on top. (used if there is no space on the bottom)
---@param toolTipText string Create a tooltip
function uic_dropdown(id, width, key, items, items_keys, goUp, toolTipText)
    UiPush()
        local he = 24
        local scroll_width = 12
        UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMA.TTF", 15)
        UiImageBox("MOD/ui/TGUI_resources/textures/outline_inner_normal_dropdown.png",width, he,1,1,1,1)
        UiColor(1,1,1,1)
        UiPush()
            UiAlign('top right')
            UiTranslate(width,0)
            UiWindow(scroll_width,he,true)
            UiRect(UiWidth(),UiHeight())
            UiTranslate(UiCenter(),UiMiddle())
            UiAlign('center middle')
            UiImage('MOD/ui/TGUI_resources/textures/dropdown_arrow.png')
        UiPop()
        UiPush()
            UiTranslate(0,he/2)
            UiAlign("left middle")
            UiText(GetString(key..".dropdwon.val"))
        UiPop()    
        UiButtonImageBox("MOD",1,1,1,1,1,0)
        if UiBlankButton(width, he) then
            if showDropDown and id_open == id then showDropDown = false else showDropDown = true end
            id_open = id
        end
        if UiIsMouseInRect(width, he) then
            if showDropDown == false then
                for i=1, #items do
                    local bu_he = 18 
                    w,dropdown_height = he,bu_he
                    dropdown_height = (i+1)+dropdown_height*i
                end
            end
            if toolTipText ~= nil then
                if uic_tooltip_enabled == false then
                    if uic_tooltip_hover_timer == 1 then
                        SetValue('uic_tooltip_hover_timer',0,"linear",0.75)
                        uic_tooltip_hover_id = id
                        uic_tooltip_text = toolTipText
                    end
                    if uic_tooltip_hover_timer == 0 then
                        uic_tooltip_enabled = true
                    end
                end
            end
        else
            if uic_tooltip_hover_id == id then
                if uic_tooltip_hover_timer == 0 then
                    uic_tooltip_hover_timer = 1
                    uic_tooltip_enabled = false
                end
            end
        end
        if showDropDown then
            if id_open == id then
                UiPush()
                    if goUp then
                        UiAlign('left top')
                        UiWindow(width,0,false)
                        UiTranslate(0,-dropdown_height-he-3)
                        UiPush()
                            UiTranslate(0,he)
                            if not UiIsMouseInRect(width,he+dropdown_height) then
                                if InputReleased('lmb') then showDropDown = false end
                            end
                        UiPop()
                    else
                        if not UiIsMouseInRect(width,he+dropdown_height) then
                            if InputReleased('lmb') then showDropDown = false end
                        end
                    end
                    UiTranslate(0,he+1)
                    UiImageBox("MOD/ui/TGUI_resources/textures/outline_outer_special_dropdown.png",width, dropdown_height+1,1,1,1,1)
                    if goUp then
                        UiAlign('left top')
                    end
                    UiTranslate(0,1)
                    for i=1, #items do
                        local bu_he = 18 
                        w,dropdown_height = he,bu_he
                        if UiIsMouseInRect(width-scroll_width,bu_he) then
                            UiPush()
                                UiTranslate(1,0)
                                UiColor(c255(255),c255(156),c255(0),1)
                                UiRect(width-2-scroll_width,dropdown_height)
                            UiPop()
                        end
                        UiColor(1,1,1,1)
                        UiText(items[i])
                        if UiBlankButton(width,bu_he) then
                            showDropDown = false
                            SetString(key,items_keys[i])
                            SetString(key..".dropdwon.val",items[i])
                        end
                        UiTranslate(0,bu_he)
                        dropdown_height = dropdown_height*i+1
                    end
                UiPop()
            end
        end
    UiPop()
end

function uic_slider(key,min,max)
    UiPush()
        SetFloat(key,UiSlider("MOD/ui/TGUI_resources/textures/Slider/Slider.png",'x',GetFloat(key),min,max))
    UiPop()
end
