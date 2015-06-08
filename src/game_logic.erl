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
  #game_state{cells=[], online_users=[], moves_next = {next, 0}}.

%% возвращает список игроков онлайн
%% пример: ["rialexandrov", "shrubb"]
who_plays(State) ->
  aux_functions:strings_to_JSON(State#game_state.online_users).

%% возвращает победителя либо -666
%% пример: 97
who_won(State) ->
  State#game_state.moves_next.

%% возвращает занятые поля
%% формат: смотри aux_functions:cells_to_JSON
get_field(State) ->
  aux_functions:cells_to_JSON(State#game_state.cells).

%% попробовать сделать ход
%% вернёт {"status": STATUS},
%% где STATUS = ok/game_over/zanyato/not_your_turn

try_make_turn(X, Y, ResuestPlayerName, State) ->
  {StateType, NextPlayerNumber} = State#game_state.moves_next,
  case StateType of
    winner -> {"{\"status\": \"game_over\"}", State};
    true ->
      case lists:nth(NextPlayerNumber, State#game_state.online_users) of
        ResuestPlayerName ->
          case aux_functions:find_cell(State#game_state.cells, X, Y) of
            false ->
              {"{\"status\": \"ok\"}",
                #game_state{
                  cells = lists:append(
                    State#game_state.cells,
                    [#cell{x = X, y = Y, player = ResuestPlayerName}]
                  ),
                  moves_next =
                  State#game_state.moves_next rem
                    length(State#game_state.online_users) + 1
                }
              };
            true ->
              {"{\"status\": \"zanyato\"}", State}
          end;
        true -> {"{\"status\": \"not_your_turn\"}", State}
      end
  end.

%% увеличивает счётчик игроков, возвращает {СТАТУС, NewState}
%% где СТАТУС = '{"status": "ok"}' или '{"status": "error"}'
%% TODO написать через when
join_game(Name, State) ->
  case lists:member(Name, State#game_state.online_users) of
    false -> {
      "{\"status\": \"ok\"}",
      #game_state{
        cells = State#game_state.cells,
        online_users = lists:append(State#game_state.online_users, [Name]),
        moves_next = State#game_state.moves_next
      }
    };
    true -> {"{\"status\": \"error\"}", State}
  end.

%% убрать заданного игрока из списка игроков.
%% возвращаем только NewState
leave_game(Name, State) ->
  Index = aux_functions:index_of(Name, State#game_state.online_users),
  if
    Index > length(State) ->
      State;
    Index > State#game_state.moves_next ->
      #game_state{
        cells = State#game_state.cells,
        online_users = lists:delete(Name, State#game_state.online_users),
        moves_next = State#game_state.moves_next
      };
    true ->
      #game_state{
        cells = State#game_state.cells,
        online_users = lists:delete(Name, State#game_state.online_users),
        moves_next =
          State#game_state.moves_next rem
          length(State#game_state.online_users) + 1
      }
  end.