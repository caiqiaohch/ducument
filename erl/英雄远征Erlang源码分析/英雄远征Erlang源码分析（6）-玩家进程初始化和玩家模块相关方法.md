英雄远征Erlang源码分析（6）-玩家进程初始化和玩家模块相关方法

客户端发送登录请求后，服务器检查玩家登录需求，创建玩家进程以及进行相关的初始化工作，只有这些做完后，客户端操控的角色才算是和服务器的玩家进程建立了关联。

创建玩家进程调用mod_player:start/1，使用process_flag(priority,max)将进程优先度设置为最高，返回玩家进程的Pid。

登录检查通过，调用mod_login:login_success/4，初始化玩家内存信息和相关进程：
    1.打开广播信息进程：send_msg(Socket)，使用尾递归形式循环等待消息。send_msg/1代码如下：

send_msg(Socket) ->
    receive
        {send, Bin} ->
            gen_tcp:send(Socket, Bin),
            send_msg(Socket);
            
        {move, Q, X1, Y1, X2, Y2, BinData, BinData1, BinData2} ->
            lib_scene:move_broadcast(Q, X1, Y1, X2, Y2, BinData, BinData1, BinData2, Socket),
            send_msg(Socket)
    end.
    2.打开战斗进程：mod_battle:start_link/1
    3.打开物品管理进程：mod_goods:start/1，初始化玩家物品，物品属性，玩家装备
    4.打开坐骑管理进程：mod_mount:start/1（坐骑有灵力系统，行动格数会消耗灵力）
    5.加载宠物：lib_pet:role_login/1
    6.初始化帮派：lib_guild:role_login/1
    7.计算属性加成，将二级属性转换为一级属性（智慧，敏捷，力量三项，不直接参与战斗时的伤害计算，需要转换）
    8.获取技能：lib_skill:get_all_skill/1
    9.构建#player_status，cast给玩家进程，设置为玩家进程的state
    10.更新ets_online表
    11.加载任务，生成当前可接任务列表
    12.初始化好友ets
    13.通知好友，仇人
    
玩家下线逻辑：
    0.停止玩家进程，调用mod_login:logout(Status)
    1.离开场景，通知场景内九宫格内玩家下线信息
    2.通知副本，修改PS副本状态，清除副本
    3.删除在线玩家ets物品记录
    4.通知好友，仇人下线
    5.清理宠物，帮派ets
    6.删除玩家ets_online记录
    7.关闭socket连接

在mod_player.erl里面一些比较具有普适性，比较典型的方法：

    handle_cast({"SET_TEAM_PID",TeamId},Status)    设置组队进程Pid
    handle_cast({"SET_PLAYER",NewStatus},_Status)    设置新的#player_status
    handle_call({"SOCKET_EVENT",Cmd,Bin},_From,Status)    接收call过来的协议信息，在routing/3内处理，修改#player_status，返回ok
    handle_call({"PLAYER",_From,Status)    获取玩家信息，返回#player_status
    handle_call({'EXP',Exp},_From,Status)    加经验，返回#player_status
    handle_info({'BATTLE',[Hp,Mp,X,Y],Pid},Status)    更新战斗信息
    handle_info({'BATTLE_STATUS',BattleStatus},Status)    设置战斗状态
    handle_info({'HP',Hp},Status)    设置血量

在lib_player.erl里面比较典型的方法：

    add_exp(Status,Exp)    增加经验，返回#player_status，需要判断是否升级
    get_online_info(PlayerId)    获取在线玩家信息，去查ets_online表
    count_player_attribute(PlayerStatus)    计算人物属性。需要获取人物，宠物的一级属性，转换为二级属性后再加上原始二级属性和装备二级属性
    one_to_two(Forza,Agile,Wit,Career)    一级属性转换为二级属性，具体有公式
    player_die(NewStatus,Pid)    玩家死亡处理，处理宠物，加仇人
————————————————
版权声明：本文为CSDN博主「Hidoshisan」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/s291547/article/details/88129316