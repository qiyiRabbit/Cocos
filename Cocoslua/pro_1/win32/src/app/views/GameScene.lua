
local GameScene = class("GameScene", cc.load("mvc").ViewBase)
local visibleSize=cc.Director:getInstance():getVisibleSize()
function GameScene:onCreate()

   self:move()
end
function GameScene:move()
    self.player=cc.Sprite:create("HelloWorld.png")
    self.player:setScale(0.3)
    self:addChild(self.player)
    self.player:setPosition(cc.p(display.cx,display.cy-200))

    self.jian=cc.Sprite:create("HelloWorld.png")
    self.jian:setScaleX(0.08)
    self.jian:setScaleY(0.08)
    self.player:addChild(self.jian)
    self.jian:setPosition(cc.p(self.player:getContentSize().width/2,self.player:getContentSize().height/2+200))
    -- self.jian:setPosition(cc.p(display.cx,display.cy-200))

    local layer = cc.LayerColor:create(cc.c4b(0,0,128,255))
    self:addChild(layer , 10)
    layer:setOpacity(125)

    -- local clipS = cc.ClippingNode:create()  ----创建ClippingNode
--     clipS:setStencil(layer)
--     clipS:addChild(layer)
--     clipS:setInverted(false)   ---设置可视区为裁剪区域，还是裁剪剩余区域
--     clipS:setAlphaThreshold(1)  ---根据alpha值控制显示
--     clipS:setAnchorPoint(cc.p(0, 0))  
--     clipS:setName("clipS")
    -- self:addChild(clipS) ----添加到节点

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(handler(self,self.onTouchBegan),cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(handler(self,self.onTouchMoved),cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(handler(self,self.onTouchEnded),cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    -- eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    eventDispatcher:addEventListenerWithFixedPriority(listener,-128);

    -- listener:setEnabled(true)
end
function GameScene:onTouchBegan(touch,event)
    print("begin")
    self.beginPos=touch:getLocation()
    self:rotatePlayer(self.beginPos)
    return true
end
function GameScene:onTouchMoved(touch,event)
    self.movePos=touch:getLocation()
    self:rotatePlayer(self.movePos)
    print("move")
end
function GameScene:onTouchEnded(touch,event)
    print("ended")
    self.endPos=touch:getLocation()
    -- self.width=self.endPos.x-self.player:getPositionX()
    -- self.height=self.endPos.y-self.player:getPositionY()
    -- print(self.endPos.y,self.player:getPositionY())
    
    -- self:bezier(self.width,self.height)

    -- self.width=0
    self.height=60
    self.gravity=-1
    local function update(time)
        self.height=(self.height+self.gravity)
        -- self.width=self.width+1
        -- local heightNew=self.jian:getPositionY()+self.height
        -- if self.endPos.y<=heightNew then
        --     self.height=0
        -- end
        -- if self.endPos.x>240 then
        --     self.jian:setPosition(cc.p(self.jian:getPositionX()+3,self.jian:getPositionY()+self.height))
        -- elseif self.endPos.x<240 then
        --     self.jian:setPosition(cc.p(self.jian:getPositionX()-3,self.jian:getPositionY()+self.height))
        -- end

        if self.endPos.x>240 then
            self.jian:setPosition(cc.p(self.jian:getPositionX(),self.jian:getPositionY()+self.height))
        elseif self.endPos.x<240 then
            self.jian:setPosition(cc.p(self.jian:getPositionX(),self.jian:getPositionY()+self.height))
        end
    end
    self:scheduleUpdate(update)
    -- self:directorPlayer()
end
function GameScene:bezier(s,height)
    local bezier2 ={
        cc.p(0, 0),
        cc.p(50, 240),
        cc.p(100, 0)
    }
    local bezierTo1 = cc.BezierBy:create(1, bezier2)
    self.jian:runAction(bezierTo1)
    
    -- local jump = cc.JumpBy:create(1, cc.p(s,0), height, 1)
    -- self.jian:runAction(jump)
end
function GameScene:rotatePlayer(movePos)
   local playerPosX=self.player:getPositionX()
   local playerPosY=self.player:getPositionY()

   local vec_X=movePos.x-playerPosX
   local vec_Y=movePos.y-playerPosY

   local vectors=math.atan2(vec_X,vec_Y)*180/math.pi
   print(vectors)
   local speed=0.5/360
   local time=math.abs(vectors*speed)
   self.player:runAction( cc.RotateTo:create(time, vectors));

end
function GameScene:directorPlayer()
    local bg=cc.Sprite:create("player.png")
    self:addChild(bg)
    bg:setPosition(display.center)

    self.player=cc.Sprite:create("HelloWorld.png")
    self.player:setScale(0.2)
    self:addChild(self.player)
    -- self.player:setPosition(cc.p(display.cx,display.cy-100))
    -- self.player:setPosition(cc.p(0,0))

    -- local s = cc.Director:getInstance():getWinSize()
    -- if self._camera == nil then
    --     self._camera = cc.Camera:createPerspective(60, s.width/s.height, 30, 2000)
    --     self._camera:setCameraFlag(2)
    --     self.player:addChild(self._camera)
    --     self._camera:setPosition3D(cc.vec3(self.player:getContentSize().width/2, self.player:getPositionY(), 2000))--设置位置
    --     self._camera:lookAt(cc.vec3(0,0,0),cc.vec3(0,0,0))--设置初始位置
    -- end
    --     self:setCameraMask(2)

    local s = cc.Director:getInstance():getWinSize()
    if self._camera == nil then
        self._camera = cc.Camera:createOrthographic(s.width*5, s.height*5, 10, 1000)
        self._camera:setCameraFlag(2)
        self.player:addChild(self._camera)
        self._camera:setPosition3D(cc.vec3(-s.width*5/2+self.player:getContentSize().width/2, -s.height*5/2+self.player:getContentSize().height/2, 100))--设置位置
        self._camera:lookAt(cc.vec3(0,0,0),cc.vec3(0,0,0))--设置初始位置
    end
    self:setCameraMask(2)

    self.height=40
    self.gravity=-1
    local function update(time)
        self.height=(self.height+self.gravity)
        self.player:setPosition(cc.p(display.cx,self.player:getPositionY()+self.height))
        print(self.player:getContentSize().width/2)
    end
    self:scheduleUpdate(update)

    -- 　local s = cc.Director:getInstance():getWinSize()                                           --窗口大小
    --     self._camera = cc.Camera:createPerspective(60, s.width/s.height, 1, 500)--第一个参数是摄像机视角，一般是60度，第二个参数是屏幕宽高比，第三个和第四个参数分别近截面和远截面
    --     self._camera:setCameraFlag(cc.CameraFlag.USER1)--设置掩码值，掩码值要跟香看到的物体的掩码值一样
    --     self:addChild(self._camera)--添加到当前场景里
        -- self._camera:setPosition3D(cc.Camera:getDefaultCamera():getPosition3D())--设置位置
        -- self._camera:lookAt(cc.vec3(0,0,0),cc.vec3(0,0,0))--设置初始位置
end
return GameScene