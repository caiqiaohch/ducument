calendar:date_to_gregorian_days/1
返回从公元零年到所给出的时间之间的天数

用法：

date_to_gregorian_days(Date) -> Days
内部实现：

-spec date_to_gregorian_days(Year, Month, Day) -> Days when
      Year :: year(),
      Month :: month(),
      Day :: day(),
      Days :: non_neg_integer().
date_to_gregorian_days(Year, Month, Day) when is_integer(Day), Day > 0 ->
    Last = last_day_of_the_month(Year, Month),
    if
	Day =
	    dy(Year) + dm(Month) + df(Year, Month) + Day - 1
    end.

-spec date_to_gregorian_days(Date) -> Days when
      Date :: date(),
      Days :: non_neg_integer().
date_to_gregorian_days({Year, Month, Day}) ->
    date_to_gregorian_days(Year, Month, Day).
获取从公元零年到所给出的时间 Date 之间的天数：

calendar:date_to_gregorian_days({1970, 1, 1}).
calendar:date_to_gregorian_days({2013, 9, 18}).

----------
calendar:date_to_gregorian_days/3
返回从公元零年到所给出的时间之间的天数

用法：

date_to_gregorian_days(Year, Month, Day) -> Days
内部实现：

-spec date_to_gregorian_days(Year, Month, Day) -> Days when
      Year :: year(),
      Month :: month(),
      Day :: day(),
      Days :: non_neg_integer().
date_to_gregorian_days(Year, Month, Day) when is_integer(Day), Day > 0 ->
    Last = last_day_of_the_month(Year, Month),
    if
    Day =
        dy(Year) + dm(Month) + df(Year, Month) + Day - 1
    end.
获取从公元零年到 Year 年 Month 月 Day 日之间的天数：

calendar:date_to_gregorian_days(1970, 1, 1).
calendar:date_to_gregorian_days(2013, 9, 18).

----------
calendar:datetime_to_gregorian_seconds/1
计算从公历 0 年开始到以给定的日期和时间为结束间的秒数

用法：

datetime_to_gregorian_seconds(DateTime) -> Seconds
内部实现：

%% datetime_to_gregorian_seconds(DateTime) = Integer
%%
%% Computes the total number of seconds starting from year 0,
%% January 1st.
%%
-spec datetime_to_gregorian_seconds(DateTime) -> Seconds when
      DateTime :: datetime(),
      Seconds :: non_neg_integer().
datetime_to_gregorian_seconds({Date, Time}) ->
    ?SECONDS_PER_DAY*date_to_gregorian_days(Date) +
	time_to_seconds(Time).
计算从公历 0 年开始到以给定的日期和时间为结束间的秒数。

calendar:datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}}).
calendar:datetime_to_gregorian_seconds({{2014, 7, 10}, {20, 22, 31}}).

----------
calendar:day_of_the_week/1
计算某天是星期几

用法：

day_of_the_week(Date) -> daynum()
内部实现：

%% day_of_the_week(Year, Month, Day)
%% day_of_the_week({Year, Month, Day})
%%
%% Returns: 1 | .. | 7. Monday = 1, Tuesday = 2, ..., Sunday = 7.
%%
-spec day_of_the_week(Year, Month, Day) -> daynum() when
      Year :: year(),
      Month :: month(),
      Day :: day().
day_of_the_week(Year, Month, Day) ->
    (date_to_gregorian_days(Year, Month, Day) + 5) rem 7 + 1.

-spec day_of_the_week(Date) -> daynum() when
      Date:: date().
day_of_the_week({Year, Month, Day}) ->
    day_of_the_week(Year, Month, Day).
这个函数计算给出的 Year 年 Month 月 Day 日是星期几，返回的值表示星期的天数，例如 1 表示星期天、2表示星期一、...7表示星期六等等。

calendar:day_of_the_week({2003, 10, 15}).

----------
calendar:day_of_the_week/3
计算某年某月某日是星期几

用法：

day_of_the_week(Year, Month, Day) -> daynum()
内部实现：

%% day_of_the_week(Year, Month, Day)
%% day_of_the_week({Year, Month, Day})
%%
%% Returns: 1 | .. | 7. Monday = 1, Tuesday = 2, ..., Sunday = 7.
%%
-spec day_of_the_week(Year, Month, Day) -> daynum() when
      Year :: year(),
      Month :: month(),
      Day :: day().
