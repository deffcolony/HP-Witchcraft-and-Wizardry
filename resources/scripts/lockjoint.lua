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
        SetJointMotor(joint, 0, 1000)
        SetTag(shape, "interact", "unlock")
    else
        SetJointMotor(joint, 0, 10)
        SetTag(shape, "interact", "lock")
    end
end