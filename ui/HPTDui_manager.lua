-- PLACEHOLDER PHASE

--[[
___  ___  ________  _________  ________                             ___  ___  ___          _____ ______   ________  ________   ________  ________  _______   ________     
|\  \|\  \|\   __  \|\___   ___\\   ___ \                           |\  \|\  \|\  \        |\   _ \  _   \|\   __  \|\   ___  \|\   __  \|\   ____\|\  ___ \ |\   __  \
\ \  \\\  \ \  \|\  \|___ \  \_\ \  \_|\ \        ____________      \ \  \\\  \ \  \       \ \  \\\__\ \  \ \  \|\  \ \  \\ \  \ \  \|\  \ \  \___|\ \   __/|\ \  \|\  \
 \ \   __  \ \   ____\   \ \  \ \ \  \ \\ \      |\____________\     \ \  \\\  \ \  \       \ \  \\|__| \  \ \   __  \ \  \\ \  \ \   __  \ \  \  __\ \  \_|/_\ \   _  _\
  \ \  \ \  \ \  \___|    \ \  \ \ \  \_\\ \     \|____________|      \ \  \\\  \ \  \       \ \  \    \ \  \ \  \ \  \ \  \\ \  \ \  \ \  \ \  \|\  \ \  \_|\ \ \  \\  \|
   \ \__\ \__\ \__\        \ \__\ \ \_______\                          \ \_______\ \__\       \ \__\    \ \__\ \__\ \__\ \__\\ \__\ \__\ \__\ \_______\ \_______\ \__\\ _\
    \|__|\|__|\|__|         \|__|  \|_______|                           \|_______|\|__|        \|__|     \|__|\|__|\|__|\|__| \|__|\|__|\|__|\|_______|\|_______|\|__|\|__|

Name: HPTD - UI manager
Aurthor: AlexVeeBee
]]

---





local TGUI_has_error = False;

function initDrawHPRD_UI( TABLEwindows )
    local last = #TABLEwindows -0
    for i, v in ipairs( TABLEwindows ) do
        local success, err = pcall(function(v) 
            if v.padding == nil then v.padding = 0 end
            if v.size == nil then v.size = {w = 1500, h = 750} end
            if v.actionsText == nil then v.actionsText = "" end
            if v.actions == nil then v.actions = {} end
            UiPush()
                UiFont(tgui_ui_assets.."/Fonts/TAHOMA.TTF", 15)
                UiColor(1,1,1,1)
                UiAlign('center middle')
                UiTranslate(UiCenter(),UiMiddle())
                UiWindow(v.size.w,v.size.h, true)
                UiAlign('top left')
                UiPush()
                    UiColor(0,0,0,0.6)
                    UiRect(v.size.w,v.size.h)
                UiPop()
                UiPush()
                    UiColor(1,1,1,1)
                    UiAlign('center middle')
                    UiTranslate(v.size.w/2,64/2)
                    UiPush()
                        UiTranslate(0,29);
                        UiAlign('Center middle');
                        UiColor(1,1,1,1)
                        UiRect(243,4)
                    UiPop()

                    UiFont(tgui_ui_assets.."/Fonts/TAHOMABD.TTF", 36)
                    UiText(v.title,move)
                UiPop()
                UiPush()
                    UiColorFilter(1,1,1,1)
                    UiAlign("center middle")
                    UiTranslate(UiWidth()-32/2,32/2)
                    UiPush()
                        UiColorFilter(1,0.2,0.2,0.2)
                        UiRect(32,32)
                    UiPop()
                    UiPush()
                        UiAlign("top right")
                        UiTranslate(9/2,-9/2)
                        UiImageBox(tgui_ui_assets..'/textures/close.png',9,9,0,0)
                    UiPop()
                    if UiIsMouseInRect(32,32) and InputDown('lmb') then
                        -- Nothing
                    elseif UiIsMouseInRect(32,32) then  v.disableDrag = true end
                    if v.disableDrag == true then if InputReleased('lmb') then v.disableDrag = false end end
                    if UiBlankButton(32,32) then v.closeWindow = true end
                UiPop()

                if v.title == nil then
                    UiTranslate(0,32+12)
                    UiWindow(v.size.w,v.size.h-32-12, true)
                else
                    UiTranslate(0,64+12)
                    UiWindow(v.size.w,v.size.h-64-12, true)
                end
                if v.content == nil then
                else
                    UiPush()
                        v.content(v);
                    UiPop()
                end
            UiPop()
            if v.closeWindow == true then
                table.remove(TABLEwindows, i)
            end
        end, v );
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
            UiText('[HPTD_UI.MANAGER]: Woah, an actual error on screen',18)
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
                    Menu()
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