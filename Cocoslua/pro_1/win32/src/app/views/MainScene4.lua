
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
function MainScene:onCreate()
    local skeletonNode = sp.SkeletonAnimation:create("spine/spineboy.json", "spine/spineboy.atlas", 1.5)
    skeletonNode:setAnimation(0, "walk", true)
    skeletonNode:setSkin("events")

    skeletonNode:setScale(0.25)
    local windowSize = cc.Director:getInstance():getWinSize()
    skeletonNode:setPosition(cc.p(200, 100))
    self:addChild(skeletonNode)
end
return MainScene