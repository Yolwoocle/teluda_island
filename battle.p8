pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
function init_battle()
 music(8)
 tenpo = 3
 battle = {slots = {}, options = split("pona,utala,kan,telo,wawa,mute"), cursor = 1, timer = 0, attack = {}}
 game.state = "battle"
end

function upd_battle()
 -- increment the timer
 battle.timer = min(battle.timer + 1, 120)
 -- move the cursor
 if(btnp(2))battle.cursor -= 1
 if(btnp(3))battle.cursor += 1
 -- make it loop back around
 battle.cursor %= #battle.options
 -- if the item's selected,
 if btnp(4) then
  -- if ponam then execute
  if battle.cursor == 0 then
   battle.attack = battle.slots
   battle.slots = {}
   battle.timer = 0
  else
   -- else, put it in the guage table
   add(battle.slots, battle.options[battle.cursor + 1])
  end
 end
 -- if back is pressed, remove it
 if(btnp(5)) deli(battle.slots, #battle.slots)
end

function draw_battle()
 cls(1) camera()
 -- draw the background
 map(0,16,0,0)
 -- draw teluda
 spr(t() * 2 % 2 + 1, 24, 40)
 -- draw enemy
 spr(5, 104, 40)
 -- hud/menus
 camera(0, -74)
 -- draw the gauge
 rectfill(0, 6, (battle.timer * tenpo / 120 * 25) - 1, 10, 12)
 -- draw the border of the gauge
 for i = 0, tenpo - 1 do
  rect(i * 25, 6, i * 25 + 24, 10, 7)
 end
 -- draw the tenpo text
 print("tenpo", tenpo * 25 + 2, 6, 2)
 print("tenpo", tenpo * 25 + 1, 6, 8)
 -- draw the list of options
 for i = 1, #battle.options do
  print(battle.options[i], i * 4 + 7, i * 6 + 6, i == 1 and 11 or 7)
 end
 -- draw the cursor
 spr(32, battle.cursor * 4 + sin(t()) + 2, battle.cursor * 6 + 11)
 -- draw the contents of the guage
 for i = 1, #battle.slots do
  print(battle.slots[i], (i * 25) - 24, 0, 7)
 end
 -- draw current attack
 if battle.attack then
  local str = ""
  -- make it into a string
  for i = 1, #battle.attack do
   str ..= battle.attack[i] .. " "
  end
  -- remove the last space
  str = sub(str, 1, -2)
  --print the attack name
  local len = #str * 2
  rectfill(61 - len, -67, 65 + len, - 57, 1)
  rect(62 - len, -66, 64 + len, - 58, 6)
  print(str, 64 - #str - #str, -64, 7)

 end
end
