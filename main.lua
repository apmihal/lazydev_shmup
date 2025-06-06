pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
 cls(0)
 shipx=64
 shipy=64
 
 shipsx=0
 shipsy=0

 shipspr=2
 flamespr=23
 
 bulx=64
 buly=-10

 muzzle=0
 bulframe=16

 score=32000

 max_health=5
 current_health=3
 flame_frame=23
 boost_frame=7

 bullets={}
end

function _update()
 
 bulframe+=1
 if bulframe>18 then
  bulframe=16
 end

 --controls
 shipsx=0
 shipsy=0

 shipspr=33
 
 if flame_frame>26 then
  flame_frame=23
 end 

 flamespr=flame_frame
 flame_frame+=1
 
 if btn(0) then
  shipsx=-2
  shipspr=32
  flamespr=4
 end
 if btn(1) then
  shipsx=2
  shipspr=34
  flamespr=6
 end

 if btn(2) then
  shipsy=-2
  
  if boost_frame>=9 then
   boost_frame=7
  end
  boost_frame+=1
  flamespr=boost_frame

 end

 if btn(3) then
  shipsy=2
  flamespr=7
 end

 poke(0x5f5c,5)--changes delay before btnp repeats
 poke(0x5f5d,5)--changes delay between repetitions
 if btnp(5) then
  --bulx=shipx
  --buly=shipy-3
  add(bullets,{x=shipx,y=shipy})
  sfx(0)
  muzzle=4
 end
 
 --moving the ship
 shipx=shipx+shipsx
 shipy=shipy+shipsy
 
 --move the bullets
 for i,pos in ipairs(bullets) do
  if is_on_screen(pos.x,pos.y) then
   pos.y-=4
  else
   del(bullets,pos)
  end
 end
 --buly=buly-4
 
 --animate muzzle flash
 if muzzle>0 then
 	muzzle=muzzle-1
 end

 
 
 --checking if we hit the edge
 if shipx>122 then
  shipx=122
 end
 if shipx<-2 then
  shipx=-2
 end

 if shipy>117 then
  shipy=117
 end
 if shipy<-2 then
  shipy=-2
 end
 
end

function _draw()
 cls(0) 

 spr(flamespr,shipx,shipy+8)

 --spr(bulframe,bulx,buly)

 for i,pos in ipairs(bullets) do
  spr(bulframe,pos.x,pos.y)
 end
 
 if muzzle>0 then
  circfill(shipx+3,shipy,muzzle,10)
  circfill(shipx+4,shipy,muzzle,10)
 end

 spr(shipspr,shipx,shipy)

 print("score:"..score,80,1,12)
 
 draw_health()

 --print(flamespr,0,122,7)

end

function is_on_screen(x,y)
 if (x>=0 and x<=127) and (y>=0 and y<=127) then
  return true
 end
end

function draw_health()
 -- -7+8=1 so first heart will appear at x=1
 -- and following hearts are spaced 8px
 heartx=-7
 spacing=8

 full_heart=10
 empty_heart=11

 hearty=1

 if current_health>max_health then
  current_health=max_health
 end

 for i=1,current_health do
  heartx+=spacing
  spr(full_heart,heartx,hearty)
 end

 for i=1,(max_health-current_health) do
  heartx+=spacing
  spr(empty_heart,heartx,hearty)
 end

end
