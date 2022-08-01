sock = require "sock"
bitser = require "bitser"

dice=0
player_tab=0
player1_score=0
player2_score=0
current_turn=nil

function love.load()
  love.window.setMode(800,800)
  client = sock.newClient("192.168.43.212",1080)
  client:setSerialization(bitser.dumps,bitser.loads)
  client:connect()
  client:on("playerState",function (data)
            dice=data.a
            player_tab=data.b
            player1_score=data.c
            player2_score=data.d
            end)
  client:on("current_player",function (data)
            current_turn=data
            end)
  --client:setSchema("current_player","data")
  client:setSchema("playerState",{"a","b","c","d"})
  client:on("playerNum", function (num)
        playerNumber = num
    end)
    --client:on("playerNum", function ())
end

function love.update(dt)
  client:update()
end

function love.keypressed(key)
  if(key=="space")then
    client:send("player_roll",playerNumber)--client:getIndex())
  end
  if(key=="n")then
    client:send("player_next",playerNumber)
  end
end

function love.draw()
  love.graphics.printf("number on the dice",300,300,200,"center")
  love.graphics.print(dice,400,400)
  love.graphics.printf("current turn tab",300,600,200,"center")
  love.graphics.print(player_tab,400,700)
  love.graphics.printf("player 1 score",10,400,200,"center")
  love.graphics.print(player1_score,100,500)
  love.graphics.printf("player 2 score",600,400,200,"center")
  love.graphics.print(player2_score,700,500)
  if current_turn~=nil then
    love.graphics.printf("current playing player",300,50,200,"center")
    love.graphics.print(current_turn,400,150)
  end
  if playerNumber~=nil then
    love.graphics.print(playerNumber)--client:getIndex())
  end
end
