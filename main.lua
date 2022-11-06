#include "./ui/TGUI_manager.lua"
#include "./ui/TGUI_ui_library.lua"
#include "./ui/regeditWindow.lua"
#include "./debugconfig.lua"

-- #include "./ui/TGUI_main.lua"
function init()
    globalWindowOpacity = 1
    tgui_ui_assets = "MOD/ui/TGUI_resources"

    -- devMenuEnabled = GetBool("savegame.mod.HPTD.settings.enableDeveloperTools");
    devMenuEnabled = true;

    ALL_WINDOWS_OPEN = {}
end

disabledMenuTimer = 1

function draw(dt)
    -- COMPASS
    if (GetBool('hpTD.compass')) then
            UiPush()
                -- player        
                local t = GetPlayerCameraTransform().rot
                local _, t_el_y, _ = GetQuatEuler( t )
    
                player_r_y = t_el_y*2
                UiTranslate(UiCenter(),15)
                UiAlign('center top')
                UiPush()
                    UiTranslate(0,20)
                    UiAlign('bottom center')
                    UiPush()
                        UiTranslate(0,20)
                        UiImage(compass_ui_assets..'/compass/compass_shading.png')
                    UiPop()
                    UiPush()
                        UiTranslate(0,33)
                        UiImage(compass_ui_assets..'/compass/compass_line.png')
                    UiPop()
                UiPop()
                UiPush()
                    function mathZoneArea(x,z)
                        if x< 0 then return x+100  end
                        if x> 0 then return -x+100 end
                    end
    
                    -- mathZoneArea(t_el_y,200)
                    UiTranslate( player_r_y ,0)
    
                    UiPush()
                        UiColor(0,1,1,mathZoneArea(t_el_y,200))
                        UiTranslate( 0  ,0)
                        UiRect(5,30)
                    UiPop()
                    -- 180
                    UiPush()
                        UiColor(1,0,1,mathZoneArea(t_el_y+180,200))
                        UiTranslate( 180*2  ,0)
                        UiRect(5,30)
                    UiPop()
                    UiPush()
                        UiColor(1,0,1,mathZoneArea(t_el_y-180,200))
                        UiTranslate( -180*2  ,0)
                        UiRect(5,30)
                    UiPop()
                    -- 90
                    UiPush()
                        UiColor(1,0,0,mathZoneArea(t_el_y+90,200))
                        UiTranslate( 90*2  ,0)
                        UiRect(5,30)
                    UiPop()
                    UiPush()
                        UiColor(1,0,0,mathZoneArea(t_el_y-90,200))
                        UiTranslate( -90*2  ,0)
                        UiRect(5,30)
                    UiPop()
                    -- 90 arround
                    UiPush()
                        UiColor(1,0,0,mathZoneArea(t_el_y+260,200))
                        UiTranslate( 360+180  ,0)
                        UiRect(5,30)
                    UiPop()
                    UiPush()
                        UiColor(1,0,0,mathZoneArea(t_el_y-260,200))
                        UiTranslate( -360-180  ,0)
                        UiRect(5,30)
                    UiPop()
                UiPop()
            UiPop()
    end

    -- End of registry explorer code
    if NewWindowPopup and devMenuEnabled == true then
        UiPush()
        UiMakeInteractive()
        UiAlign('top left')
        UiTranslate(UiCenter()-160/2,UiMiddle()-150)
        UiCreateWindow(160,300,false,"HPTD New Window",8,function()
            UiPush()
                UiAlign('bottom left ')
                UiTranslate(0,UiHeight())
                if uic_button(0,"Close",UiWidth(),24) then
                    NewWindowPopup = false
                end
            UiPop()
            UiPush()
                if uic_button(0,"About",UiWidth(),24) then
                    NewWindowPopup = false
                    aboutTGUI(ALL_WINDOWS_OPEN)
                end
                UiTranslate(0,28);
                if uic_button(0,"Debuging Window",UiWidth(),24) then
                    NewWindowPopup = false
                    table.insert(ALL_WINDOWS_OPEN ,{
                            tabFirstFrame = true,
                            firstFrame = true,
                            title = "Debuging Window",
                            padding = 0,
                            pos = {x = 180, y = 200},
                            size = {w = 628, h = 458},
                            allowResize = false,
                            startMiddle = true,
                            clip = false, content = function(window)
                                    UiTranslate(12,0)
                                    uic_tab_container(window, UiWidth()-24,UiHeight()-32,false,true,{
                                        ["open_default"] = 1,
                                        {
                                            ["title"] = "General",
                                            ["Content"] = function ()
                                                UiTranslate(10,10)
                                                uic_checkbox("Disable auto loading", "savegame.mod.debug.disable-auto-loading", 100)
                                                UiTranslate(0,24)
                                                for k,v in ipairs(DEVELOPER_json.dropdown) do
                                                    UiPush()
                                                        uic_text(v.name, 16,13)
                                                        UiTranslate(0,18)
                                                        uic_dropdown(200, "savegame.mod.debug."..v.key , v.items, v.default )
                                                        UiTranslate(210, 0)
                                                        -- buttontext
                                                        if v.buttontext then
                                                            uic_button_func({}, dt, v.buttontext, 100, 24, false, "", function()
                                                                v.buttonfunc()
                                                            end)
                                                        end
                                                    UiPop()
                                                    UiTranslate(0,48)
                                                end
                                            end
                                        },
                                        {
                                            ["title"] = "Debug keys",
                                            ["Content"] = function ()
                                                UiTranslate(10,10)
                                                uic_checkbox("Show radio playing", "savegame.mod.debug.show.nowplaying", 100)
                                            end
                                        }
                                    }, false, {}, dt)
                                    UiPush()
                                        UiTranslate(UiWidth()-32,3)
                                        UiAlign('top right')
                                        if uic_button(100,"Close",64,24) then
                                            window.closeWindow = true
                                        end
                                        UiTranslate(-72,0)
                                        uic_button_func({},dt,"Debuging menu",128,24,false,"",function(activeWindows)
                                            -- aboutTGUI(activeWindows)
                                        end , ALL_WINDOWS_OPEN)
                                    UiPop()
                            end ,
                    })
                end
                UiTranslate(0,28);
                if uic_button(0,"Registry Explorer",UiWidth(),24) then
                    NewWindowPopup = false
                    table.insert(ALL_WINDOWS_OPEN ,registerRegedit())
                end
                UiTranslate(0,28);
                -- uic_button_func(0,"function button",UiWidth(),24, false, "", function(contents)
                --     DebugPrint(contents.win);
                --     DebugPrint(contents.pop);
                -- end, {win = activeWindows, pop = NewWindowPopup} )
            UiPop()
                return true
        end)
        UiPop()
    end
    if NewWindowPopup and devMenuEnabled == false then
        UiPush()
            UiAlign('top left')
            UiTranslate(UiCenter()-160/2,UiMiddle()-150)
            UiCreateWindow(160,80,false,"HPTD New Window",8,function()
                uic_text("Menu Disabled",20, 16);
            end)
        UiPop()
        if disabledMenuTimer == 1 then
            SetValue('disabledMenuTimer',0,"linear",3)
        end
        if disabledMenuTimer == 0 then
            NewWindowPopup = false
            disabledMenuTimer = 1
        end
    end
    UiEnableInput()
    if InputPressed('f1') then
        if GetBool('tgui.disableInput') then
            SetBool('tgui.disableInput',false)
        else
            NewWindowPopup = true
        end
    end
    if (#ALL_WINDOWS_OPEN > 0) then 
        UiPush()  
            UiTranslate(30,100)
            UiCreateWindow(120,100,false,"Window settings",8,function()
                if uic_button(0,"New window",UiWidth(),24) then
                    NewWindowPopup=true
                end
                UiTranslate(0,28)
                uic_checkbox("disable input", "tgui.disableInput", 100)
            end)
        UiPop()
    end

    initDrawTGUI(ALL_WINDOWS_OPEN, dt)
    uic_drawContextMenu()
end