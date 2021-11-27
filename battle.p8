pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
function init_battle()
 music(8)
 tenpo = 3
 battle = {slots = {},
 options = split("pona,utala,poka,telo,wawa,mute"),
 optsitelen = split("チ,ン,ソ,ラ,ョ,ろ"),
 cursor = 1, timer = 0, attack = {}}
 game.state = "battle"
end

function upd_battle()
 -- increment the timer
 battle.timer = min(battle.timer + 1, 150)
 -- move the cursor
 if(btnp(2))battle.cursor -= 1
 if(btnp(3))battle.cursor += 1
 -- make it loop back around
 battle.cursor %= #battle.options
 -- if the guage is full, force the cursor to pona
 if #battle.slots == tenpo then
  battle.cursor = 0
  -- if the guage is empty, move it off pona
 elseif #battle.slots == 0 then
  battle.cursor = max(1, battle.cursor)
 end
 -- if the item's selected,
 if btnp(4) then
  -- if pona then execute
  if #battle.slots == 0 and battle.cursor == 0 then
  elseif battle.cursor == 0 then
   battle.attack = battle.slots
   battle.slots = {}
   battle.timer = 0
  else
   -- else, put it in the guage table
   add(battle.slots, battle.cursor + 1)
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
 pprint(battle.optsitelen[i] .. " : ".. battle.options[i], i * 4 + 7, i * 6 + 6)
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
