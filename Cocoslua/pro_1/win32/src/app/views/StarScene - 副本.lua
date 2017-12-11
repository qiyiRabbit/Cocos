local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local GridNode = import("app.UI.GridNode")

function MainScene:onCreate()
    self:Event()
    self:CreateMap()
    self:CreateGold(StartGold)
    self:CreateGold(EndGold)

    self:setObstacle()

    -- self.isWhile = true
    -- local a =10
    -- while(self.isWhile)
    -- do
    --    self.isWhile = self:setPath()
    -- end

    -- self:setPathColor()

    self.isWhile = true
    local function update(time)
        if self.isWhile then
            self.isWhile = self:setPath()
            self:setPathColor()
        end
    end
    self:scheduleUpdate(update , 5)
end
--创建地图
function MainScene:CreateMap()
    for i = 1 , 8 do
        TileList.node[i] = {}
        for j = 1 , 8 do
            local gridNode = GridNode:create("kuai.png")
            gridNode:setScale(0.2)
            gridNode:setPosition(38 + 35 *(i - 1) , 120+ 35 *(j - 1))
            self:addChild(gridNode)
            gridNode.X = i
            gridNode.Y = j
            gridNode.type = KUALTYPE.NORMAL
            gridNode:setGridColor()

            table.insert(TileList.node[i] , gridNode)
        end
    end
end
--创建主角和目标
function MainScene:CreateGold(GoldTable)
    GoldTable.node = GridNode:create("kuai.png")
    GoldTable.node:setScale(0.2)
    self:addChild(GoldTable.node)
    self:setGold(GoldTable)
    return GoldTable
end

function MainScene:Event()
    --抬起键盘
    local function onKeyReleased(keyCode, event)
        --a-124,d-127,w-146,s-142,j-133,k-134,l-135,i-132
         if keyCode==124 then
            GoldList = {}
            for i = 1 , 8 do
                for j = 1 , 8 do
                    if TileList.node[i][j].type == KUALTYPE.NORMAL then
                        table.insert(GoldList , TileList.node[i][j])
                        -- print(TileList.node[i][j].type)
                    end
                end
            end

            StartGold.tilePos = {["x"] = 2 , ["y"] = 2}
            self:setNormal()
            self:setObstacle()
            self:setGold(StartGold)
            
            local normal = GoldList[math.random(1,#GoldList)]
            local xx = normal.X
            local yy = normal.Y
            EndGold.tilePos = {["x"] = xx,["y"]=yy}
            self:setGold(EndGold)
            
            CloseList.node = {}
            self.isWhile = true
        end
    end
    --注册键盘事件
    local listener = cc.EventListenerKeyboard:create()
    -- listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED )
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function MainScene:setGold()
    -- body
end

--设置主角和目标位置
function MainScene:setGold(GoldTable)
    GoldTable.node.type = GoldTable.type
    GoldTable.node:setGridColor()
    GoldTable.node:setPosition(TileList.node[GoldTable.tilePos.x][GoldTable.tilePos.y]:getPosition())
    self:setGoldTable(GoldTable)
end

--设置地块颜色
function MainScene:setNormal()
    for i = 1 , 8 do
        for j = 1 , 8 do
            TileList.node[i][j].type = KUALTYPE.NORMAL
            TileList.node[i][j]:setGridColor()
        end
    end
end
--设置障碍物颜色
function MainScene:setObstacle()
    for k,v in pairs(Obstacle.tilePos) do
        TileList.node[v.x][v.y].type = KUALTYPE.OBSTACLE
        TileList.node[v.x][v.y]:setGridColor()
    end
end

--设置主角和目标类型
function MainScene:setGoldTable(GoldTable)
        TileList.node[GoldTable.tilePos.x][GoldTable.tilePos.x].type = GoldTable.type
        -- TileList.node[GoldTable.tilePos.x][GoldTable.tilePos.xj]:setGridColor()
end

--显示路径
function MainScene:setPathColor()
    for k,v in pairs(CloseList.node) do
        v.type = KUALTYPE.PATN
        v:setGridColor()
    end
end

--查找路径
function MainScene:setPath()
    local tile = StartGold.tilePos
    --判断是否查找到终点目标
    if tile.x == EndGold.tilePos.x and tile.y == EndGold.tilePos.y then
        return false
    end
    print("=============================")
    StartGold.node.G = self:computeG()
    for i =-1 , 1 do
        for j =-1 , 1 do
            -- if math.abs(i) + math.abs(j) > 0 then
            if math.abs(i) + math.abs(j) > 0 and math.abs(i) ~= math.abs(j) then
                if tile.x + i ~= 0 and tile.y + j ~= 0 and tile.x + i ~= 9 and tile.y + j ~= 9  then
                    if TileList.node[tile.x + i][tile.y + j].type ~= KUALTYPE.OBSTACLE then
                        if not self:isHaveGold(tile.x + i,tile.y + j) then
                            TileList.node[tile.x + i][tile.y + j].X = tile.x + i
                            TileList.node[tile.x + i][tile.y + j].Y = tile.y + j
                            TileList.node[tile.x + i][tile.y + j].G = StartGold.node.G
                            TileList.node[tile.x + i][tile.y + j].H = self:computeH(tile.x + i,tile.y + j)
                            TileList.node[tile.x + i][tile.y + j].F = self:computeF(TileList.node[tile.x + i][tile.y + j].G , TileList.node[tile.x + i][tile.y + j].H)
                            table.insert(OpenList.node , TileList.node[tile.x + i][tile.y + j])
                            print("###55555##>>>>",tile.x + i,tile.y + j)
                            -- table.insert(OpenList.tilePos , { ["X"] = tile.x + i ,["Y"] = tile.y + j })
                        end
                    end
                end 
            end
        end
    end

    --排序
    local function _sort(a,b)
        return a.F < b.F
    end
    table.sort(OpenList.node ,_sort)

    --筛选F值最小的值,且存放到CloseList表中
    for k = 1 , #OpenList.node do
        local v = OpenList.node[k]
        if k > 1 then
            if OpenList.node[1] == v then
                table.insert(self.list , v)
            end
        else
            self.list = {}
            table.insert(self.list , OpenList.node[1])
        end
        -- print(v.X , v.Y , v.G,v.H , v.F)
    end

    --将其筛选的最佳对象存放到CloseList表中
    if #self.list > 1 then
        table.insert(CloseList.node , OpenList.node[math.random(1,#self.list)])
    else
        table.insert(CloseList.node , OpenList.node[1])
    end

    --清除筛选最佳位置的缓存
    OpenList.node = {}

    --将最佳位置坐标赋值给开始位置坐标，以便下次查找
    StartGold.tilePos = {["x"] = CloseList.node[#CloseList.node].X , ["y"] = CloseList.node[#CloseList.node].Y}
    print(#self.list)
    return true
end

--检测是否走过的坐标
function MainScene:isHaveGold(X,Y)
    for k,v in pairs(CloseList.node) do
        if X == v.X and Y == v.Y then
            return true
        end
    end
    return false
end


--生成路径

--计算G值
function MainScene:computeG()
    return StartGold.node.G + 1
end
--计算H值
function MainScene:computeH(x,y)
    return math.abs (EndGold.tilePos.x - x) + math.abs (EndGold.tilePos.y - y)
end
--计算F值
function MainScene:computeF(G,H)
    return math.abs (G) + math.abs (H)
end
return MainScene