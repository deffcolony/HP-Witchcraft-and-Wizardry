function init()
	belt = FindShape("belt",true)
	SetTag(belt, "interact", "remove belt")
	
	beltgone=false

	timer = 0.1
	timer2 = 0.3
	timer3=2
	n = 5
end

function tick(dt)
	timer=timer-dt
	timer2=timer2-dt
	timer3=timer3-dt

	paper=FindShape("paper",true)
	
	hinge=FindJoint("book", true)
	SetJointMotor(hinge, n)
	
	if not beltgone then
		if timer <= 0 then
			Delete(paper)
		end
	end

	if timer <= 0 then
		n= - n
		timer=timer+0.1
	end
	
	if timer3 <= 0 then
		timer3=timer3 + 2
	end

	if timer3 <= 0.15 then
		Delete(paper)
	end

	if InputPressed("interact") and GetPlayerInteractShape() == belt then
		Delete(belt)
		beltgone=true
	end
	
	if beltgone then
		book=FindShape("bottom",true)
		booktran=GetShapeWorldTransform(book)
		bookpos=TransformToParentPoint(booktran, Vec(0.5, 0.6, 0.1))
		bookdir=TransformToParentVec(booktran,Vec(0, 0, 0))
		bookrot=QuatLookAt(booktran,bookdir)
		
		if timer2 <= 0 then
			Spawn("MOD/resources/prefab/paper.xml", Transform(bookpos, bookrot))
			timer2=timer2+0.3
		end	
	end
end	