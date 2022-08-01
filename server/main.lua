---------------------this is just a base version of your game from what i understand
---------------------here if this is a server side code you need not send all the data to the player as you only need to send them
---------------------the player tab which is their current winning
---------------------the number on the dice
---------------------their score alongside the opponent score
---------------------and the server should recieve their inputs
---------------------if you want you can send them turn also but that does not matter
---------------------if you want a simple server sside code this is it
---------------------now only to add serialization and actually connect  :>
sock=require "sock"
bitser=require "bitser"
--require "connect"

math.randomseed(os.time())
window_width=800
window_height=800
roll=false
a=math.random(1,6)
player_score={0,0}
turn=1
player_tab=0
total_player=0
c1=0


function love.load()
  love.window.setMode(window_width,window_height)
  -----------------------------------------------
  server = sock.newServer("192.168.43.212",1080,2)
  server:setSerialization(bitser.dumps,bitser.loads)
  server:on("connect", function (data,client)
            --c1=client:getIndex()
            client:send("playerNum", client:getIndex())
            total_player=total_player+1
            end)

  server:on("player_roll",function (a)
            --local index = client:getIndex()
            roll=a==turn and true or false
            end)
  server:on("player_next",function (b)
            if(b==turn) then
            player_score[turn]=player_score[turn]+player_tab
            turn=turn==1 and 2 or 1
            player_tab=0
            end
            end)

end

function love.update(dt)
  if(roll==true)then
    a=math.random(1,6)
    if(a~=1)then
      player_tab=player_tab+a
    else
      player_tab=0
      turn=turn==1 and 2 or 1
    end
    roll=false
  end
  --------------------------------------server stuff
  server:update()
  --if --total_player<2 then
    --return
  --end
  server:sendToAll("playerState",{a,player_tab,player_score[1],player_score[2]})
  server:sendToAll("current_player",turn)
end

function love.keypressed(key)
  -- if(key=='space')then
  --   roll=true
  -- end
  -- if(key=='n')then
  --   player_score[turn]=player_score[turn]+player_tab
  --   turn=turn==1 and 2 or 1
  --   player_tab=0
  -- end
end

function love.draw()
  love.graphics.print(server:getSocketAddress(),400,400)
  -- love.graphics.print(player_tab,400,500)
  -- love.graphics.print(player_score[1],100,500)
  -- love.graphics.print(player_score[2],700,500)
end
