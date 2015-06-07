-module(game_logic).

-export([
  blank_state/0,
  who_plays/1,
  who_won/1,
  join_game/1,
  get_last_cells/1,
  get_field/1,
  leave_game/2
]).

-include("records.hrl").

%% игровая логика.
%% функции здесь в основном возвращают либо Result (результат запроса),
%% либо, если они меняют состояние игры, то {Result, NewState}

blank_state() ->
  #game_state{cells=sets:new(), online_users=sets:new(), next_online_user=$a, winner=?NOBODY}.

%% возвращает список игроков онлайн
%% пример: [97, 99, 102]
who_plays(State) ->
  aux_functions:numbers_to_JSON(
    sets:to_list(State#game_state.online_users)).

%% возвращает победителя либо -666
%% пример: 97
who_won(State) ->
  io_lib:format("~p", [State#game_state.winner]).

%% возвращает последние 10 поставленных клеток (или все, если их меньше 10)
get_last_cells(State) ->
  lists:sublist(State#game_state.cells, max(1, length(State#game_state.cells) - 10), 10).

%% TODO: Дописать
get_field(State) ->
  [].

%% TODO: Дописать
try_make_turn(X, Y, PlayerName, State) ->
  {ok, State}.

%% увеличивает счётчик игроков, возвращает {ИмяНовогоИгрока, NewState}
join_game(State) ->
  NewState = #game_state{
    cells = State#game_state.cells,
    online_users = sets:add_element(State#game_state.online_users, State#game_state.next_online_user),
    next_online_user = State#game_state.next_online_user + 1,
    winner = State#game_state.winner},
  {NewState#game_state.next_online_user - 1, NewState}.

%% убрать заданного игрока из списка игроков.
%% возвращаем только NewState
leave_game(Name, State) ->
  #game_state{
    cells = State#game_state.cells,
    online_users = sets:del_element(State#game_state.online_users, Name),
    next_online_user = State#game_state.next_online_user,
    winner = State#game_state.winner}.