-module(http_accessible).

%% как обращаться к нашему серверу
-define(LINK_TO_CALL, {global, game_server}).

%% функции отсюда вызываются, если зайти по адресу
%% http://localhost:8090/api/http_accessible/имя_функции/аргумент_1/.../аргумент_N

%% а именно -- вот эти функции:
-export([
  who_plays/3,
  who_won/3,
  reset/3,
  join_game/3,
  get_field/3,
  leave_game/3,
  try_make_turn/3
]).

%% в сигнатурах этих функций последний аргумент (URL) --
%% это как раз строка "аргумент_1/.../аргумент_N"

who_plays(SessionId, _, _) ->
  mod_esi:deliver(
    SessionId,
    gen_server:call(?LINK_TO_CALL, {who_plays})
  ).

who_won(SessionId, _, _) ->
  mod_esi:deliver(
    SessionId,
    gen_server:call(?LINK_TO_CALL, {who_won})
  ).

reset(_, _, _) ->
  gen_server:cast(?LINK_TO_CALL, {reset}).

join_game(_, _, Name) ->
  gen_server:cast(?LINK_TO_CALL, {join_game, Name}).

get_field(SessionId, _, _) ->
  mod_esi:deliver(
    SessionId,
    gen_server:call(?LINK_TO_CALL, {get_field})
  ).

leave_game(_, _, Name) ->
  gen_server:cast(?LINK_TO_CALL, {leave_game, Name}).

try_make_turn(SessionId, _, URL) ->
  Args = string:tokens(http_uri:decode(URL), "/"),
  [X, Y] = lists:map(fun list_to_integer/1, [lists:nth(1, Args), lists:nth(2, Args)]),
  PlayerName = lists:nth(3, Args),
  mod_esi:deliver(
    SessionId,
    gen_server:call(?LINK_TO_CALL, {try_make_turn, X, Y, PlayerName})
  ).