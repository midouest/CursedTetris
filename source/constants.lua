kGroupTet = 1
kGroupGrid = 2

kLCDWidth = 400
kLCDHeight = 240

kSpriteSize = 16

kGridTilesX = 10
kGridTilesY = 15

kGridWidth = kGridTilesX * kSpriteSize
kGridHeight = kGridTilesY * kSpriteSize
kWallSize = math.floor((kLCDWidth - kLCDHeight) / 2)
kGridX = math.floor(kWallSize / kSpriteSize)
kGridY = 0

kXGridInit = (kWallSize + kGridWidth / 2) / kSpriteSize
kYGridInit = 0

kWall1X = 0
kWall1Y = 0
kWall1W = kWallSize
kWall1H = kLCDHeight

kWall2X = kWallSize + kGridWidth
kWall2Y = 0
kWall2W = kLCDWidth - kWallSize - kGridWidth
kWall2H = kLCDHeight

kFloorX = 0
kFloorY = kLCDHeight
kFloorW = kLCDWidth
kFloorH = kWallSize

kCW = true
kCCW = false

kInitialDelay = 100
kRepeatDelay = 50
