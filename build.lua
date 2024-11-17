return {
    name = "Blaster verse",
    developer = "Fox studio",
    output = "./build",
    version = "0.0.7",
    love = "11.5",
    ignore = {
        ".gitignore",
        "blasterVerse.gdd",
        "make.cmd",
        "build.lua",
        "changelog"
    },
    icon = "assets/images/gameIcon.png",
    identifier = "com.foxStudio.blasterVerse", 
    libs = { 
        all = {"LICENSE"}
    },
    platforms = {"windows", "linux", "macos"} 
}