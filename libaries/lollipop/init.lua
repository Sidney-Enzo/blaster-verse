local path = ...
local json = require(path .. '.json')
local lollipop = {}
lollipop.currentSave = {
    version = 0,
    initDate = os.date("%Y-%m-%d %H:%M:%S"),
}
local currentSlot = ""

function lollipop.initializeSlot(_id)
    love.filesystem.createDirectory("slots")
    local nameHashed = love.data.encode("string", "hex", love.data.hash("md5", _id))
    local slotFile = love.filesystem.getInfo("slots/" .. nameHashed .. ".dat")
    
    if slotFile == nil then
        local fileSlot = love.filesystem.newFile("slots/" .. nameHashed .. ".dat", "w")
        fileSlot:write(love.data.compress("string", "zlib", love.data.encode("string", "base64", json.encode(lollipop.currentSave))))
        fileSlot:close()
    end
    lollipop.currentSave = json.decode(love.data.decode("string", "base64", love.data.decompress("string", "zlib", love.filesystem.read("slots/" .. nameHashed .. ".dat"))))
    currentSlot = nameHashed
end

function lollipop.slotExist(_id)
    local nameHashed = love.data.encode("string", "hex", love.data.hash("md5", _id))
    return love.filesystem.getInfo("slots/" .. nameHashed .. ".dat")
end

function lollipop.newSlot(_id)
    local nameHashed = love.data.encode("string", "hex", love.data.hash("md5", _id))
    local fileSlot = love.filesystem.newFile("slots/" .. nameHashed .. ".dat", "w")
    fileSlot:write(love.data.compress("string", "zlib", love.data.encode("string", "base64", json.encode(lollipop.currentSave))))
    fileSlot:close()
end

function lollipop.saveSlot(_id)
    local nameHashed = love.data.encode("string", "hex", love.data.hash("md5", _id))
    love.filesystem.write("slots/" .. nameHashed .. ".dat", love.data.compress("string", "zlib", love.data.encode("string", "base64", json.encode(lollipop.currentSave))))
end

function lollipop.saveCurrentSlot()
    love.filesystem.write("slots/" .. currentSlot .. ".dat", love.data.compress("string", "zlib", love.data.encode("string", "base64", json.encode(lollipop.currentSave))))
end

function lollipop.loadSlot(_id)
    local nameHashed = love.data.encode("string", "hex", love.data.hash("md5", _id))
    lollipop.currentSave = json.decode(love.data.decode("string", "base64", love.data.decompress("string", "zlib", love.filesystem.read("slots/" .. nameHashed .. ".dat"))))
    currentSlot = nameHashed
end

function lollipop.removeSlot(_id)
    local nameHashed = love.data.encode("string", "hex", love.data.hash("md5", _id))
    love.filesystem.remove("slots/" .. nameHashed .. ".dat")
end

return lollipop