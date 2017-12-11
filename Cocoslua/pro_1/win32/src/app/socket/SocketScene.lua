local SocketScene = class("SocketScene", cc.load("mvc").ViewBase)
socket = require("socket.core")
jsonData = require("json")
function SocketScene:onCreate()
    local luaSocket = socket.tcp()
    luaSocket:settimeout(1)
    -- luaSocket:setTickTime(1)
    -- luaSocket:settimeout(1)
    -- luaSocket:settimeout(1)

    local  HOST = '192.168.16.113';
    local  PORT = 6080;

    
    if luaSocket:connect(HOST,PORT) == 1 then
        print("连接成功")
        luaSocket:send("Hello")
    else
        print("连接失败")
    end

    luaSocket:on()

    -- json.encode()
    -- luaSocket:close()
end
--[[
function SocketScene:onCreate()
        local winSize = cc.Director:getInstance():getWinSize()
    local MARGIN = 40
    local SPACE  = 35

    local label = cc.Label:createWithTTF("WebSocket Test", "fonts/arial.ttf", 28)
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:setPosition(cc.p( winSize.width / 2, winSize.height - MARGIN))
    self:addChild(label, 0)

    local menuRequest = cc.Menu:create()
    menuRequest:setPosition(cc.p(0, 0))
    self:addChild(menuRequest)

    --Send Text
    local sendTextStatus
    local function onMenuSendTextClicked()
        if nil ~= self._socket then
            if cc.WEBSOCKET_STATE_OPEN == self._socket:getReadyState() then
               sendTextStatus:setString("Send Text WS is waiting...")
               self._socket:sendString("Hello WebSocket中文, I'm a text message.")
            else
                local warningStr = "send text websocket instance wasn't ready..."
                print(warningStr)
                sendTextStatus:setString(warningStr)
            end
        end
    end
    local labelSendText = cc.Label:createWithTTF("Send Text", "fonts/arial.ttf", 22)
    labelSendText:setAnchorPoint(0.5, 0.5)
    local itemSendText  = cc.MenuItemLabel:create(labelSendText)
    itemSendText:registerScriptTapHandler(onMenuSendTextClicked)
    itemSendText:setPosition(cc.p(winSize.width / 2, winSize.height - MARGIN - SPACE))
    menuRequest:addChild(itemSendText)

    --Send Text Status Label
    sendTextStatus = cc.Label:createWithTTF("Send Text WS is waiting...", "fonts/arial.ttf", 14,cc.size(160, 100),cc.VERTICAL_TEXT_ALIGNMENT_CENTER,cc.VERTICAL_TEXT_ALIGNMENT_TOP)
    sendTextStatus:setAnchorPoint(cc.p(0, 0))
    sendTextStatus:setPosition(cc.p(0, 25))
    self:addChild(sendTextStatus)

    self._socket = cc.WebSocket:create("ws://echo.websocket.org")--("ws://127.0.0.1:6080")--("ws://localhost:8888")--("ws://echo.websocket.org")--("ws://192.168.16.11:8080")--("http://192.168.16.113:8080")--
     local function wsSendTextOpen(strData)
        -- sendTextStatus:setString("Send Text WS was opened.")
        print("wsSendTextOpen is "..strData)
    end

    local receiveTextTimes = 0
    local function wsSendTextMessage(strData)
        receiveTextTimes= receiveTextTimes + 1
        local strInfo= "response text msg: "..strData..", "..receiveTextTimes    
        -- sendTextStatus:setString(strInfo)
        print("wsSendTextMessage is "..strInfo)
    end

    local function wsSendTextClose(strData)
        print("_wsiSendText websocket instance closed.")
        -- sendTextStatus = nil
        -- wsSendText = nil
    end

    local function wsSendTextError(strData)
        print("sendText Error was fired")
    end

    if nil ~= self._socket then
        self._socket:registerScriptHandler(wsSendTextOpen,cc.WEBSOCKET_OPEN)
        self._socket:registerScriptHandler(wsSendTextMessage,cc.WEBSOCKET_MESSAGE)
        self._socket:registerScriptHandler(wsSendTextClose,cc.WEBSOCKET_CLOSE)
        self._socket:registerScriptHandler(wsSendTextError,cc.WEBSOCKET_ERROR)
    end
end
--]]
return SocketScene