day_of_the_week(Year, Month, Day) ->
    (date_to_gregorian_days(Year, Month, Day) + 5) rem 7 + 1.
这个函数计算给出的 Year 年 Month 月 Day 日是星期几，返回的值表示星期的天数，例如 1 表示星期天、2表示星期一、...7表示星期六等等。

calendar:day_of_the_week(2003, 10, 15).

----------
calendar:gregorian_days_to_date/1
把天数转换为日期

用法：

gregorian_days_to_date(Days) -> date()
内部实现：

%% gregorian_days_to_date(Days) = {Year, Month, Day}
%%
-spec gregorian_days_to_date(Days) -> date() when
      Days :: non_neg_integer().
gregorian_days_to_date(Days) ->
    {Year, DayOfYear} = day_to_year(Days),
    {Month, DayOfMonth} = year_day_to_date(Year, DayOfYear),
    {Year, Month, DayOfMonth}.
把给出的天数 Days 转换为日期（从公元 0 年开始计算）。

calendar:gregorian_days_to_date(1000).

----------
calendar:gregorian_seconds_to_datetime/1
从给定的公历秒数里计算出日期和时间

用法：

gregorian_seconds_to_datetime(Seconds) -> datetime()
内部实现：

%% gregorian_seconds_to_datetime(Secs)
%%
-spec gregorian_seconds_to_datetime(Seconds) -> datetime() when
      Seconds :: non_neg_integer().
gregorian_seconds_to_datetime(Secs) when Secs >= 0 ->
    Days = Secs div ?SECONDS_PER_DAY,
    Rest = Secs rem ?SECONDS_PER_DAY,
    {gregorian_days_to_date(Days), seconds_to_time(Rest)}.
把给定的公历秒数 Seconds (从 1970-1-1 00:00:00 开始)转换成日期和时间。

StartTime = calendar:datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}}),
{MegaSecs, Secs, _MicroSecs} = erlang:now(),
Seconds = MegaSecs * 1000000 + Secs,
calendar:gregorian_seconds_to_datetime(Seconds + StartTime).
StartTime = calendar:datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}}),
calendar:gregorian_seconds_to_datetime(1 + StartTime).
StartTime = calendar:datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}}),
calendar:gregorian_seconds_to_datetime(1234567890 + StartTime).

----------
calendar:is_leap_year/1
判断一个年份是否是闰年

用法：

is_leap_year(Year) -> boolean()
内部实现：

%% is_leap_year(Year) = true | false
%%
-spec is_leap_year(Year) -> boolean() when
      Year :: year().
is_leap_year(Y) when is_integer(Y), Y >= 0 ->
    is_leap_year1(Y).

-spec is_leap_year1(year()) -> boolean().
is_leap_year1(Year) when Year rem 4 =:= 0, Year rem 100 > 0 ->
    true;
is_leap_year1(Year) when Year rem 400 =:= 0 ->
    true;
is_leap_year1(_) -> false.
这个函数检查一个年份是否为闰年。

calendar:is_leap_year(1996).
calendar:is_leap_year(2009).
{{Year, _Month, _Day}, {_Hour, _Minute, _Second}} = calendar:now_to_local_time(os:timestamp()),
calendar:is_leap_year(Year).

----------
calendar:iso_week_number/0
获取当前本地时间日期的周数

用法：

iso_week_number() -> yearweeknum()
内部实现：

%%
%% Calculates the iso week number for the current date.
%%
-spec iso_week_number() -> yearweeknum().
iso_week_number() ->
    {Date, _} = local_time(),
    iso_week_number(Date).


%%
%% Calculates the iso week number for the given date.
%%
-spec iso_week_number(Date) -> yearweeknum() when
      Date :: date().
iso_week_number({Year, Month, Day}) ->
    D = date_to_gregorian_days({Year, Month, Day}),
    W01_1_Year = gregorian_days_of_iso_w01_1(Year),
    W01_1_NextYear = gregorian_days_of_iso_w01_1(Year + 1),
    if W01_1_Year =
	    % Current Year Week 01..52(,53)
	    {Year, (D - W01_1_Year) div 7 + 1};
	D 
	    % Previous Year 52 or 53
	    PWN = case day_of_the_week(Year - 1, 1, 1) of
		4 -> 53;
		_ -> case day_of_the_week(Year - 1, 12, 31) of
			4 -> 53;
			_ -> 52
		     end
		end,
	    {Year - 1, PWN};
	W01_1_NextYear =
	    % Next Year, Week 01
	    {Year + 1, 1}
    end.
