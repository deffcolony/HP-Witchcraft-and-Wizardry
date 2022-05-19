#include "./TGUI_ui_library.lua"
#include "./TGUI_manager.lua"

--[[

    How to get TGUI working

    please include TGUI_manager.lua and TGUI_ui_library.lua with #include "./"
    how to create your own window
    1. type talbe.insert() to insert
    2. use any name to have your windows created stored like: myWindowsTable = {}
    3. type your table name into the first parameter of talbe.insert()
    here is a liminal window settings table for the second parameter of talbe.insert(myWindowsTable, {})
        `{
            firstFrame = true,
            title = "Hello title",
            padding = 0,
            pos = {x = 180, y = 200},
            size = {w = 628, h = 458},
            clip = false, content = function(window)
            end ,
        },
    4. you are now done creating your window

    --- OPTIONS ---
    -- closeWindow = false, close window
    -- startMiddle = false
    -- allowResize = true, allow the window to resize

    final code:

    table.insert(myWindowsTable ,{
        firstFrame = true,
        title = "Hello title",
        padding = 0,
        pos = {x = 180, y = 200},
        size = {w = 628, h = 458},
        clip = false, content = function(window)
        end ,
    })
]]

function init()
    
    compass_ui_assets = "MOD/ui/TGUI_resources"
    tgui_ui_assets = "MOD/ui/TGUI_resources"
    globalWindowOpacity = 1
    camera = FindLocation('camera_test',true)
    activeWindows = 
    { 
        -- {
        --     firstFrame = true,
        --     title = "Hello title",
        --     padding = 12,
        --     opacity = 12,
        --     pos = {x = 180, y = 200},
        --     size = {w = 628, h = 458},
        --     clip = false, content = function(window)
        --         -- UiText('Hello world')
        --         if uic_button(1,"Hello World from the button",UiWidth(),32, false, "Tool tip hello world") then
        --             window.closeWindow = true
        --         end
        --         UiTranslate(0,36)
        --         uic_slider("test.slider", 0, 250)
        --     end ,
        -- },
        -- {
        --     firstFrame = true,
        --     title = "Hello title",
        --     padding = 2,
        --     opacity = 1,
        --     pos = {x = 800, y = 200},
        --     size = {w = 128, h = 72},
        --     clip = false,
        --     content = function(window)
        --         if uic_button(2,"Close window",UiWidth(),32, false, "Tool tip hello world") then
        --             window.closeWindow = true
        --         end
        --     end ,
        -- }
    }

end

uic_debug_checkHit = false
isFirstFrame = true
NewWindowPopup = false

function GlobalWindowAddTest()
    table.insert(activeWindows ,{
        firstFrame = true,
        title = "Hello title",
        padding = 2,
        opacity = 1,
        pos = {x = 800, y = 200},
        size = {w = 128, h = 72},
        clip = false,
        allowResize = false,
        content = function(window)
            if uic_button(2,"Close window",UiWidth(),32, false, "Tool tip hello world") then
                window.closeWindow = true
            end
        end ,
    })
end

function draw()
    -- UiPush()
    --     UiTranslate(10,UiMiddle())
    --     UiImageBox('./ui/TGUI_resources/bars/bar_background.png',500,22,5,0)
    --     UiTranslate(4,3)
    --     UiImageBox('./ui/TGUI_resources/bars/health_bar.png',250,13,1,1)
    -- UiPop()
    initDrawTGUI(activeWindows)

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

    if NewWindowPopup then
        UiPush()
        UiMakeInteractive()
        UiAlign('top left')
        UiTranslate(UiCenter()-160/2,UiMiddle()-150)
        UiCreateWindow(160,300,false,"New Window",8,function()
            UiPush()
                UiAlign('bottom left ')
                UiTranslate(0,UiHeight())
                if uic_button(0,"Close",UiWidth(),24) then
                    NewWindowPopup = false
                end
            UiPop()
            UiPush()
                if uic_button(0,"Tiny window",UiWidth(),24) then
                        NewWindowPopup = false
                        table.insert(activeWindows ,{
                            firstFrame = true,
                            title = "Hello title",
                            padding = 2,
                            opacity = 1,
                            pos = {x = 800, y = 200},
                            size = {w = 128, h = 72},
                            clip = false,
                            allowResize = false,
                            content = function(window)
                                if uic_button(2,"Close window",UiWidth(),32, false, "Tool tip hello world") then
                                    window.closeWindow = true
                                end
                            end ,
                        })
            
                end
                UiTranslate(0,28);
                if uic_button(0,"Big window",UiWidth(),24) then
                    NewWindowPopup = false
                    table.insert(activeWindows ,{
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
                                uic_tab_container(window, UiWidth()-24,UiHeight()-35,false,true,{
                                    ["open_default"] = 1,
                                    {
                                        ["title"] = "UI Settings",
                                        ["Content"] = function ()
                                            UiTranslate(10,10)
                                            uic_checkbox("enable compass", "hpTD.compass", 100)
                                            -- UiText('I am tab 2, THIS WORKS, YAY')
                                            -- fds.lol()
                                        end
                                    },
                                    {
                                        ["title"] = "Corner Test",
                                        ["Content"] = function ()
                                            UiPush()
                                                UiRect(30,30)
                                                UiAlign('bottom left')
                                                UiTranslate(0, UiHeight())
                                                UiRect(30,30)
                                            UiPop()
                                            UiPush()
                                                UiAlign('top right')
                                                UiTranslate(UiWidth(), 0)
                                                UiRect(30,30)
                                                UiAlign('bottom right')
                                                UiTranslate(0, UiHeight())
                                                UiRect(30,30)
                                            UiPop()
                                            UiPush()
                                                UiAlign('center middle')
                                                UiTranslate(UiCenter(), UiMiddle())
                                                UiRect(30,30)
                                            UiPop()
            
                                        end
                                    },
                                    {
                                        ["title"] = "tab 2",
                                        ["Content"] = function ()
                                            UiText('I am tab 3')
                                        end
                                    },
                                })
                                UiPush()
                                    UiTranslate(UiWidth()-32,3)
                                    UiAlign('top right')
                                    if uic_button(100,"Close",128,28) then
                                        window.closeWindow = true
                                    end
                                UiPop()
                                UiPush()
                                    UiTranslate(4,3)
                                    UiAlign('top left')
                                    uic_button_func(100,"About TGUI",128,28,false,"",function(activeWindows)
                                        aboutTGUI(activeWindows)
                                    end , activeWindows)
                                UiPop()
                        end ,
                    })
                end
                UiTranslate(0,28);
                if uic_button(0,"Double tab container",UiWidth(),24) then
                    NewWindowPopup = false
                    table.insert(activeWindows ,{
                        testFirstFrame = true,
                        tab1 = {tabFirstFrame = true, },
                        tab2 = {tabFirstFrame = true, },
                        scrollArea = {scrollfirstFrame = true,},
                        win_in_win_meta = {win_in_win_firstFrame = true,},
                        win_in_win = {},
                        scrollHeight = 1500,
                        scrollConHeight = 500,
                        firstFrame = true,
                        title = "Test Window",
                        padding = 0,
                        pos = {x = 180, y = 200},
                        size = {w = 1026, h = 628},
                        startMiddle = true,
                        clip = false, content = function(window)
                            UiTranslate(12,0)
                            UiPush()
                            uic_tab_container(window.tab1,UiWidth()-24-300, UiHeight()-12, false, true, {
                                ["open_default"] = 1,
                                {
                                    title = "UI component: Container",
                                    ["Content"] = function()
                                        UiTranslate(10,10)
                                        uic_container(300, UiHeight()-20, false, true, true, function(window) 
                                            UiPush()
                                                UiTranslate(0,UiHeight() - 26)
                                                UiPush()
                                                    UiTranslate(24,-24)
                                                    uic_checkbox("Exit window? ","iam.key", 100,false)
                                                UiPop()
                                        
                                                uic_divider(UiWidth(),false)
                                                UiTranslate(UiWidth(),6)
                                                UiAlign("right top")
                                                if uic_button(0,"Yes",150,20,not GetBool('iam.key')) then 
                                                    window.closeWindow = true
                                                end
                                            UiPop()
                                        end, window)
                                    end
                                },
                                {
                                    title = "tab 2",
                                    ["Content"] = function(MainWindow)

                                    end
                                },
                                {
                                    title = "tab 3",
                                    ["Content"] = function()

                                    end
                                },
                            }, window)
                            UiPop()
                            UiPush()
                            UiTranslate(UiWidth()-290,0)
                            uic_tab_container(window.tab2,260, UiHeight()-12, false, true, {
                                ["open_default"] = 1,
                                {
                                    ["title"] = "Scroll container test",
                                    ["Content"] = function()
                                        UiTranslate(12,12)
                                        uic_scroll_Container(window.scrollArea,UiWidth()-24,window.scrollConHeight, true, window.scrollHeight ,function(extraContent)
                                            UiTranslate(12,0)
                                            UiText('i am at the top')
                                            UiPush()
                                                UiTranslate(12,UiHeight()-200)
                                                UiPush()
                                                    UiTranslate(0,25)
                                                    UiText("Sroll height: "..extraContent.scrollHeight)
                                                    UiTranslate(0,32)
                                                    if (uic_button(0,"Add", 75, 24)) then
                                                        extraContent.scrollHeight = extraContent.scrollHeight + 100
                                                    end
                                                    UiTranslate(80,0)
                                                    if (uic_button(0,"Remove", 75, 24)) then
                                                        extraContent.scrollHeight = extraContent.scrollHeight - 100
                                                    end
                                                UiPop()
                                                UiPush()
                                                    UiTranslate(0,100)
                                                    UiText("Window height: "..extraContent.scrollConHeight)
                                                    UiTranslate(0,32)
                                                    if (uic_button(0,"Add", 75, 24)) then
                                                        extraContent.scrollConHeight = extraContent.scrollConHeight + 25
                                                    end
                                                    UiTranslate(80,0)
                                                    if (uic_button(0,"Remove", 75, 24)) then
                                                        extraContent.scrollConHeight = extraContent.scrollConHeight - 25
                                                    end
                                                UiPop()
                                            UiPop()

                                            UiTranslate(0,UiHeight()-24)
                                            UiText('i am at the bottom')
                                            UiTranslate(0,-60)
                                            if uic_button(0,"Close window", 100, 24) then
                                                extraContent.closeWindow = true
                                            end
                                        end, window) 
                                    end
                                },
                                {
                                    ["title"] = "short",
                                    ["Content"] = function()

                                    end
                                },
                                {
                                    ["title"] = "Tab 3",
                                    ["Content"] = function()

                                    end
                                },
                                {
                                    ["title"] = "Tab 4",
                                    ["Content"] = function()

                                    end
                                }
                            }, false)
                            UiPop()
                        end
                    })
                end
                UiTranslate(0,28);
                uic_button_func(0,"function button",UiWidth(),24, false, "", function(contents)
                    DebugPrint(contents.win);
                    DebugPrint(contents.pop);
                end, {win = activeWindows, pop = NewWindowPopup} )
            UiPop()
                return true
        end)
        UiPop()
    end
    if InputDown('ctrl') and InputPressed('c') then
        if GetBool('tgui.disableInput') then
            SetBool('tgui.disableInput',false)
        else
            NewWindowPopup = true
        end
    end
    if (#activeWindows > 0) then 
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
    
    uic_tooltip()





    --     if (isFirstFrame) then
--         isFirstFrame = false

--     end
--     local mouse = { x = 0, y = 0 }
--     mouse.x, mouse.y = UiGetMousePos()
--     DebugWatch('mouse x',mouse.x)
--     DebugWatch('mouse y',mouse.y)

--     -- DebugWatch('test.values',GetString("test.values"))
--     UiDisableInput()
--     UiMakeInteractive()
--     SetCameraTransform(GetLocationTransform(camera),80,0)
--     -- UiImage('MOD/ui/Half-Life_2_Screenshot_2022.02.06_-_19.28.56.42.png',image)
--     -- UiTranslate(UiWidth()- 779,200)

    
--     if uic_button("lol", 100, 32 ) then 
--         UiCreateWindow( 100, 300, false, "lol", 12, function() end)
--     end
    
--     DrawAllWindows()
--     -- UiCreateWindow(500,600,false,"Window",8,function()
--     --     -- UiRect(UiWidth(),50)
--     --     uic_button("No if statement",150,20)
--     --     -- try.uic_test()
--     --     UiTranslate(0,30)
--     --     if uic_button("if statement",150,30) then
--     --         DebugPrint('return from the function')
--     --     end
--     --     UiTranslate(0,40)
--     --     uic_container(300,100,true,true,function() 
--     --         -- UiRect(UiWidth(),UiHeight())
--     --         UiText('Lol, Fart')
--     --         -- uic_button("I am fart in a best way",100,UiWidth())
--     --         UiPush()
--     --             UiTranslate(0,UiHeight() - 26)
--     --             UiPush()
--     --                 UiTranslate(24,-24)
--     --                 uic_checkbox("WRDFDafdsafdsaf ","iam.key", 100,false)
--     --             UiPop()
    
--     --             uic_divider(UiWidth(),false)
--     --             UiTranslate(UiWidth(),6)
--     --             UiAlign("right top")
--     --             if uic_button("No if statement",150,20,not GetBool('iam.key')) then  end
--     --         UiPop()
--     --     end)
--     --     UiTranslate(0,8)
--     --     uic_divider(UiWidth(),false)
--     --     UiTranslate(0,8)
--     --     UiText("Dock widget container")
--     --     UiTranslate(0,24)
--     --     uic_docking_container(UiWidth(),200,false,true,{
--     --         ["widget_id"] = 1,
--     --         ["open_default"] = 1,
--     --         [1] = {
--     --             ["title"] = "lol",
--     --             ["Content"] = function ()
--     --                 UiText('I am tab 1')
--     --                 UiPush()
--     --                     UiRect(30,30)
--     --                     UiAlign('bottom left')
--     --                     UiTranslate(0, UiHeight())
--     --                     UiRect(30,30)
--     --                 UiPop()
                    
--     --                 UiPush()
--     --                     UiAlign('top right')
--     --                     UiTranslate(UiWidth(), 0)
--     --                     UiRect(30,30)
--     --                     UiAlign('bottom right')
--     --                     UiTranslate(0, UiHeight())
--     --                     UiRect(30,30)
--     --                 UiPop()

--     --                 UiPush()
--     --                     UiAlign('center middle')
--     --                     UiTranslate(UiCenter(), UiMiddle())
--     --                     UiRect(30,30)
--     --                 UiPop()

--     --             end
--     --         },
--     --         [2] = {
--     --             ["title"] = "tab 2",
--     --             ["Content"] = function ()
--     --                 UiText('I am tab 2, ffs')
--     --             end
--     --         }
--     --     })
--     --     UiTranslate(0,8)
--     --     uic_divider(UiWidth(),false)
--     --     UiTranslate(0,8)
--     --     uic_dropdown(1,120 ,"savegame.mod.test.values",{
--     --         "value 1", "value 2", "value 3", "value 4", "value 5"
--     --     }, {
--     --         "val1", "val2", "val3", "val4", "val5"
--     --     }, false, "btuhhhhhhhhhhhhhhhhhhhhhh,\nnothing is changed right now")
--     --     -- UiTranslate(140,0)
--     --     UiTranslate(0,27)
--     --     uic_dropdown(2,200 ,"test.values2",{
--     --         "I AM TOOOOOOO BIG", "small"
--     --     }, {
--     --         "big", "small"
--     --     }, false, "i am tooltip dammit")
--     -- end)
--     lastMouse = mouse
end