local tilemapFilename<const> = "data/Tilemap.json"

local function loadTetRotation(layerJSON, imageTable, xOff, yOff, w, h)
    local blocks = {}
    for y = 1, h do
        for x = 1, w do
            local i = (y - 1 + yOff) * layerJSON.width + x + xOff
            local spriteIndex = layerJSON.data[i]
            if spriteIndex ~= 0 then
                local image = imageTable[spriteIndex]
                local sprite = playdate.graphics.sprite.new(image)
                sprite:setCenter(0, 0)
                sprite:setCollideRect(0, 0, sprite:getSize())
                sprite:setGroups({kGroupTet})
                sprite:setCollidesWithGroups({kGroupGrid})
                sprite:moveTo(0, 0)
                local xTet = x - 1
                local yTet = y - 1
                local block = Block(xTet, yTet, sprite)
                table.insert(blocks, block)
            end
        end
    end
    return Rot(blocks)
end

local function loadTet(layerJSON, imageTable, xOff, yOff, w, h, nRotations)
    local rotations = {}
    local x = xOff
    local y = yOff
    for _ = 1, nRotations do
        local rotation = loadTetRotation(layerJSON, imageTable, x, y, w, h)
        table.insert(rotations, rotation)
        x = x + w
    end
    return Tet(0, 0, rotations)
end

function loadTets()
    local tilemapFile = playdate.file.open(tilemapFilename)
    local tilemapJSON = json.decodeFile(tilemapFile)
    tilemapFile:close()

    local layerJSON = tilemapJSON.layers[1]
    local tilesetJSON = tilemapJSON.tilesets[1]

    local tilesetFullPath = tilesetJSON.image
    local suffixIndex = string.find(tilesetFullPath, "-table-")
    local tilesetPath = string.sub(tilesetFullPath, 1, suffixIndex - 1)

    local imageTable = playdate.graphics.imagetable.new(tilesetPath)

    local tetrominoes = {}

    local tetI = loadTet(layerJSON, imageTable, 0, 0, 4, 4, 2)

    table.insert(tetrominoes, tetI)
    local tetO = loadTet(layerJSON, imageTable, 8, 0, 4, 4, 1)
    table.insert(tetrominoes, tetO)
    local tetT = loadTet(layerJSON, imageTable, 0, 4, 3, 3, 4)
    table.insert(tetrominoes, tetT)
    local tetJ = loadTet(layerJSON, imageTable, 0, 7, 3, 3, 4)
    table.insert(tetrominoes, tetJ)
    local tetL = loadTet(layerJSON, imageTable, 0, 10, 3, 3, 4)
    table.insert(tetrominoes, tetL)
    local tetZ = loadTet(layerJSON, imageTable, 0, 13, 3, 3, 2)
    table.insert(tetrominoes, tetZ)
    local tetS = loadTet(layerJSON, imageTable, 6, 13, 3, 3, 2)
    table.insert(tetrominoes, tetS)

    return tetrominoes
end