返回一个 {年, 周数} 格式的元组，其表示当前实际日期时间的年份和周数。实际日期时间的值是使用 calendar:local_time/0 来获取。

calendar:iso_week_number().

----------
calendar:iso_week_number/1
获取当前指定时间日期的周数

用法：

iso_week_number(Date) -> yearweeknum()
内部实现：

%%
%% Calculates the iso week number for the given date.
%%
-spec iso_week_number(Date) -> yearweeknum() when
      Date :: date().
iso_week_number({Year, Month, Day}) ->
    D = date_to_gregorian_days({Year, Month, Day}),
    W01_1_Year = gregorian_days_of_iso_w01_1(Year),
    W01_1_NextYear = gregorian_days_of_iso_w01_1(Year + 1),
    if W01_1_Year =
	    % Current Year Week 01..52(,53)
	    {Year, (D - W01_1_Year) div 7 + 1};
	D 
	    % Previous Year 52 or 53
	    PWN = case day_of_the_week(Year - 1, 1, 1) of
		4 -> 53;
		_ -> case day_of_the_week(Year - 1, 12, 31) of
			4 -> 53;
			_ -> 52
		     end
		end,
	    {Year - 1, PWN};
	W01_1_NextYear =
	    % Next Year, Week 01
	    {Year + 1, 1}
    end.
返回一个 {年, 周数} 格式的元组，其表示指定日期时间 Date 的年份和周数。

calendar:iso_week_number({2011, 11, 11}).
{Date, _Time} = calendar:local_time(),
calendar:iso_week_number(Date).

----------
calendar:last_day_of_the_month/2
计算在一个月中的天数

用法：

last_day_of_the_month(Year, Month) -> LastDay
内部实现：

%% last_day_of_the_month(Year, Month)
%%
%% Returns the number of days in a month.
%%
-spec last_day_of_the_month(Year, Month) -> LastDay when
      Year :: year(),
      Month :: month(),
      LastDay :: lDOM().
last_day_of_the_month(Y, M) when is_integer(Y), Y >= 0 ->
    last_day_of_the_month1(Y, M).

-spec last_day_of_the_month1(year(),month()) -> ldom().
last_day_of_the_month1(_, 4) -> 30;
last_day_of_the_month1(_, 6) -> 30;
last_day_of_the_month1(_, 9) -> 30;
last_day_of_the_month1(_,11) -> 30;
last_day_of_the_month1(Y, 2) ->
   case is_leap_year(Y) of
      true -> 29;
      _    -> 28
   end;
last_day_of_the_month1(_, M) when is_integer(M), M > 0, M 
    31.
这个函数返回在指定某个月中的该月天数。

Now = erlang:now(),
{{Year, Month, _Day}, _Time} = calendar:now_to_local_time(Now),
calendar:last_day_of_the_month(Year, Month).
Now = erlang:now(),
calendar:last_day_of_the_month(2014, 7).

----------
calendar:local_time/0
获取现在的当地日期和时间

用法：

local_time() -> datetime()
内部实现：

-spec local_time() -> datetime().
local_time() ->
    erlang:localtime().
这个函数返回底层操作系统的本地时间，其用法跟 erlang:localtime/0 一样。

calendar:local_time().

----------
calendar:local_time_to_universal_time/1
把本地时间转为 UTC 时间

用法：

local_time_to_universal_time(DateTime1) -> DateTime2
内部实现：

%% local_time_to_universal_time(DateTime)
%%
-spec local_time_to_universal_time(DateTime1) -> DateTime2 when
      DateTime1 :: datetime1970(),
      DateTime2 :: datetime1970().
local_time_to_universal_time(DateTime) ->
    erlang:localtime_to_universaltime(DateTime).
把本地时间转为 UTC（Universal Coordinated Time：国际标准时） 时间，参数 DateTime1 必须是 1970 年 1 月 1 日之后的本地数值。

calendar:local_time_to_universal_time({{2013, 11, 1}, {19, 45, 47}}).

----------
calendar:local_time_to_universal_time/2
把本地时间转为 UTC 时间

用法：

local_time_to_universal_time(datetime1970(), `true` | `false` | `undefined`) -> datetime1970()
内部实现：

