cc.exports.KUALTYPE = {
    ["NORMAL"] = 1,
    ["OBSTACLE"] = 2,
    ["START"] = 3,
    ["END"] = 4,
    ["PATN"] = 5,
}
cc.exports.TileList = {
    ["node"] = {},
    ["tilePos"] = {}
}
cc.exports.OpenList = {
    ["node"] = {},
    ["tilePos"] = {}
}
cc.exports.CloseList = {
    ["node"] = {},
    ["tilePos"] = {}
}
cc.exports.StartGold = {
    ["node"] = nil,
    ["tilePos"] = {["x"] = 2,["y"]=2},
    ["type"] = KUALTYPE.START,
}
cc.exports.EndGold = {
    ["node"] = nil,
    ["tilePos"] = {["x"] = 5,["y"]=6},
    ["type"] = KUALTYPE.END,
}
cc.exports.Obstacle = {
    ["node"] = {},
    ["tilePos"] = {
        {["x"] = 3,["y"]=2},
        {["x"] = 3,["y"]=3},
        {["x"] = 3,["y"]=4},
        {["x"] = 2,["y"]=4},
        {["x"] = 3,["y"]=6},
        {["x"] = 3,["y"]=7},
        {["x"] = 3,["y"]=8},
        {["x"] = 5,["y"]=5},
        {["x"] = 5,["y"]=4},
    },
    ["type"] = KUALTYPE.OBSTACLE,
}
cc.exports.norGoldList = {}
cc.exports.GoldList = {}
cc.exports.PathList = {}