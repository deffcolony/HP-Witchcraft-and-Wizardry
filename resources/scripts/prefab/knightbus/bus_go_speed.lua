function init()
    body = FindBody("bus")

    boost = 0.0
    boostCooldown = 2.0

    inVehicle = false

    FadeOutTimer = 1
    textFade = 1
end

function tick(dt)
    vehicle = FindVehicle("knightbus")

    if GetPlayerVehicle() == vehicle then
        inVehicle = true
        local trans = GetBodyTransform(body)
        local fwd = TransformToParentVec(trans, Vec(0, 0, 1))

        -- if InputDown("shift") and boost <= 0.0 then
        --     SetBodyVelocity(body, VecScale(fwd, 30))
        --     boost = boostCooldown
        -- end
        if InputDown("shift") then
            SetBodyVelocity(body, VecScale(fwd, 30))
            boost = boostCooldown
        end

        if boost > 0.0 then
            boost = boost - dt
        end
    else
        inVehicle = false
    end
end

function draw(dt)
    if inVehicle then
        w = UiWidth()
		h = UiHeight()
        unit = w / 144
		UiColor(1, 1, 1, textFade)
		UiTranslate(UiCenter(), UiMiddle()+100)
        UiAlign('center middle')
        -- UiTranslate(-7 * unit, 0)
		UiFont("regular.ttf", 40)
		UiText("Press SHIFT to tell Ern to 'hit it'")
        if InputPressed('W') then
            FadeOutTimer = 0
        end
        if FadeOutTimer == 0 then
            textFade = textFade - dt/2
            if textFade < 0 then
                textFade = 0
            end
        end
    end
end