-spec local_time_to_universal_time(datetime1970(),
				   'true' | 'false' | 'undefined') ->
                                          datetime1970().
local_time_to_universal_time(DateTime, IsDst) ->
    erlang:localtime_to_universaltime(DateTime, IsDst).
把本地时间转为 UTC（Universal Coordinated Time：国际标准时） 时间，参数 DateTime1 必须是 1970 年 1 月 1 日之后的本地数值。

如果 IsDst 为 true，那么 {Date1, Time1} 是在夏令时期间；如果 IsDst 为 false，则不在夏令时期间；如果 IsDst 为 undefined，那么底层操作系统将会判断是否是在夏令时期间，就像调用 erlang:localtime_to_universaltime({Date1, Time1}) 那样。

返回值可能有 0、1 或者是 2 个 UTC 时间：

[]：对于一个在切换至夏令时被跳过的本地时间，由于本地时间是一个非法数值（它还没有发生），所有它没有对应的 UTC 时间
[DstDateTimeUTC, DateTimeUTC]：对于一个在切换至夏令时被重复的本地时间，它有两个对应的 UTC 时间，一个是还在夏令时期间的第一个实例，一个是第二个实例。
[DateTimeUTC]：所有的本地时间只有一个对应的 UTC 时间。
calendar:local_time_to_universal_time({{2013, 11, 1}, {20, 17, 18}}, undefined).

----------
calendar:local_time_to_universal_time_dst/1
把本地时间转换为世界标准时

用法：

local_time_to_universal_time_dst(DateTime1) -> [DateTime]
内部实现：

-spec local_time_to_universal_time_dst(DateTime1) -> [DateTime] when
      DateTime1 :: datetime1970(),
      DateTime :: datetime1970().
local_time_to_universal_time_dst(DateTime) ->
    UtDst = erlang:localtime_to_universaltime(DateTime, true),
    Ut    = erlang:localtime_to_universaltime(DateTime, false),
    %% Reverse check the universal times
    LtDst = erlang:universaltime_to_localtime(UtDst),
    Lt    = erlang:universaltime_to_localtime(Ut),
    %% Return the valid universal times
    case {LtDst,Lt} of
	{DateTime,DateTime} when UtDst =/= Ut ->
	    [UtDst,Ut];
	{DateTime,_} ->
	    [UtDst];
	{_,DateTime} ->
	    [Ut];
	{_,_} ->
	    []
    end.
这个函数把本地时间 DateTime1 转为一个世界标准时间（UTC，Universal Coordinated Time ）。DateTime1 必须是一个1970年1月1日之后的本地时间。

返回值有以下几种结果：

[]：当切换到夏令时的期间里，本地时间 {Date1, Time1} 会被跳过，因为没有对应的 UTC 时间，本地时间是一个非法的时间（它不会发生）
[DstDateTimeUTC, DateTimeUTC]：当从夏令时切换的期间里，本地时间 {Date1, Time1} 会重复出现，英文有 2 个对应的 UTC 时间，一个是第一个夏令时仍处于活动状态的时候，另外一个是第一个夏令时仍处于活动状态的时候。
[DateTimeUTC]：所有的本地时间只有一个对应的 UTC 时间。
calendar:local_time_to_universal_time_dst({{2014, 7, 17}, {17, 38, 12}}).

----------
calendar:now_to_datetime/1
把当前世界转为世界通用世界（UTC）

用法：

now_to_datetime(Now) -> datetime1970()
内部实现：

%% now_to_universal_time(Now)
%% now_to_datetime(Now)
%%
%% Convert from now() to UTC.
%%
%% Args: Now = now(); now() = {MegaSec, Sec, MilliSec}, MegaSec = Sec
%% = MilliSec = integer() 
%% Returns: {date(), time()}, date() = {Y, M, D}, time() = {H, M, S}.
%% 
-spec now_to_datetime(Now) -> datetime1970() when
      Now :: erlang:timestamp().
now_to_datetime({MSec, Sec, _uSec}) ->
    Sec0 = MSec*1000000 + Sec + ?DAYS_FROM_0_TO_1970*?SECONDS_PER_DAY,
    gregorian_seconds_to_datetime(Sec0).
这个函数跟 calendar:now_to_universal_time/1 一样，都是把从 erlang:now/0 返回的值转换为世界通用世界（UTC）。

 calendar:now_to_datetime(erlang:now()).
 calendar:now_to_datetime(os:timestamp()).

