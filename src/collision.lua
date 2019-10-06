function circleCollision(x1, y1, r1, x2, y2, r2)
	
	local distance = math.sqrt(math.pow((x2 - x1), 2) + math.pow((y2 - y1), 2))
	return distance <= r1 + r2, distance
	
end

function noteCollision(pad, note)
	assert(pad.radius == note.radius)
	
	local collides, distance = circleCollision(pad.x, pad.y, pad.radius, note.x, note.y, note.radius)
	
	-- The distance between the passed-in objects in terms of their radius.
	-- Their radius must be the same because of the precondition.
	local proportionalDistance = distance / pad.radius
	
	return collides, proportionalDistance
end