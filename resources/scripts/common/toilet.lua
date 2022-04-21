FlushTimeInterval = 7
Volume = 0.6


function init()

    timer = { time = 0, duration = FlushTimeInterval }

    shapes = FindShapes('toilet')
    sound = LoadSound('MOD/resources/snd/flushtoilet.ogg')

end


function tick()

    -- Broken toilet does not play sound and are not interactable.
    for index, shape in ipairs(shapes) do
        if IsShapeBroken(shape) then
            RemoveTag(shape, 'interact')
        end
    end

    -- Manage toilet flushing.
    if timer.time <= 0 then

        if InputPressed('interact') then

            for index, shape in ipairs(shapes) do

                if GetPlayerInteractShape() == shape then

                    PlaySound(sound, GetShapeWorldTransform(shape).pos, Volume)
                    timer.time = timer.duration

                    break

                end

            end

        end

    else
        timer.time = timer.time - GetTimeStep()
    end

end