----------
calendar:now_to_local_time/1
把当前时间转换为本地日期时间

用法：

now_to_local_time(Now) -> {{year,month,day},{hour,minute,second}}
内部实现：

-spec now_to_local_time(Now) -> datetime1970() when
      Now :: erlang:timestamp().
now_to_local_time({MSec, Sec, _uSec}) ->
    erlang:universaltime_to_localtime(
      now_to_universal_time({MSec, Sec, _uSec})).
这个函数是将当前时间 Now 转换为本地的日期和时间

calendar:now_to_local_time(os:timestamp()).

----------
calendar:now_to_universal_time/1
把当前世界转为世界通用世界（UTC）

用法：

now_to_universal_time(Now) -> datetime1970()
内部实现：

%% now_to_universal_time(Now)
%% now_to_datetime(Now)
%%
%% Convert from now() to UTC.
%%
%% Args: Now = now(); now() = {MegaSec, Sec, MilliSec}, MegaSec = Sec
%% = MilliSec = integer() 
%% Returns: {date(), time()}, date() = {Y, M, D}, time() = {H, M, S}.
%% 
-spec now_to_datetime(Now) -> datetime1970() when
      Now :: erlang:timestamp().
now_to_datetime({MSec, Sec, _uSec}) ->
    Sec0 = MSec*1000000 + Sec + ?DAYS_FROM_0_TO_1970*?SECONDS_PER_DAY,
    gregorian_seconds_to_datetime(Sec0).

-spec now_to_universal_time(Now) -> datetime1970() when
      Now :: erlang:timestamp().
now_to_universal_time(Now) ->
    now_to_datetime(Now).
这个函数跟 calendar:now_to_datetime/1 一样，都是把从 erlang:now/0 返回的值转换为世界通用世界（UTC）。

calendar:now_to_universal_time(erlang:now()).
calendar:now_to_universal_time(os:timestamp()).

----------
calendar:seconds_to_daystime/1
把秒数转为天数和时间

用法：

seconds_to_daystime(Seconds) -> {Days, Time}
内部实现：

-spec seconds_to_daystime(Seconds) -> {Days, Time} when
      Seconds :: integer(),
      Days :: integer(),
      Time :: time().
seconds_to_daystime(Secs) ->
    Days0 = Secs div ?SECONDS_PER_DAY,
    Secs0 = Secs rem ?SECONDS_PER_DAY,
    if 
	Secs0 
	    {Days0 - 1, seconds_to_time(Secs0 + ?SECONDS_PER_DAY)};
	true ->
	    {Days0, seconds_to_time(Secs0)}
    end.
这个函数把给出的时间秒数 Seconds 转为天（days），时（hours），分（minutes），秒（seconds）。

{Total_Wallclock_Time, _Wallclock_Time_Since_Last_Call} = erlang:statistics(wall_clock),
{D, {H, M, S}} = calendar:seconds_to_daystime(Total_Wallclock_Time div 1000),
lists:flatten(io_lib:format("~p days, ~p hours, ~p minutes and ~p seconds", [D, H, M, S])).
Time 里的值总是一个非负数，如果参数 Seconds 是一个负数，那么 Days 也是一个负数。

calendar:seconds_to_daystime(-123).

----------
calendar:seconds_to_time/1
把秒数转为时间

用法：

seconds_to_time(Seconds) -> time()
内部实现：

-type secs_per_day() :: 0..?SECONDS_PER_DAY.
-spec seconds_to_time(Seconds) -> time() when
      Seconds :: secs_per_day().
seconds_to_time(Secs) when Secs >= 0, Secs 
    Secs0 = Secs rem ?SECONDS_PER_DAY,
    Hour = Secs0 div ?SECONDS_PER_HOUR,
    Secs1 = Secs0 rem ?SECONDS_PER_HOUR,
    Minute =  Secs1 div ?SECONDS_PER_MINUTE,
    Second =  Secs1 rem ?SECONDS_PER_MINUTE,
    {Hour, Minute, Second}.
这个函数把给出的秒数 Seconds 转为时间。

calendar:seconds_to_time(12345).
参数 Seconds 必须小于一天的秒数（86400）。

calendar:seconds_to_time(123456).

----------
calendar:time_difference/2
比较计算两个时间的差值

用法：

time_difference(T1, T2) -> {Days, Time}
内部实现：

