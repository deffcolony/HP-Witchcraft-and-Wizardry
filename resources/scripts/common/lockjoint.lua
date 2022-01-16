function init ()
    joint = FindJoint("joint")
    shape = FindShape("target")

    locked = true
end

function tick()
    if GetPlayerInteractShape() == shape and InputPressed("interact") then
        locked = not locked
    end

    if locked then
        SetJointMotor(joint, -1, 1000)
        SetTag(shape, "interact", "Open")
    else
        SetJointMotor(joint, 1, 1000)
        SetTag(shape, "interact", "Close")
    end
end