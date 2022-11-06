---@diagnostic disable: undefined-global
--[[

████████╗░██████╗░██╗░░░██╗██╗  ███╗░░░███╗░█████╗░███╗░░██╗░█████╗░░██████╗░███████╗██████╗░
╚══██╔══╝██╔════╝░██║░░░██║██║  ████╗░████║██╔══██╗████╗░██║██╔══██╗██╔════╝░██╔════╝██╔══██╗
░░░██║░░░██║░░██╗░██║░░░██║██║  ██╔████╔██║███████║██╔██╗██║███████║██║░░██╗░█████╗░░██████╔╝
░░░██║░░░██║░░╚██╗██║░░░██║██║  ██║╚██╔╝██║██╔══██║██║╚████║██╔══██║██║░░╚██╗██╔══╝░░██╔══██╗
░░░██║░░░╚██████╔╝╚██████╔╝██║  ██║░╚═╝░██║██║░░██║██║░╚███║██║░░██║╚██████╔╝███████╗██║░░██║
░░░╚═╝░░░░╚═════╝░░╚═════╝░╚═╝  ╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝░╚═════╝░╚══════╝╚═╝░░╚═╝

Name: TGUI Manager
Version: 0.8
Author: AlexVeeBee
Credit: MrJaydanOz
How it works:
Requirements:
How to import:
Valve´s original creation: VGUI ( Valve's proprietary Graphical User Interface )
]]


---_
local TGUI_has_error, TGUI_error_message, TGUI_icon_fade, TGUI_icon_fade_direction, TGUI_icon_fade_loopcounter = false, nil, 1, "down", 0;
local ScreenWidth, ScreenHeight = 0, 0;

---_
MaxWindowPos = {w = 0,h = 0,}
-- function file_exists(name)
--     local f, e loadfile(name)

--     if not f then
--         return false
--     else return true end
-- end

---@param TABLEwindows table What table this window should display on
function aboutTGUI(TABLEwindows,dt)
    if TABLEwindows == nil then 
        error("This parameter is required to display this window\nParam missing table")
        return
    end
    if type(TABLEwindows) == "table" then 
        table.insert(TABLEwindows ,{
            firstFrame = true,
            title = "About TGUI",
            padding = 0, -- Padding left and right
            pos = {x = 0, y = 0},
            size = {w = 598, h = 132},
            minSize = {w = 0, h =0},
            startMiddle = true, allowResize = false,
            clip = false, content = function(window)
                UiPush()
                    UiTranslate(12,0)
                    UiText('TGUI - A VGUI Recreation')
                    UiTranslate(0,24)
                    UiText('Ported by: AlexVeeBee and NeoLights')
                    UiTranslate(0,16)
                    UiText('Valve´s original creation: VGUI ( Valve\'s proprietary Graphical User Interface )')
                UiPop()
                UiPush()
                    UiAlign("bottom right")
                    UiTranslate(UiWidth()-12,UiHeight()-12)
                    uic_button_func(_,dt,"Close", 100,24,false,"", function (window)
                        window.closeWindow = true
                    end, window)
                UiPop()
            end
        })
    end
end

local opacityEnabled = false
local showSlicing = false
local windowSlice = { x = 13/2, y = 13/2}
lastMouse = { x = 0, y = 0 }
lastClick = { x = 0, y = 0 }
lastClickWindow = 0

isFirstFrame = true

deleteTimer = 0

local pos = {}
local got_ver = false;

---TGUI MANAGER: UI INIT
-----------------------------
---@param TABLEwindows table Where all the windows are stored
---@param dt any Delta time
---@param style? table Style the window
---Manager for creating a window and moving it
--
--- Params to create a window
--
------------------
--- options:
----
---- window param: focused - Focused window
---- closeWindow - Close the window.
---- options: startMiddle - Start in the middle of your screen.
---- options: allowResize - default: true - Allow the window to be resized.
---- disableCloseButton: boolean - hide the close button
------------------
--- half important:
----
---- options: tabFirstFrame - if you have a tab widget, then this must be added
------------------
--- Important:
----
---- important: firstFrame = true - adds options in the first frame
---- important: padding - adds padding around the window
---- important: title - Title of the window
---- important: pos = `{x = (int), y = (int)}` - Position of the window
---- important: size = `{w = (int), h = (int)}` - Size of the window
------------------ 
--- style:
----
--- color format: 255 range - Alpha range: 200
---- `style.focusBackgroundColor` default: `{r=160,g=160,b=160,a=150}` - 
---- `style.unfocusedBackgroundColor` default: `{r=28,g=28,b=28,a=64}` - 
---- `style.TitleBar.titleColor` default: `{r=255,g=255,b=255,a=200}` -
function initDrawTGUI( TABLEwindows, dt, style )
    SetString("TGUI.Version","0.8.9-5 - ALPHA");

    function winError( err )
        if TGUI_has_error == false then
            TGUI_has_error = true
            TGUI_error_message = err
        end
    end
    if style == nil then
        style = {
            focusBackgroundColor = {r=160,g=160,b=160,a=150},
            unfocusedBackgroundColor = {r=28,g=28,b=28,a=64},
            -- WindowTitleFont 
            TitleBar = {
                titleColor = {r=255,g=255,b=255,a=200},
                padding = 0
            }
        }
    end
    if style then
        if style.focusBackgroundColor == nil then style.focusBackgroundColor = {r=160,g=160,b=160,a=150} end
        if style.unfocusedBackgroundColor == nil then style.unfocusedBackgroundColor = {r=28,g=28,b=28,a=64} end
        if style.TitleBar == nil then
            style.TitleBar = {}
            if style.TitleBar.titleColor == nil then style.TitleBar.titleColor = {r=255,g=255,b=255,a=200} end
            if style.TitleBar.padding == nil then style.TitleBar.padding = 0 end
        end
    end
    if GetBool('tgui.disableInput') then
        if opacityEnabled == false then
            SetValue('globalWindowOpacity',0.3,"linear",0.3)
            opacityEnabled = true
        end
    else
        if opacityEnabled then
            SetValue('globalWindowOpacity',1,"linear",0.3)
            opacityEnabled = false
        end
    end
    if TABLEwindows == nil then 
        UiPush()
            UiEnableInput() UiMakeInteractive() UiMute(1)
            UiTranslate(UiCenter(),0)
            UiAlign('center top')
            UiColor(0,0,0,1)
            UiRect(UiWidth(),UiHeight())
            UiColor(1,1,1,1)
            UiFont(tgui_ui_assets.."/Fonts/TAHOMABD.TTF", 24)
            UiTranslate(0,UiMiddle()-100)
            UiText('[TGUI.MANAGER]: missing argument',18)
            UiTranslate(0,24)
            UiText('Please add a table to the first param of this function',18)
        UiPop()
        return false
    end
    if (#TABLEwindows > 0) then 
        if not GetBool('tgui.disableInput') then
            UiMakeInteractive()
        end
    end

    if (isFirstFrame) then
        ScreenWidth, ScreenHeight = UiWidth(), UiHeight()
        MaxWindowPos.w = ScreenWidth-30
        MaxWindowPos.h = ScreenHeight-30

        isFirstFrame = false
    end
    local mouse = { x = 0, y = 0 }
    mouse.x, mouse.y = UiGetMousePos()
    deltaMouse = { x = mouse.x - lastMouse.x, y = mouse.y - lastMouse.y }
    local mouseMoved = deltaMouse.x ~= 0 or deltaMouse.y ~= 0

    local last = #TABLEwindows -0
    if not TGUI_has_error then
    for i, v in pairs(TABLEwindows) do
        -- INIT
        -- if v.firstFrame == nil then
        --     DebugPrint('FirstFrame Missing')
        --     table.remove(TABLEwindows, v)
        --     return false
        -- end
        if v.firstFrame or v.firstFrame == nil then v.focused = false; v.prefocused = false; v.closeWindow = false; v.keepMoving = false; v.keepResizing = false; v.disableDrag = false;
            if v.dragging == nil then v.dragging = false end
            if v.opacity == nil then v.opacity = 0 end
            if v.hideTitleBar == nil then v.hideTitleBar = false end
            if v.minSize == nil then v.minSize = {w = 160,h = 160,} end
            if v.allowResize == nil then v.allowResize = true end
            if v.disableCloseButton == nil then v.disableCloseButton = false end
            v.firstFrame = false

            if v.startMiddle then
                UiPop()
                local sm_x,sm_y = UiCenter(),UiMiddle()
                local f_sm_x = sm_x - v.size.w/2; v.pos.x = f_sm_x
                local f_sm_y = sm_y - v.size.h/2; v.pos.y = f_sm_y
                v.startMiddle = false
            end
        end
        if not v.closeWindow then
            if v.opacity < 1 then
                v.opacity = v.opacity + dt/0.3
            end
        end
        -- UI
        UiPush()
            UiTranslate(v.pos.x,v.pos.y)    
            UiEnableInput()
            UiWindow(v.size.w ,v.size.h ,v.clip)
            UiColorFilter(1, 1, 1, v.opacity)
            -- UiPush()
            --     if v.disableDrag == true then
            --         UiColor(1, 0, 0, 1) UiRect(v.size.w, 32)
            --     end
            -- UiPop()
            UiPush()
                if v.focused or v.doNotHide then
                    UiPush()
                    if v.keepMoving == false then
                        UiTranslate(v.size.w, v.size.h)
                        UiAlign("bottom right")
                        if not UiIsMouseInRect(24, 24) and not v.keepResizing then
                            UiAlign("top left")
                            UiTranslate(-v.size.w, -v.size.h)
                            UiTranslate(0, 32)
                            if UiIsMouseInRect(v.size.w, v.size.h-32) and InputDown('lmb') then v.disableDrag = true v.disableRezie = true
                            elseif not UiIsMouseInRect(v.size.w, v.size.h-32) then if InputReleased('lmb') then v.disableDrag = false v.disableRezie = false end end
                            if v.disableDrag == true then if InputReleased('lmb') then v.disableDrag = false v.disableRezie = false end end
                        else
                            if UiIsMouseInRect(11, 11) and InputDown('lmb') then v.disableRezie = false
                            elseif not UiIsMouseInRect(11, 11) then if InputReleased('lmb') then v.disableRezie = false end end
                            if v.disableRezie == true then if InputReleased('lmb') then v.disableRezie = false end end
                        end
                    end
                    UiPop()
                end
            UiPop()
            UiPush()
                UiAlign("top left")
                if UiIsMouseInRect(v.size.w, 32) or v.keepMoving and v.disableDrag == false and InputDown('lmb') and last == i then
                    -- UiRect(v.size.w+0, 32)
                    UiPush()
                        UiTranslate(v.size.w/2,16)
                        UiAlign("middle center")
                        if UiIsMouseInRect(v.size.w+2000, 1600) and v.disableDrag == false and InputDown('lmb') and last == i then
                            v.keepMoving = true
                            v.pos = Vec2DAdd(v.pos, deltaMouse)
                            SetBool('TGUI.interactingWindow',true)
                        else
                            SetBool('TGUI.interactingWindow',false)
                            v.keepMoving = false
                        end
                    UiPop()
                end
                if InputReleased('lmb') and v.keepMoving then
                    SetBool('TGUI.interactingWindow',false)
                    v.keepMoving = false
                end
                UiPush()
                    UiAlign('top left')
                    UiColorFilter(1,1,1,globalWindowOpacity)
                    if last == i then
                        UiColor(c255(style.focusBackgroundColor.r), c255(style.focusBackgroundColor.g), c255(style.focusBackgroundColor.b),c200(style.focusBackgroundColor.a))
                        v.focused = true
                        if v.prefocused == false then
                            v.prefocused = true
                        end
                        if UiBlankButton(v.size.w, v.size.h) then end
                    else
                        UiColor(c255(style.unfocusedBackgroundColor.r), c255(style.unfocusedBackgroundColor.g), c255(style.unfocusedBackgroundColor.b),c200(style.unfocusedBackgroundColor.a))
                        v.focused = false
                        if v.prefocused == true then
                            v.prefocused = false
                        end

                        if UiBlankButton(v.size.w, v.size.h) then
                            local swapWindowData = TABLEwindows[i]
                            table.remove(TABLEwindows , i)
                            table.insert(TABLEwindows , swapWindowData)
                        end
                    end
                    UiImageBox(tgui_ui_assets.."/textures/window.png",v.size.w ,v.size.h,windowSlice.x,windowSlice.y)
                    if showSlicing then
                        UiPush()
                            UiColor(1,0,0,1)
                            UiPush()
                                UiTranslate(0,windowSlice.x)
                                UiRect(UiWidth(),1)
                            UiPop()
                            UiColor(0,1,0,1)
                            UiPush()
                                UiTranslate(windowSlice.y,0)
                                UiRect(1,UiHeight())
                            UiPop()
                        UiPop()
                    end
                UiPop()
                -- UiFont(tgui_ui_assets.."/Fonts/TAHOMABD.TTF", 12)
                UiTranslate(12,0)
                UiColor(c255(style.TitleBar.titleColor.r), c255(style.TitleBar.titleColor.g), c255(style.TitleBar.titleColor.b), c200(style.TitleBar.titleColor.a))
                uic_text(v.title, 32, 12, {
                    font = tgui_ui_assets.."/Fonts/TAHOMABD.TTF"
                })
            UiPop()
            if not v.disableCloseButton then
                UiPush()
                    local buttonSize = 16
                    UiColorFilter(1,1,1,globalWindowOpacity)
                    UiAlign("top right")
                    UiTranslate(UiWidth()-8,16/2)
                    -- -- UiRect(1,10)
                    UiPush()
                        UiTranslate(-4,4)
                        UiImageBox(tgui_ui_assets..'/textures/close.png',9,9,0,0)
                    UiPop()
                    -- UiColor(1,1,1,0.3)
                    -- UiRect(buttonSize,buttonSize)
                    if UiIsMouseInRect(buttonSize,buttonSize) and InputDown('lmb') then
                        -- Nothing
                    elseif UiIsMouseInRect(buttonSize,buttonSize) then v.disableDrag = true end
                    if v.disableDrag == true then if InputReleased('lmb') then v.disableDrag = false end end
                    if v.disableDrag == true then if not UiIsMouseInRect(buttonSize,buttonSize) and not InputDown('lmb') then v.disableDrag = false end end
                    if UiBlankButton(buttonSize,buttonSize) then v.closeWindow = true end
                UiPop()
            end
            UiPush()
                UiTranslate(0,32)
                UiWindow(v.size.w,v.size.h-32,v.clip)
                UiFont(tgui_ui_assets.."/Fonts/TAHOMA.TTF", 15)
                UiTranslate(v.padding,v.padding)
                UiWindow(v.size.w-v.padding/2*4,v.size.h-32+v.padding/2*-4,v.clip)
                UiColor(1,1,1,1)
                UiPush()
                    UiAlign("top left")
                    if v.focused or v.doNotHide then
                        if v.pos.x > MaxWindowPos.w then v.pos.x = MaxWindowPos.w end
                        if v.pos.y > MaxWindowPos.h then v.pos.y = MaxWindowPos.h end
                        UiColorFilter(1,1,1,1)
                        local success, err = pcall(function() 
                            if v.content == nil then
                                -- v.content = function()
                                --     UiWordWrap(UiWidth())
                                --     uic_text("nil value, Reopen this window and continue what you were doing", -1, 32)
                                -- end
                                SetString('TGUI.error',"1. You might have quicksaved while a window was opened\n2. Content in table does not exist")
                                SetBool('TGUI.error.allowTo.terminateWindow',true)
                                SetInt('TGUI.error.allowTo.terminateNumber',v)
                            end
                            if v.focused == false then
                                UiDisableInput()
                            else
                                UiButtonImageBox('MOD',0,0,0,0,0,0)
                            end
                            if v.keepResizing == true then
                                UiDisableInput()
                            end
                            v.content(v, dt)
                        end, v)

                        if not success then
                            TGUI_has_error = true
                            TGUI_error_message = err
                        end
                    end
                UiPop()
            UiPop()
            UiPush()
                if TGUI_debug_show_windowMinsize then
                    UiPush()
                        UiPush()
                            UiColor(1,0,0,1)
                            UiTranslate(v.minSize.w, 0)
                            UiRect(3,v.size.h)
                        UiPop()
                        UiPush()
                            UiColor(0,1,0,1)
                            UiTranslate(0,v.minSize.h)
                            UiRect(v.size.w,3)
                        UiPop()
                    UiPop()
                end
                if v.focused and v.allowResize then
                    local cursor_x, cursor_y = UiGetMousePos()
                    -- UiPush()
                    -- UiColor(1,1,1,0.3)
                    -- UiRect(cursor_x, cursor_y)
                    -- UiPop()            
                    UiTranslate(v.size.w,v.size.h)
                    UiAlign('bottom right')
                    UiPush()
                        UiTranslate(-3,-3)
                        UiImage(tgui_ui_assets..'/textures/resizeicon.png',image)
                    UiPop()
                    if not v.disableRezie then
                        if UiIsMouseInRect(20,20) or v.keepResizing and InputDown('lmb') and last == i then
                            UiPush()
                                UiTranslate(-10,-10)
                                UiAlign("middle center")
                                if UiIsMouseInRect(4000,4000) and InputDown('lmb') and last == i then
                                    SetBool('TGUI.interactingWindow',true)
                                    local Vec2DAdd = Vec2DAdd_WH(v.size, deltaMouse)
                                    -- v.size = 
                                    if Vec2DAdd.w > -1 and Vec2DAdd.h > -1 then
                                        if v.size.w > v.minSize.w then v.size.w = Vec2DAdd.w end
                                        if v.size.h > v.minSize.h then v.size.h = Vec2DAdd.h end
                                    end
                                    if Vec2DAdd.w-8 < cursor_x then v.size.w = Vec2DAdd.w end
                                    if Vec2DAdd.h-8 < cursor_y then v.size.h = Vec2DAdd.h end
                                    if v.size.w < v.minSize.w then v.size.w = v.minSize.w end
                                    if v.size.h < v.minSize.h then v.size.h = v.minSize.h end
                                    v.disableDrag = true
                                    v.keepResizing = true
                                else v.keepResizing = false end
                            UiPop()
                        else
                        if v.size.w < v.minSize.w then v.size.w = v.minSize.w end
                        if v.size.h < v.minSize.h then v.size.h = v.minSize.h end
                        end
                    end
                end
                if InputReleased('lmb') and v.keepResizing then
                    SetBool('TGUI.interactingWindow',false)
                    v.disableDrag = false
                    v.keepResizing = false
                end
            UiPop()
        UiPop()
        -- if v.focused then
        --     DebugPrint(v.title.." finds table ahead is "..type(TABLEwindows[i+1]))
        --     DebugPrint(v.title.." finds table behind is "..type(TABLEwindows[i-1]))
        -- end
                -- if type(TABLEwindows[i+1]) == "table" then
        -- end
        if v.closeWindow then if v.onClose == nil then
            if type(TABLEwindows[i-1]) == "table" then
                DebugPrint(TABLEwindows[i+1])
                TABLEwindows[i-1].focused = true;
                v.doNotHide = true;
                if v.focused then
                    local swapWindowData = TABLEwindows[i-1]
                    table.remove(TABLEwindows , i-1)
                    table.insert(TABLEwindows , swapWindowData)
                end
            end
            if v.opacity > 0 then
                v.opacity = v.opacity - dt/0.3
            else
                table.remove(TABLEwindows, i)
            end
        else 
            v.onClose(v, TABLEwindows , i)
        end end
        lastMouse = mouse
    end
    end 
    if TGUI_has_error then
        local lineWidth = 700
        -- TGUI_error_message
        UiPush()
            UiEnableInput() UiMakeInteractive() UiMute(1)
            UiPush()
            UiColor(0,0,0,1)
            UiRect(UiWidth(),UiHeight())
            UiPop()
            UiTranslate(UiCenter(),UiMiddle() -80)
            UiPush()
                if TGUI_icon_fade_loopcounter < 3 then
                    if dt then
                        if TGUI_icon_fade_direction == "up" then
                            TGUI_icon_fade = TGUI_icon_fade + dt/0.5
                            if TGUI_icon_fade >= 1 then
                                TGUI_icon_fade_loopcounter = TGUI_icon_fade_loopcounter + 1
                                TGUI_icon_fade_direction = "down"
                               end
                        elseif TGUI_icon_fade_direction == "down" then
                            TGUI_icon_fade = TGUI_icon_fade - dt/0.5
                            if TGUI_icon_fade <= 0 then
                            TGUI_icon_fade_direction = "up"
                            end
                        end
                    end
                end
                UiColor(1, 1, 1, TGUI_icon_fade)
                UiAlign("center bottom")
                UiImage(tgui_ui_assets.."/textures/icons/error.png")
            UiPop()
            UiTranslate(0, 6)
            UiTranslate(-(lineWidth/2), 0)
            UiPush()
                UiRect(lineWidth, 2)
                UiFont(tgui_ui_assets.."/Fonts/TAHOMABD.TTF", 26)
                UiPush()
                    UiTranslate(lineWidth/2, 8)
                    UiAlign("center top")
                    UiColor(1, 0.8, 0.05, 1)
                    local tx,ty=UiText("The TGUI system broke due to a leak or a bug in the code")
                UiPop()
                UiTranslate(0, ty+8)
                UiRect(lineWidth, 2)
                UiTranslate(0, 6)
                UiWordWrap(lineWidth-100)
                UiAlign("top left")
                UiFont(tgui_ui_assets.."/Fonts/TAHOMA.TTF", 23)
                UiPush()
                    UiTranslate(lineWidth/2, 0)
                    UiAlign("center top")
                    local tx,ty=UiText("It is recommended you report this to a developer as soon as possible and show them how you got this error. It is also best you screenshot this screen just in case you can't get this error again.")
                UiPop()
                UiTranslate(0, ty+8)
                UiRect(lineWidth, 2)
                UiTranslate(0, 6)
                UiPush()
                    UiTranslate(lineWidth/2, 0)
                    UiAlign("center top")
                    local tx,ty=UiText("Cause of crash:")
                UiPop()
                UiTranslate(0, ty+8)
                UiPush()
                    local tx,ty=UiGetTextSize(tostring( TGUI_error_message ))
                    -- UiAlign("left top")
                    UiTranslate(lineWidth/2, 0)
                    UiAlign("center top")
                    UiWindow(lineWidth-100, ty)
                    UiAlign("left top")
                    UiColor(49/255, 49/255, 49/255, 1)
                    UiRect(UiWidth(),UiHeight())
                    UiColor(1,1,1,1)
                    local tx,ty=UiText( tostring( TGUI_error_message ))
                UiPop()
            UiPop()
        UiPop()
    end
    SetBool('TGUI.interactingWindow',false)
end

function Vec2DAdd(a, b)
    return { x = a.x + b.x, y = a.y + b.y }
end
function Vec2DAdd_WH(a, b)
    return { w = a.w + b.x, h = a.h + b.y }
end

function slerpVec2D(a, b, t)
    return { x = slerp(a.x, b.x, t), y = slerp(a.y, b.y, t) }
end
