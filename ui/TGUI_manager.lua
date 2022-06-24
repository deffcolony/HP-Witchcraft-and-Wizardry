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
local TGUI_has_error, TGUI_error_message = false, "";
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
function aboutTGUI(TABLEwindows)
    if TABLEwindows == nil then 
        DebugPrint('[TGUI.aboutTGUI]: Param missing table.')
        return
    end
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
                uic_button_func(0,"Close", 100,24,false,"", function (window)
                    window.closeWindow = true
                end, window)
            UiPop()
        end
    })
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

---TGUI MANAGER: UI INIT
-----------------------------
---Manager for createing a window and moving it
--
---Params to create a window
---@options focused - Focused window
---@options closeWindow - Close the window.
---@options startMiddle - Start in the middle of your screen.
---@options allowResize - Allow the window to be resized.
---@Default-value: true
---half important:
----
---@options tabFirstFrame - if you have a tab widget, then this must be added
---Important:
----
---@important firstFrame = true - adds options in the first frame
---@important padding - adds padding around the window
---@important title - Title of the window
---@important pos = `{x = (int), y = (int)}` - Position of the window
---@important size = `{w = (int), h = (int)}` - Size of the window
---@not_in_use opacity | use globalWindowOpacity
---@param TABLEwindows table Where all the windows are stored
function initDrawTGUI( TABLEwindows )
    -- if TABLEwindows == nil then 
    --     UiPush()
    --     UiTranslate(UiCenter(),50)
    --     UiAlign('center middle')
    --     UiColor(0,0,0,1)
    --     UiRect(UiWidth(),50)
    --     UiColor(1,1,1,1)
    --     UiFont("MOD/ui/TGUI_resources/Fonts/TAHOMABD.TTF", 24)
    --     UiText('[TGUI.Main]: invalid table',move)
    --     UiPop()
    --     -- DebugPrint('[TGUI.Main]: invalid table')
    -- return end
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
        if v.padding == nil then v.padding = 0 end
        -- INIT
        if v.firstFrame == nil then
            DebugPrint('FirstFrame Missing')
            table.remove(TABLEwindows, v)
            return false
        end
        if v.firstFrame then v.focused = false v.prefocused = false v.closeWindow = false v.keepMoving = false v.keepResizing = false v.disableDrag = false
            v.Dragging = false
            if v.minSize == nil then v.minSize = {w = 160,h = 160,} end
            if v.allowResize == nil then v.allowResize = true end
            v.firstFrame = false

            if v.startMiddle then
                UiPop()
                local sm_x,sm_y = UiCenter(),UiMiddle()
                local f_sm_x = sm_x - v.size.w/2; v.pos.x = f_sm_x
                local f_sm_y = sm_y - v.size.h/2; v.pos.y = f_sm_y
                v.startMiddle = false
            end
        end
        -- UI
        UiPush()
            UiTranslate(v.pos.x,v.pos.y)    
            UiEnableInput()
            UiWindow(v.size.w ,v.size.h ,v.clip)
            UiPush()
                UiAlign("top left")
                if UiIsMouseInRect(v.size.w, 32) or v.keepMoving and v.disableDrag == false and InputDown('lmb') and last == i then
                    -- UiRect(v.size.w+0, 32)
                    UiPush()
                        UiTranslate(v.size.w/2,16)
                        UiAlign("middle center")
                        if UiIsMouseInRect(v.size.w+2000, 1600) and v.disableDrag == false and InputDown('lmb') and last == i then
                            v.keepMoving = true
                            TABLEwindows[i].pos = Vec2DAdd(TABLEwindows[i].pos, deltaMouse)
                        else
                            v.keepMoving = false
                        end
                    UiPop()
                end
                if InputReleased('lmb') and v.keepMoving then
                    v.keepMoving = false
                end
                UiPush()
                    UiAlign('top left')
                    UiColorFilter(1,1,1,globalWindowOpacity)
                    if last == i then
                        UiColor(c255(160), c255(160), c255(160),c200(150))
                        v.focused = true
                        if v.prefocused == false then
                            v.prefocused = true
                        end
                        if UiBlankButton(v.size.w, v.size.h) then end
                    else
                        UiColor(c255(28), c255(28), c255(28),c200(64))
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
                UiFont(tgui_ui_assets.."/Fonts/TAHOMABD.TTF", 12)
                UiTranslate(UiCenter(),32/2)
                UiAlign('center middle')
                UiColor(1,1,1,1)
                UiText(v.title)
            UiPop()
            UiPush()
                UiColorFilter(1,1,1,globalWindowOpacity)
                UiAlign("top right")
                UiTranslate(UiWidth()-10,10)
                UiImageBox(tgui_ui_assets..'/textures/close.png',9,9,0,0)
                -- UiRect(11,11)
                if UiIsMouseInRect(11,11) and InputDown('lmb') then
                    -- Nothing
                elseif UiIsMouseInRect(11,11) then  v.disableDrag = true end
                if v.disableDrag == true then if InputReleased('lmb') then v.disableDrag = false end end
                if UiBlankButton(11,11) then v.closeWindow = true end
            UiPop()
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
                        if v.pos.x > MaxWindowPos.w then
                            v.pos.x = MaxWindowPos.w
                        end
                        if v.pos.y > MaxWindowPos.h then
                            v.pos.y = MaxWindowPos.h
                        end
                        UiColorFilter(1,1,1,1)
                        local success, err = pcall(function(v) 
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
                            v.content(v)
                        end, v)

                        if not success then
                            -- if TABLEwindows == nil then 
                            TGUI_has_error = true
                            TGUI_error_message = tostring(err)
                            -- if file_exists("./info.txt") then DebugPrint('exists') end
                            -- return end
                            -- DebugPrint("caught error: "..tostring(err))
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
                    if UiIsMouseInRect(20,20) or v.keepResizing and InputDown('lmb') and last == i then
                        UiPush()
                            UiTranslate(-10,-10)
                            UiAlign("middle center")
                            if UiIsMouseInRect(1200,1200) and InputDown('lmb') and last == i then
                                -- UiRect(25,25)
                                -- if cursor_x < -cursor_x+v.minSize.w then
                                --     v.size.w = v.minSize.w
                                -- end
                                -- if cursor_y < -cursor_y+v.minSize.h then
                                --     v.size.h = v.minSize.h
                                -- end

                                local Vec2DAdd = Vec2DAdd_WH(v.size, deltaMouse)
                                -- v.size = 
                                if Vec2DAdd.w > -1 and Vec2DAdd.h > -1 then
                                    if v.size.w > v.minSize.w then
                                        v.size.w = Vec2DAdd.w
                                    end
                                    if v.size.h > v.minSize.h then
                                        v.size.h = Vec2DAdd.h
                                    end
                                end
                                if Vec2DAdd.w-8 < cursor_x then
                                    v.size.w = Vec2DAdd.w
                                end
                                if Vec2DAdd.h-8 < cursor_y then
                                    v.size.h = Vec2DAdd.h
                                end
                                -- UiPush()
                                --     UiTranslate(-cursor_x+v.minSize.w,-cursor_y+v.minSize.h)
                                --     UiColor(1,0,0,1)
                                --     UiRect(15,15)
                                -- UiPop()

                                if v.size.w < v.minSize.w then
                                    v.size.w = v.minSize.w
                                end
                                if v.size.h < v.minSize.h then
                                    v.size.h = v.minSize.h
                                end
                                v.disableDrag = true
                                v.keepResizing = true
                            else
                                v.keepResizing = false
                            end
                        UiPop()
                    else
                       if v.size.w < v.minSize.w then v.size.w = v.minSize.w end
                       if v.size.h < v.minSize.h then v.size.h = v.minSize.h end
                    end
                    if InputReleased('lmb') and v.keepResizing then
                        v.disableDrag = false
                        v.keepResizing = false
                    end
                end
            UiPop()
        UiPop()
        if v.closeWindow then if v.onClose == nil then
            table.remove(TABLEwindows, i)
        else 
            v.onClose(v, TABLEwindows , i)
        end end
        lastMouse = mouse
    end
    end 
    if TGUI_has_error then
        -- TGUI_error_message
        UiPush()
            UiEnableInput() UiMakeInteractive() UiMute(1)
            UiTranslate(UiCenter(),0)
            UiAlign('center top')
            UiColor(0,0,0,1)
            UiRect(UiWidth(),UiHeight())
            UiColor(1,1,1,1)
            UiFont(tgui_ui_assets.."/Fonts/TAHOMABD.TTF", 24)
            UiTranslate(0,UiMiddle()-100)
            UiText('[TGUI.MANAGER]: Woah, an actual error on screen',18)
            UiText(TGUI_error_message)
            if HasKey('TGUI.error') then
                UiTranslate(0,48)
                UiFont(tgui_ui_assets.."/Fonts/TAHOMABD.TTF", 32)
                UiText("Probable Cause")
                UiFont(tgui_ui_assets.."/Fonts/TAHOMABD.TTF", 24)
                UiTranslate(0,32)
                UiText(GetString('TGUI.error'))
            end
            UiTranslate(0,100)
            UiPush()
                UiAlign('center middle')
                UiColor(0.3,0.3,0.3,1)
                UiRect(90,45)
                UiColor(1,1,1,1)
                UiPush()
                    UiTranslate(0,3)
                    UiText("QUIT")
                UiPop()
                if UiBlankButton(90,45) then
                    
                end
            UiPop()
        UiPop()
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
            UiText('[TGUI.MANAGER]: invalid argument',18)
        UiPop()
    return end
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
