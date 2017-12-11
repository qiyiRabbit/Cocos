
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
    local visibleSize=cc.Director:getInstance():getVisibleSize()
function MainScene:onCreate()
    -- local cjson = require "cjson"  
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(handler(self,self.onTouchBegan),cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(handler(self,self.onTouchMoved),cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(handler(self,self.onTouchEnded),cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function MainScene:onTouchBegan(touch,event)
    print("begin")
    self.beginPos=touch:getLocation()

    return true
end
function MainScene:onTouchMoved(touch,event)
    print("move")
    self.movePos=touch:getLocation()
    
    self.pos_x=self.movePos.x-self.beginPos.x
    self.pos_y=self.movePos.y-self.beginPos.y
    print(self.pos_x,self.pos_y)
end
function MainScene:onTouchEnded(touch,event)
    print("ended")
    self.endPos=touch:getLocation()
end

return MainScene
