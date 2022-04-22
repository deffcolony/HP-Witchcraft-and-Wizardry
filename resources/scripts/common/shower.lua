local function VecDist(a, b) return VecLength(VecSub(a, b)) end
local function QuatToDir(quat) return VecNormalize(TransformToParentPoint(Transform(Vec, quat), Vec(0,0,-1))) end -- Quat to normalized dir.

Volume = 1
VolumeDist = 1

Showers = {}


function init()

    shapes = FindShapes('bathroom_shower')
    lights = FindLights('faucet')
    trigger_steam = FindTrigger('shower_steam')

    InitShowers()

    Sounds = {
        showerOn = LoadSound('MOD/resources/snd/shower/showerOn.ogg'),
        showerOff = LoadSound('MOD/resources/snd/shower/showerOff.ogg'),
    }

    Loops = {
        showerRun = LoadLoop('MOD/resources/snd/shower/showerRun.ogg')
    }

end

function InitShowers()
    for key, shape in pairs(shapes) do

        local shower = {}

        shower.shape = shape
        shower.on = false

        -- Light entity is used as a faucet transform.
        for index, light in ipairs(lights) do
            if HasTag(light, 'faucet') then
                shower.faucet = light
            end
        end

        table.insert(Showers, shower)

    end
end


function tick()

    for index, shower in ipairs(Showers) do

        if not IsShapeBroken(shower.shape) and shower.on then

            RunShower(shower)

        elseif HasTag(shower.shape, 'interact') and IsShapeBroken(shower.shape) then -- Broken showers do not play sound and are not interactable.

            shower.on = false
            PlaySound(Sounds.showerOff)
            RemoveTag(shower.shape, 'interact')

        end

    end

    -- Manage shower toggling.
    if InputPressed('interact') then

        for index, shower in ipairs(Showers) do

            if GetPlayerInteractShape() == shower.shape then

                shower.on = not shower.on -- Toggle shower on or off.

                local pos = GetShapeWorldTransform(shower.shape).pos
                if shower.on then
                    PlaySound(Sounds.showerOn, pos, Volume)
                else
                    PlaySound(Sounds.showerOff, pos, Volume)
                end

            end

        end

    end

end

function RunShower(shower)

    local pos = GetShapeWorldTransform(shower.shape).pos
    local vol = Volume / VecDist(GetPlayerTransform().pos, pos) ^ 2 -- Fade volume based on distance.
    PlayLoop(Loops.showerRun, pos, vol)


    local faucetTr = GetLightTransform(shower.faucet)
    SpawnShowerWaterParticle(faucetTr)

    local min, max = GetTriggerBounds(trigger_steam) -- Trigger world min and max.
    local steamMin = VecCopy(min) -- Trigger world start corner.
    local steamBounds = VecSub(max, min) -- Actual dimensions of trigger.

    for i = 1, 5 do
        local randomSteamPos = Vec(steamBounds[1] * math.random(), steamBounds[2] * math.random(), steamBounds[3] * math.random())
        local triggerRandomPos = VecAdd(steamMin, randomSteamPos)
        SpawnShowerSteamParticle(Transform(triggerRandomPos))
    end

end

function SpawnShowerWaterParticle(tr)

    ParticleReset()

	ParticleType("smoke")
	ParticleTile(3)

    ParticleAlpha(1)
    ParticleColor(0.7, 0.75, 1)

    ParticleGravity(-1)
	ParticleRadius(0.05, 0.12)
    ParticleCollide(1)

    SpawnParticle(tr.pos, QuatToDir(tr.rot), 3.5)

end

function SpawnShowerSteamParticle(tr)

    ParticleReset()

	ParticleType("smoke")
	ParticleTile(4)

    ParticleAlpha(0.35)
    ParticleColor(0.9, 0.9, 1)

    ParticleGravity(0)
	ParticleRadius(0.3)
    ParticleCollide(1)

    SpawnParticle(tr.pos, Vec(0, 0.1, 0), 5)

end

