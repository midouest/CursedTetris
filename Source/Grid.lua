class("Grid").extends(Object)

function setupGridCollision(sprite)
    sprite:setGroups({kGroupGrid})
    sprite:setCollidesWithGroups({kGroupTet})
end

function Grid:init(w, h)
    self.w = w
    self.h = h
    self.sprites = table.create(w * h, 0)
end

function Grid:remove()
    for i = 1, self.w * self.h do
        local sprite = self.sprites[i]
        if sprite ~= nil then
            sprite:remove()
        end
    end
end

function Grid:gridToIndex(x, y)
    return x * self.h + y + 1
end

function Grid:addBlocks(xGrid, yGrid, blocks)
    for _, block in ipairs(blocks) do
        local x = xGrid + block.xTet
        local y = yGrid + block.yTet
        local i = self:gridToIndex(x, y)
        local sprite = block.sprite
        setupGridCollision(sprite)
        self.sprites[i] = sprite
    end

    self:updateFilledRows()
end

function Grid:updateFilledRows()
    local i = 1
    local filledRows = {}
    local filledCount = 0
    for x = 1, self.w do
        local filled = true
        for _ = 1, self.h do
            if self.sprites[i] == nil then
                filled = false
            end
            i = i + 1
        end

        if filled then
            filledRows[x] = true
            filledCount = filledCount + 1
        end
    end

    if filledCount == 0 then
        return
    end

    for x, _ in pairs(filledRows) do
        for y = 1, self.h do
            local i = (x - 1) * self.h + y
            local sprite = self.sprites[i]
            sprite:remove()
            self.sprites[i] = nil
        end
    end

    local shiftDown = 0
    for x = self.w, 1, -1 do
        if filledRows[x] then
            shiftDown = shiftDown + 1
        elseif shiftDown > 0 then
            for y = 1, self.h do
                local i = (x - 1) * self.h + y
                local sprite = self.sprites[i]
                if sprite ~= nil then
                    self.sprites[i] = nil
                    sprite:moveBy(shiftDown * kSpriteSize, 0)
                    local j = (x - 1 + shiftDown) * self.h + y
                    self.sprites[j] = sprite
                end
            end
        end
    end
end
