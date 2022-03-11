kGroupTet = 1
kGroupGrid = 2

kLCDWidth = 400
kLCDHeight = 240

kSpriteSize = 16

kWallSize = (kLCDWidth - kLCDHeight) / 2
kGridX = math.floor(kWallSize / kSpriteSize)
kGridY = 0
kGridWidth = math.floor(kLCDHeight / kSpriteSize)
kGridHeight = math.floor(kLCDHeight / kSpriteSize)

kXGridInit = math.floor(kGridWidth / 2)
kYGridInit = 0

kCW = true
kCCW = false
