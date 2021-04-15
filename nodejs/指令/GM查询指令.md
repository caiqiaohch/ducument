# 跨服国战

## 准备活动
network.request("game.handler.rbcrealmResetCity", {optFunction: "prepare"}, noop);

## 开启活动
network.request("game.handler.rbcrealmResetCity", {optFunction: "start"}, noop);

## 结束活动
network.request("game.handler.rbcrealmResetCity", {optFunction: "finish"}, noop);

## 获得活动存储的世界最大等级
network.request("game.handler.rbcQueryCity", {type: "maxWorldLevel", lb: "rbcPlayer"}, noop);

## 获得活动当前状态
const State = {
    Prepare:3,  // 准备
    Start:1,    // 开始
    Close:0,    // 关闭
}
network.request("game.handler.rbcQueryCity", {type: "serverState", lb: "rbcPlayer"}, noop);

network.request("game.handler.rbcQueryCity",  {type: "leaderboard", lb: "rbcScorePower"}, noop);

# 百美人

## 获得跨服排行榜
network.request("game.handler.beauQueryBeauty", {type: "leaderboard", lb: "beautiChapter"}, noop);
network.request("game.handler.beauQueryBeauty", {type: "leaderboard", lb: "beautiDamage1"}, noop);

## 增加跨服排行榜测试数据
network.request("game.handler.beauAddbeautiChapter", {}, noop);

## 查询服务器武将属性和战力
network.request("game.handler.flowerGetBattlePower", {}, noop);

## gm指令
network.request("game.handler.gm", {cmd: "addItem", p: {itemId: 1, count: 24000000 }}, noop);
network.request("game.handler.gm", {cmd: "calcAltPower"}, noop);

## 道具克隆
168888 这个道具，你穿上就加战斗力，但是你别放策划服。
20082 这个神装套装箱
100012 200012  300012  400012  300302
你输入这些武将，然后用20082加上
86401~86409
chart.getAll("xxx")

## 打开调试信息
network.isLogNetworkMsg=1

## 天降神兵完成任务
com.setQuestServer()