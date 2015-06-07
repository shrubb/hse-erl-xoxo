-module(http_accessible).
-define(LINK_TO_CALL, {global, game_server}).

%% API
-export([
  who_plays/3
]).

who_plays(SessionId, _, In) ->
  % io:format("hello!~n"),
  mod_esi:deliver(
    SessionId,
    gen_server:call(?LINK_TO_CALL, {who_plays})
  ).