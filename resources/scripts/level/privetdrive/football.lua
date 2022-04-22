-- Football

local function VecDist(a, b) return VecLength(VecSub(a, b)) end
local function GetRandomIndex(tb) return tb[math.random(1, #tb)] end


local kickStrength = 100
local kickProximity = 1
local minPlayerVel = 0.2


function init()

    Football = FindBody('football')

    Sounds = {
        LoadSound('MOD/resources/snd/football/kick1.ogg'),
        LoadSound('MOD/resources/snd/football/kick2.ogg'),
        LoadSound('MOD/resources/snd/football/kick3.ogg'),
    }

    LastKickTime = 0
    KickSoundFrequency = 0.5 + math.random()

end

function tick()

    BodyTr = GetBodyTransform(Football)
    PlayerTr = GetPlayerTransform()

    local playerClose = VecDist(BodyTr.pos, PlayerTr.pos) < kickProximity
    local kickIsReady = (GetTime() - LastKickTime) > KickSoundFrequency or not playerClose
    local playerMoving = VecLength(GetPlayerVelocity()) > minPlayerVel
    local notBroken = not IsShapeBroken(GetBodyShapes(Football)[1])

    if notBroken and kickIsReady and playerClose and playerMoving then

        KickFootball()

        LastKickTime = GetTime()
        KickSoundFrequency = 1 + math.random()

    end

end

function KickFootball()

    local playerVel = GetPlayerVelocity()

    local kickDir = VecAdd(VecSub(BodyTr.pos, PlayerTr.pos), Vec(0,3,0))
    local kickVel = VecScale((VecAdd(kickDir, playerVel)), kickStrength)

    ApplyBodyImpulse(Football, BodyTr.pos, kickVel)
    PlaySound(GetRandomIndex(Sounds), BodyTr.pos, 2)

end
