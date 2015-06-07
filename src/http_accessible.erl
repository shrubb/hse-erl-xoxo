-module(http_accessible).

%% как обращаться к нашему серверу
-define(LINK_TO_CALL, {global, game_server}).

%% функции отсюда вызываются, если зайти по адресу
%% http://localhost:8090/api/http_accessible/имя_функции/аргумент_1/.../аргумент_N

%% а именно -- вот эти функции:
-export([
  who_plays/3,
  who_won/3,
  reset/3
]).

%% в сигнатурах этих функций последний аргумент (In) --
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