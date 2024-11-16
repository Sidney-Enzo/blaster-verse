function love.conf(t)
--&screen and window
    -- t.console = true
    t.window.fullscreen = true
    t.window.resizable = false
    t.window.borderless = false
    t.window.x =  nil
    t.window.y =  nil
    t.window.width = 845 --it don't work on mobile, its is only to define if the game is in protatil mode
    t.window.height = 387
--&game
    t.window.title = "Blaster verse"
    t.window.icon = 'assets/images/gameIcon.png'
    --t.version = "11.4" --the love version that the game was maded
--&save directory
    t.externalstorage = true --&to be able to create files and load external files
    t.identity = "Blaster verse" 
    t.appendidentity = false
end