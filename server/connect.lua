
function create_server()
  server = sock.newServer("172.26.48.210",16,2)
  server:setSerialization(bitser.dumps,bitser.loads)
  server:on("connect", funtion (data,client)
            client:send("playerNum", client:getIndex())
            total_player=total_player+1
            end)
  --players={sheet(0,0,0,0),sheet(0,0,0,0)}

  server:on("player_stat",funtion (click,client)
            local index =client:getIndex()

            roll=index==turn and true or false)
