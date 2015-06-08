-module(game_logic).

-export([
  blank_state/0,
  who_plays/1,
  who_won/1,
  join_game/2,
  get_field/1,
  leave_game/2,
  try_make_turn/4
]).

-include("records.hrl").

%% игровая логика.
%% функции здесь в основном возвращают либо Result (результат запроса),
%% либо, если они меняют состояние игры, то {Result, NewState}

blank_state() ->
  #game_state{cells=[], online_users=sets:new(), winner=?NOBODY}.

%% возвращает список игроков онлайн
%% пример: ["rialexandrov", "shrubb"]
who_plays(State) ->
  aux_functions:strings_to_JSON(
    sets:to_list(State#game_state.online_users)
  ).

%% возвращает победителя либо -666
%% пример: 97
who_won(State) ->
  State#game_state.winner.

%% возвращает занятые поля
%% формат: смотри aux_functions:cells_to_JSON
get_field(State) ->
  aux_functions:cells_to_JSON(State#game_state.cells).

try_make_turn(X, Y, PlayerName, State) ->
  io:format("~p ~p ~s~n", [X, Y, PlayerName]),
  case aux_functions:find_cell(State#game_state.cells, X, Y) of
    false ->
      {"{\"status\": \"ok\"}",
        #game_state{
          cells = lists:append(
            State#game_state.cells,
            [#cell{x = X, y = Y, player = PlayerName}]
          ),
          online_users = State#game_state.online_users,
          winner = State#game_state.winner
        }
      };
    true ->
      {"{\"status\": \"error\"}", State}
  end.

%% увеличивает счётчик игроков, возвращает {ИмяНовогоИгрока, NewState}
join_game(Name, State) ->
  %io:format("~s~n", [State#game_state.winner]),
  #game_state{
    cells = State#game_state.cells,
    online_users = sets:add_element(Name, State#game_state.online_users),
    winner = State#game_state.winner
  }.

%% убрать заданного игрока из списка игроков.
%% возвращаем только NewState
leave_game(Name, State) ->
  #game_state{
    cells = State#game_state.cells,
    online_users = sets:del_element(State#game_state.online_users, Name),
    winner = State#game_state.winner}.