-spec time_difference(T1, T2) -> {Days, Time} when
      T1 :: datetime(),
      T2 :: datetime(),
      Days :: integer(),
      Time :: time().
time_difference({{Y1, Mo1, D1}, {H1, Mi1, S1}}, 
		{{Y2, Mo2, D2}, {H2, Mi2, S2}}) ->
    Secs = datetime_to_gregorian_seconds({{Y2, Mo2, D2}, {H2, Mi2, S2}}) -
	datetime_to_gregorian_seconds({{Y1, Mo1, D1}, {H1, Mi1, S1}}),
    seconds_to_daystime(Secs).
这个函数返回两个格式为 {Date, Time} 的元组时间差值。T2 是一个晚于 T1 的新纪元时间。

calendar:time_difference({{2013, 11, 15}, {17, 59, 33}}, {{2013, 11, 19}, {11, 23, 49}}).

----------
calendar:time_to_seconds/1
返回从午夜以来到指定时间之间的秒数

用法：

time_to_seconds(Time) -> secs_per_day()
返回从午夜 0 点以来到指定时间之间的秒数。

Now = erlang:now(),
{_Date, Time} = calendar:now_to_local_time(Now),
calendar:time_to_seconds(Time).
calendar:time_to_seconds({19, 7, 42}).

----------
calendar:universal_time/0
获取当前的世界标准时间

用法：

universal_time() -> datetime().
内部实现：

%% universal_time()
%%
%% Returns: {date(), time()}, date() = {Y, M, D}, time() = {H, M, S}.
-spec universal_time() -> datetime().
universal_time() ->
    erlang:universaltime().
这个函数返回当前底层操作系统的世界标准世界（UTC，Universal Coordinated Time）。如果世界标准时间获取不到，则返回本地时间。

calendar:universal_time().

----------
calendar:universal_time_to_local_time/1
把世界标准时间（UTC）转为本地时间

用法：

universal_time_to_local_time(DateTime) -> datetime()
内部实现：

%% universal_time_to_local_time(DateTime)
%%
-spec universal_time_to_local_time(DateTime) -> datetime() when
      DateTime :: datetime1970().
universal_time_to_local_time(DateTime) ->
    erlang:universaltime_to_localtime(DateTime).
把世界标准时（UTC）的日期时间转为本地的日期时间。由其实现可知，其效用跟 erlang:universaltime_to_localtime/1 一样。

calendar:universal_time_to_local_time({{2014, 7, 10}, {20, 29, 12}}).
calendar:universal_time_to_local_time({{1996, 11, 6}, {14, 18, 43}}).

----------
calendar:valid_date/1
检测一个日期时间是否有效

用法：

valid_date(Date) -> boolean()
内部实现：

%% valid_date(Year, Month, Day) = true | false
%% valid_date({Year, Month, Day}) = true | false
%%
-spec valid_date(Year, Month, Day) -> boolean() when
      Year :: integer(),
      Month :: integer(),
      Day :: integer().
valid_date(Y, M, D) when is_integer(Y), is_integer(M), is_integer(D) ->
    valid_date1(Y, M, D).

-spec valid_date1(integer(), integer(), integer()) -> boolean().
valid_date1(Y, M, D) when Y >= 0, M > 0, M  0 ->
    D =
    false.

-spec valid_date(Date) -> boolean() when
      Date :: date().
valid_date({Y, M, D}) ->
    valid_date(Y, M, D).
检测一个日期时间是否有效。

{Date, _Time} = calendar:local_time(),
calendar:valid_date(Date).
calendar:valid_date({2014, 7, 10}).
calendar:valid_date({2014, 13, 10}).

----------
calendar:valid_date/3
检测一个日期时间是否有效

用法：

valid_date(Year, Month, Day) -> boolean()
内部实现：

%% valid_date(Year, Month, Day) = true | false
%%
-spec valid_date(Year, Month, Day) -> boolean() when
      Year :: integer(),
      Month :: integer(),
      Day :: integer().
valid_date(Y, M, D) when is_integer(Y), is_integer(M), is_integer(D) ->
    valid_date1(Y, M, D).

-spec valid_date1(integer(), integer(), integer()) -> boolean().
valid_date1(Y, M, D) when Y >= 0, M > 0, M  0 ->
    D =
    false.
检测一个日期时间是否有效

calendar:valid_date(2014, 7, 10).
calendar:valid_date(2014, 13, 10).