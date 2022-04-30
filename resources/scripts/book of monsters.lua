function init()
	belt = FindShape("belt",true)
	SetTag(belt, "interact", "remove belt")
	
	timer = 0.1
	n = 5
end

function tick(dt)
	timer=timer-dt
	
	hinge=FindJoint("book", true)
	SetJointMotor(hinge, n)
	
	if timer <= 0 then
		n= - n
		timer=timer+0.1
	end
	
	if InputPressed("interact") and GetPlayerInteractShape() == belt then
		Delete(belt)
		
		book=FindBody("bottom",true)
		booktran=GetBodyTransform(book)
		bookdir=TransformToParentVec(booktran,Vec(0, 0, -1))
	end
	
	
end
	