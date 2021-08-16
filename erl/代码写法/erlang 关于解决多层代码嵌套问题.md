# erlang 关于解决多层代码嵌套问题

1.使用throw 抛出异常，结束判断，立即返回

check(Player, Goods, Count) ->

  try

    Info  = Player#player.info,
    
    Time  = misc:seconds(),
    
    case map_api:check_goods(Info#info.map_id, Goods#goods.goods_id) of
    
      ?true ->
    
        ?ok    = check_count(Goods#goods.count, Count),
    
        ?ok   = check_pro(Info#info.pro, Goods#goods.pro),
    
        ?ok   = check_sex(Info#info.sex, Goods#goods.sex),
    
        ?ok   = check_lv(Info#info.lv, Goods#goods.lv),
    
        ?ok    = check_time(Time, Goods#goods.start_time, Goods#goods.end_time),
    
        ?ok   = check_vip(Player#player.vip, Goods#goods.vip),
    
        ?ok   = check_country(Info#info.country, Goods#goods.country),
    
        ?ok;
    
      ?false ->
    
        {?error, 110}
    
    end

  catch

    throw:Return ->
    
            Return;
    
    _:_ ->
    
      {?error, unknow}

  end.

 

%% 检查物品数量

check_count(Count, RequestCount) when 0 =< Count andalso Count =< RequestCount -> ?ok;

check_count(_, _) -> throw({?error, 110}).

%% 检查职业

check_pro(_Pro, ?CONST_SYS_PRO_NULL) -> ?ok;

check_pro(Pro, Pro) -> ?ok;

check_pro(_, _) -> throw({?error, ?EGOODS_PROFESION_NOT_FIT}).

%% 检查性别

check_sex(_Sex, ?CONST_SYS_SEX_NULL) -> ?ok;

check_sex(Sex, Sex) -> ?ok;

check_sex(_, _) -> throw({?error, 110}).

%% 检查等级

check_lv(_Lv, 0) -> ?ok;

check_lv(Lv, RequestLv) when Lv >= RequestLv -> ?ok;

check_lv(_, _) -> throw({?error, ?EGOODS_LV_NOT_FIT}).

%% 检查有效期

check_time(_Time, 0, 0) -> ?ok;

check_time(Time, 0, EndTime) when Time =< EndTime -> ?ok;

check_time(Time, StartTime, 0) when Time >= StartTime -> ?ok;

check_time(Time, StartTime, EndTime) when Time >= StartTime andalso Time =< EndTime -> ?ok;

check_time(_, _, _) -> throw({?error, 110}).

%% 检查VIP

check_vip(_Vip, 0) -> ?ok;

check_vip(Vip, RequestVip) when Vip >= RequestVip -> ?ok;

check_vip(_, _) -> throw({?error, 110}).

%% 检查国家

check_country(_Country, 0) -> ?ok;

check_country(Country, Country) -> ?ok;

check_country(_, _) -> throw({?error, 110}).

 2，使用多层匹配，减少嵌套。

Guild = ets_api:lookup(?CONST_ETS_GUILD, GuildId),

GulildPlayer = Player#player.guild,

GuildMember = ets_api:lookup(?CONST_ETS_GUILD_MEMBER, UserId),%%申请人

ApplyList = Guild#ets_guild.apply ,

Apply = lists:keyfind(UserId, #apply.player_id, ApplyList),

case {GulildPlayer#guild.guild_pos >?CONST_GUILD_POSITION_ELDER,

 Guild#ets_guild.num_current >= Guild#ets_guild.num_limit,

 Apply#apply.is_cancel =:= 1,

 is_record(GuildMember, ets_guild_member) andalso GuildMember#ets_guild_member.guild_id > 0} of

{?true,_,_,_} -> %%权限不足

TipPacket = message_api:msg_notice(?TIP_GUILD_DEALAPPLY_NOPREMISS),

misc_packet:send(Player#player.net_pid, TipPacket);

{_,?true,_,_} -> %%成员上限

TipPacket = message_api:msg_notice(?TIP_GUILD_DEALAPPLY_MEMBEROVER),

misc_packet:send(Player#player.net_pid, TipPacket);

{_,_,?true,_} -> %%取消申请

TipPacket = message_api:msg_notice(?TIP_GUILD_DEALAPPLY_CANCELAPPLY),

misc_packet:send(Player#player.net_pid, TipPacket);

{_,_,_,?true} -> %%已加入军团

TipPacket = message_api:msg_notice(?TIP_GUILD_DEALAPPLY_REJOIN),

misc_packet:send(Player#player.net_pid, TipPacket);

{?false,?false,?false,?false}  ->

GuildId = Guild#ets_guild.id,

GuildName = Guild#ets_guild.name,
————————————————
版权声明：本文为CSDN博主「vanadiumlin007」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/vanadiumlin007/article/details/84282688