-module(aux_functions).

-export([numbers_to_JSON/1, cells_to_JSON/1]).

-include("records.hrl").

%% 123 -> "123"
number_to_string(Number) ->
  lists:flatten(io_lib:format("~p", [Number])).

%% [57, 2, 11] -> "[57, 2, 11]"
numbers_to_JSON(Numbers) ->
  "[" ++
    string:join(
      lists:map(
        fun number_to_string/1,
        Numbers),
      ", ")
    ++ "]".

% cell#{2, 3, 97} -> {"x": 2, "y": 3, "user": 97}
cell_to_string(Cell) ->
  "{\"x\": " ++
  number_to_string(Cell#cell.x) ++
  ", \"y\": " ++
  number_to_string(Cell#cell.y) ++
  ", \"user\": " ++
  number_to_string(Cell#cell.player) ++
  "}".

%% вывод: [ {"x": 3, "y": 7, "user": 97}, ...,
%%          {"x": 2, "y": 1, "user": 101} ]
cells_to_JSON(Cells) ->
  "[" ++
    string:join(
      lists:map(
        fun cell_to_string/1,
        Cells),
      ", ")
    ++ "]".