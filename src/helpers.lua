function math.oimod(n, d) return (n+d-1)%d+1 end

function table.tostring(tbl)
	local o = "{"
	for k, item in pairs(tbl) do
	
		if type(k) == "nil" then
			o = o .. "nil" .. ":"
		elseif type(k) == "string" then
			o = o .. "\"" .. k .. "\":"
		else
			o = o .. k .. ":"
		end
	
		if type(item) == "nil" then
			o = o .. "nil"
		elseif type(item) == "table" then
			o = o .. table.tostring(item)
		elseif type(item) == "string" then
			o = o .. "\"" .. tostring(item).."\""
		else
			o = o .. tostring(item)
		end
		o = o .. ", "
	end
	
	o = o .. "}"
	
	return o
end

function table.print(tbl)
	print(table.tostring(tbl))
end

-- Draw a center-top aligned Octave logo
function drawLogo(x, y)
	love.graphics.draw(gOctaveLogo, x - gOctaveLogo:getWidth()/8, y, 0, 0.25)
end

-- Draw a center-top aligned GCS logo. Sets color to white.
function drawGCSLogo(x, y)
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(gGCSLogo, x - gGCSLogo:getWidth()/10, y, 0, 0.2)
end