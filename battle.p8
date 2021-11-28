pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
function init_battle()
 --music(8)
 -- current length of tenpo guage
 tenpo = 3
 -- battle variables
 battle = {
 slots = {},
 options = split("o pini,utala,poka,telo,wawa,mute"),
 optsitelen = split("アス,ン,ソ,ラ,ョ,ろ"),
 cursor = 1, timer = 0, attack = {},
 health = p.health, state = "main"
 }
 game.state = "battle"
end

function upd_battle()
 -- increment the timer
 battle.timer = min(battle.timer + 1, 150)
 -- move the cursor
 if(btnp(2) or btnp(0))battle.cursor -= 1 ?"\ax5e0"
 if(btnp(3) or btnp(1))battle.cursor += 1 ?"\ax5e0"
 -- make it loop back around
 battle.cursor %= #battle.options
 if #battle.slots == tenpo then
  -- if the guage is full, force the cursor to o pini
  battle.cursor = 0
 elseif #battle.slots == 0 then
  -- edge case to make sure it still loops backwards after being pushed off of o pini
  if battle.cursor == 0 and btnp(2) then
   battle.cursor = #battle.options - 1
  end
  -- if the guage is empty, move it off o pini
  battle.cursor = max(1, battle.cursor)
 end
 -- if the item's selected,
 if btnp(4) then
  if #battle.slots == 0 and battle.cursor == 0 then
   -- if pona then execute
  elseif battle.cursor == 0 then
   -- put it in the attack table and reset
   battle.attack = battle.slots
   battle.slots = {}
   battle.timer = 0
   --sfx
   ?"\ac4c5"
  else
   -- else, put it in the guage table
   add(battle.slots, battle.cursor + 1)
   --sfx
   ?"\ac4c5"
  end
 end
 -- if back is pressed, remove it
 if(btnp(5)) deli(battle.slots, #battle.slots) ?"\ac4c3"
end

function draw_battle()
 cls(1) camera()
 -- draw the background
 map(0,16,0,0)
 -- draw teluda
 spr(t()*2%2\1==1 and 42 or 40, 24, 32, 2, 2)
 -- draw enemy
 spr(5, 104, 40)
 -- hud/menus
 camera(0, -74)
 -- draw the gauge
 rectfill(0, 6, (battle.timer / 150 * 128) - 1, 10, 12)
 -- draw the border of the gauge
 local glen = 128 / tenpo
 for i = 0, tenpo - 1 do
  rect(i * glen, 6, i * glen + glen, 10, 6)
 end
 -- draw the tenpo text
 for i = 1, 2 do
  pprint("リtenpo", 98, 11 - i, i * 6 - 4)
 end
 -- draw the list of options
 for i = 1, #battle.options do
  if i == 1 then
   color(#battle.slots > 0 and 11 or 3)
  else
   color(#battle.slots == tenpo and 13 or 7)
  end
 pprint(battle.optsitelen[i] .. " : ".. battle.options[i], i * 4 + 5, i * 6 + 6)
 end
 -- draw the cursor
 spr(32, battle.cursor * 4 + sin(t()) + 2, battle.cursor * 6 + 11)
 -- draw the contents of the guage
 for i = 1, #battle.slots do
  pprint("\#d" .. battle.optsitelen[battle.slots[i]], glen * i - (glen / 2 + 5), 2, 7)
 end
 -- draw current attack
 if #battle.attack > 0 then
  local str = ""
  -- make it into a string
  for i = 1, #battle.attack do
   str ..= battle.optsitelen[battle.attack[i]]
  end
  --print the attack name
  local len = #str * 4
  rectfill(60 - len, -67, 66 + len, - 57, 1)
  rect(61 - len, -66, 65 + len, - 58, 6)
  pprint(str, 64 - len, -64, 7)

 end
end
