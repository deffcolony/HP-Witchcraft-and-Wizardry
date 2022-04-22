local function VecDist(a, b) return VecLength(VecSub(a, b)) end



Volume = 1
VolumeDist = 1

Sinks = {}


function init()

    shapes = FindShapes('bathroom_sink')
    lights = FindLights('faucet')

    InitSinks()

    Sounds = {
        sinkOn = LoadSound('MOD/resources/snd/sink/sinkOn.ogg'),
        sinkOff = LoadSound('MOD/resources/snd/sink/sinkOff.ogg'),
    }

    Loops = {
        sinkRun = LoadLoop('MOD/resources/snd/sink/sinkRun.ogg')
    }

end

function InitSinks()
    for key, shape in pairs(shapes) do

        local sink = {}

        sink.shape = shape
        sink.on = false

        -- Light entity is used as a faucet transform.
        for index, light in ipairs(lights) do
            if HasTag(light, 'faucet') and GetLightShape(light) == shape then
                sink.faucet = light
            end
        end

        table.insert(Sinks, sink)

    end
end


function tick()

    for index, sink in ipairs(Sinks) do

        if not IsShapeBroken(shape) and sink.on then

            RunSink(sink)

        elseif sink.on then -- Broken sinks do not play sound and are not interactable.

            sink.on = false
            PlaySound(Loop.sinkOff)
            RemoveTag(sink.shape, 'interact')

        end

    end

    -- Manage sink toggling.
    if InputPressed('interact') then

        for index, sink in ipairs(Sinks) do

            if GetPlayerInteractShape() == sink.shape then

                sink.on = not sink.on -- Toggle sink on or off.

                local pos = GetShapeWorldTransform(sink.shape).pos
                if sink.on then
                    PlaySound(Sounds.sinkOn, pos, Volume)
                else
                    PlaySound(Sounds.sinkOff, pos, Volume)
                end

            end

        end

    end

end

function RunSink(sink)

    local pos = GetShapeWorldTransform(sink.shape).pos
    local vol = Volume / VecDist(GetPlayerTransform().pos, pos) ^ 1.5 -- Fade volume based on distance.
    PlayLoop(Loops.sinkRun, pos, vol)

    local faucetTr = GetLightTransform(sink.faucet)
    SpawnSinkWaterParticle(faucetTr)
end

function SpawnSinkWaterParticle(tr)

    ParticleReset()

	ParticleType("smoke")
	ParticleTile(3)

    ParticleAlpha(1)
    ParticleColor(0.7, 0.75, 1)

	-- ParticleFlags(256)
    ParticleGravity(-1)
	ParticleRadius(0.02, 0.07)
    ParticleCollide(1)
    -- ParticleSticky(1)

    SpawnParticle(tr.pos, Quat(), 1)


end
