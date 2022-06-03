radioAlive = true
radioOn = false
songToPlay = 1
volume = 0.5

textcooldown = 300
counter = 0
--                                            JUST ADD "SONG.OGG" FILES BELOW AND COPY THE FILE IN THE "RADIO" FOLDER THE SCRIPT HANDLES THE REST
songs ={"MOD/resources/snd/harryhouseknradio.ogg",
        "MOD/resources/snd/harryhouseknradio.ogg"}

function init()
  channels = {}
  for i=1, #songs do
    channels[i] = LoadLoop(songs[i])
  end
  --songToPlay = math.random(#songs)
  breakSound = LoadSound("radioBreaksSound.ogg")
  nextSongSound = LoadSound("MOD/resources/snd/RadioNextSongSound.ogg")
  OnOffSound = LoadSound("MOD/resources/snd/harryhouseknradioONOFF")
  
  myRadio = FindShape("myradio", true)
  powerbutton = FindShape("radiopowerbutton", true)
  myButtonGreen = FindShape("radioButtonGreen", true)
  myVolUp = FindShape("radiovolupbutton", true)
  myVolDown = FindShape("radiovoldownbutton", true)
  myRandom = FindShape("radioButtonRandom", true)
  mylast = FindShape("radioButtonUndo", true)
  songToPlay = math.random(#songs)
end



function tick()
  local interactShape = GetPlayerInteractShape()
  if interactShape == 0 then interactShape = nil end
  if radioAlive then
    t = GetShapeWorldTransform(myRadio)
    if InputPressed("interact") and interactShape == myButtonGreen then
      PlaySound(nextSongSound, t.pos, 0.2)
      if radioOn then
        DrawShapeOutline(myRadio, 1, 1, 1, 1)
        songToPlay = songToPlay + 1
        StopMusic()
        
        if songToPlay > #songs then
          songToPlay = 1
        end
        schreib(songs[songToPlay])
      end
    end
    
    if InputPressed("interact") and interactShape == powerbutton then
      PlaySound(OnOffSound, t.pos, 0.2)
      DrawShapeOutline(myRadio, 1, 1, 1, 1)
      if radioOn then
        radioOn = false
        StopMusic()
      else
        radioOn = true
        schreib(songs[songToPlay])
      end
    end
    
    if InputPressed("interact") and interactShape == myVolUp then
      PlaySound(nextSongSound, t.pos, 0.2)
      volume = volume + 0.1
    end
    
    if InputPressed("interact") and interactShape == myVolDown then
      PlaySound(nextSongSound, t.pos, 0.2)
      volume = volume - 0.1
    end
    
    if volume > 1 then
      volume = 1
    end
    if volume < 0.1 then
      volume = 0.1
    end
    
    if InputPressed("interact") and interactShape == mylast then
      PlaySound(nextSongSound, t.pos, 0.2)
      if radioOn then
        DrawShapeOutline(myRadio, 1, 1, 1, 1)
        songToPlay = songToPlay - 1
        StopMusic()
        if songToPlay < 1 then
          songToPlay = #songs
        end
        schreib(songs[songToPlay])
      end
    end
    
    if InputPressed("interact") and interactShape == myRandom then
      if radioOn then
        playRandom()
        DrawShapeOutline(myRadio, 1, 1, 1, 1)
      end
      PlaySound(nextSongSound, t.pos, 0.2)
    end
  
    if radioOn then
      PlayLoop(channels[songToPlay], t.pos, volume)
    end
    
    if IsShapeBroken(myRadio) then
        killRadio()
        radioAlive = false
    end
  end
  
  if counter == 0 then
    for i=0 , 50 do
      DebugPrint(" ")
    end
  end
    
  
  if counter >= 0 then
    counter = counter - 1
  end
end  
  

function killRadio()
  StopMusic()
  PlaySound(breakSound, t.pos, 0.4)
  for i=0, 50 do
    spawnParticles()
  end
end


function spawnParticles()

  local factor = 5
  local v = Vec(math.random() * factor, math.random() * factor, math.random() * factor)
  math.random()
  local life = math.random()
  life = life*life * 5
  
  ParticleReset()
  ParticleEmissive(5, 0, "easeout")
  ParticleGravity(-10)
  ParticleRadius(0.03, 0.0, "easein")
  ParticleColor(1, 0.4, 0.3)
  ParticleTile(4)
  SpawnParticle(t.pos, v, life)
end
function playRandom()
  local rand = math.random(#songs)
  while rand == songToPlay do
    rand = math.random(#songs)
  end
  songToPlay = rand
  schreib(songs[songToPlay])
end

function schreib(text)
  counter = textcooldown
  for i=0 , 50 do
    DebugPrint(" ")
  end
  if GetBool('savegame.mod.debug.show.nowplaying') then
    DebugPrint("Now Playing:  " .. text)
  end
end

