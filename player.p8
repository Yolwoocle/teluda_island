pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
--player
function init_player()
 -- player variables
	p = {
		x = 32, y = 24,
		xs = 0, ys = 0,
		anim = 0, left = false,
		sped = 1, aspd = 0.25,
		health = 32, level = 1,
		atk = 8, def = 8, status = "チpona"
	}
end

function upd_player()
	if p.xs == 0 and p.ys == 0 then
		if btn(⬅️) then
			p.xs = -8
			p.left = true
		elseif btn(⬆️) then
			p.ys = -8
		elseif btn(➡️) then
			p.xs = 8
			p.left = false
		elseif btn(⬇️) then
			p.ys = 8
		end
	end

	slide(p)
	p.anim %= 4
	if abs(p.ys) == 1 or abs(p.xs) == 1 then
	 ?"\ai6x5" .. rnd({"c0", "b0", "e0"})
	end
end

function drw_player()
 if fget(mget((p.x + 4) /8, (p.y + 8) / 8), 6) then
  pal(split("1,1,1,2,1,5,6,2,4,9,3,1,5,8,9"))
 end
	spr(1 + p.anim, p.x, p.y + 4, 1, 1, p.left)
 pal()
end

function slide(obj)
	local spd = obj.sped

	collide(obj, 0)

	if not (obj.xs == 0) then
		obj.x += sgn(obj.xs) * spd
		obj.xs -= sgn(obj.xs) * spd
		obj.anim += obj.aspd
	elseif not (obj.ys == 0) then
		obj.y += sgn(obj.ys) * spd
		obj.ys -= sgn(obj.ys) * spd
		obj.anim += obj.aspd
	end
end

function collide(obj, flag)
	local x = obj.x + obj.xs
	local y = obj.y + obj.ys
	x /= 8
	y /=8

	if fget(mget(x, y), flag) then
		obj.xs = 0
		obj.ys = 0
	end
end
