ranDOM:seed/0
用默认值产生随机数种子

用法：

seed() -> ran().
内部实现：

-spec seed0() -> ran().

seed0() ->
    {3172, 9814, 20125}.

-spec seed_put(ran()) -> 'undefined' | ran().
     
seed_put(Seed) ->
    put(random_seed, Seed).

-spec seed() -> ran().

seed() ->
    case seed_put(seed0()) of
	undefined -> seed0();
	{_,_,_} = Tuple -> Tuple
    end.	
使用进程字典里的默认(固定的)值作为随机数生成的种子, 并且返回随机种子状态.

random:seed().

----------
ranDOM:seed/1
用数字产生随机数种子

用法：

seed({A1, A2, A3}) -> undefined | ran() when
内部实现：

%% seed({A1, A2, A3}) 
%%  Seed random number generation 

-spec seed({A1, A2, A3}) -> 'undefined' | ran() when
      A1 :: integer(),
      A2 :: integer(),
      A3 :: integer().

seed({A1, A2, A3}) ->
    seed(A1, A2, A3).

%% seed(A1, A2, A3) 
%%  Seed random number generation 

-spec seed(A1, A2, A3) -> 'undefined' | ran() when
      A1 :: integer(),
      A2 :: integer(),
      A3 :: integer().

seed(A1, A2, A3) ->
    seed_put({(abs(A1) rem (?PRIME1-1)) + 1,   % Avoid seed numbers that are
	      (abs(A2) rem (?PRIME2-1)) + 1,   % even divisors of the
	      (abs(A3) rem (?PRIME3-1)) + 1}). % corresponding primes.


-spec seed_put(ran()) -> 'undefined' | ran().
     
seed_put(Seed) ->
    put(random_seed, Seed).
用数字产生随机数种子

{MegaSecs, Secs, MicroSecs} = erlang:now(),
random:seed({MegaSecs, Secs, MicroSecs}).

----------
ranDOM:seed/3
用数字产生随机数种子

用法：

seed(A1, A2, A3) -> undefined | ran()
内部实现：

%% seed(A1, A2, A3) 
%%  Seed random number generation 

-spec seed(A1, A2, A3) -> 'undefined' | ran() when
      A1 :: integer(),
      A2 :: integer(),
      A3 :: integer().

seed(A1, A2, A3) ->
    seed_put({(abs(A1) rem (?PRIME1-1)) + 1,   % Avoid seed numbers that are
	      (abs(A2) rem (?PRIME2-1)) + 1,   % even divisors of the
	      (abs(A3) rem (?PRIME3-1)) + 1}). % corresponding primes.


-spec seed_put(ran()) -> 'undefined' | ran().
     
seed_put(Seed) ->
    put(random_seed, Seed).
用数字产生随机数种子

{MegaSecs, Secs, MicroSecs} = erlang:now(),
random:seed(MegaSecs, Secs, MicroSecs).

----------
ranDOM:seed0/0
返回默认的随机种子状态

用法：

seed0() -> ran()
内部实现：

-spec seed0() -> ran().

seed0() ->
    {3172, 9814, 20125}.
返回默认的随机种子状态

random:seed0().

----------
ranDOM:uniform/0
返回一个随机浮点数

用法：

uniform() -> float()
内部实现：

%% uniform()
%%  Returns a random float between 0 and 1.

-spec uniform() -> float().

uniform() ->
    {A1, A2, A3} = case get(random_seed) of
		       undefined -> seed0();
		       Tuple -> Tuple
		   end,
    B1 = (A1*171) rem ?PRIME1,
    B2 = (A2*172) rem ?PRIME2,
    B3 = (A3*170) rem ?PRIME3,
    put(random_seed, {B1,B2,B3}),
    R = B1/?PRIME1 + B2/?PRIME2 + B3/?PRIME3,
    R - trunc(R).
返回一个 0 到 1 的随机浮点数

random:uniform().

----------
ranDOM:uniform/1
返回一个随机整数

用法：

uniform(N) -> integer() >= 1
内部实现：

%% uniform(N) -> I
%%  Given an integer N >= 1, uniform(N) returns a random integer
%%  between 1 and N.

-spec uniform(N) -> pos_integer() when
      N :: pos_integer().

uniform(N) when is_integer(N), N >= 1 ->
    trunc(uniform() * N) + 1.
返回一个 1 至 N 的随机整数，N 是大于等于 1 的正整数

random:uniform(5).

----------
ranDOM:uniform_s/1
返回一个随机浮点数

用法：

uniform_s(State0) -> {float(), State1}
内部实现：

%% uniform_s(State) -> {F, NewState}
%%  Returns a random float between 0 and 1.

-spec uniform_s(State0) -> {float(), State1} when
      State0 :: ran(),
      State1 :: ran().

uniform_s({A1, A2, A3}) ->
    B1 = (A1*171) rem ?PRIME1,
    B2 = (A2*172) rem ?PRIME2,
    B3 = (A3*170) rem ?PRIME3,
    R = B1/?PRIME1 + B2/?PRIME2 + B3/?PRIME3,
    {R - trunc(R), {B1,B2,B3}}.
给定一个随机状态 State0, 并返回一个0.0 到 1.0 间的浮点数 float() 和一个新随机状态 State1.

{MegaSecs, Secs, MicroSecs} = erlang:now(),
State = {MegaSecs, Secs, MicroSecs},
random:uniform_s(State).

----------
ranDOM:uniform_s/2
返回一个随机整数

用法：

uniform_s(N, State0) -> {integer(), State1}
内部实现：

%% uniform_s(N, State) -> {I, NewState}
%%  Given an integer N >= 1, uniform(N) returns a random integer
%%  between 1 and N.

-spec uniform_s(N, State0) -> {integer(), State1} when
      N :: pos_integer(),
      State0 :: ran(),
      State1 :: ran().

uniform_s(N, State0) when is_integer(N), N >= 1 ->
    {F, State1} = uniform_s(State0),
    {trunc(F * N) + 1, State1}.
给定一个整数 N（N 是大于等于 1 的正整数）以及一个随机状态 State0, 并返回一个 1 到 N 间的整数和一个新的随机状态 State1.

{MegaSecs, Secs, MicroSecs} = erlang:now(),
State = {MegaSecs, Secs, MicroSecs},
random:uniform_s(5, State).

----------
