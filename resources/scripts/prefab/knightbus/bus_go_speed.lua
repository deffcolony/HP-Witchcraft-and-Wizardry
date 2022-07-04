function init()
    body = FindBody("bus")

    boost = 0.0
    boostCooldown = 2.0

    inVehicle = false
end

function tick(dt)
    vehicle = FindVehicle("knightbus")

    if GetPlayerVehicle() == vehicle then
        inVehicle = true
        local trans = GetBodyTransform(body)
        local fwd = TransformToParentVec(trans, Vec(0, 0, 1))

        if InputDown("shift") and boost <= 0.0 then
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

function draw()
    if inVehicle then
        w = UiWidth()
		h = UiHeight()
        unit = w / 144
		UiColor(0, 0, 0, 1)
		UiTranslate(UiCenter(), UiMiddle()+100)
        UiAlign('center middle')
        -- UiTranslate(-7 * unit, 0)
		UiFont("regular.ttf", 40)
		UiText("Press SHIFT to tell Ern to 'hit it'")
    end
end