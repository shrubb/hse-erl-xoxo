-module(aux_functions).

-export([number_to_string/1, numbers_to_list/1]).

number_to_string(Number) ->
  lists:flatten(io_lib:format("~p", [Number])).

numbers_to_list(Numbers) ->
  "[" ++
    string:join(
      lists:map(
        fun number_to_string/1,
        Numbers),
      ", ")
    ++ "]".