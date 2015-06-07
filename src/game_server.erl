-module(game_server).
-behaviour(gen_server).

%% что можно вызывать напрямую
-export([start/0]).

%% интерфейс gen_server'а
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% запуск сервера

start() ->
	start_link().

start_link() ->
	gen_server:start_link({global, game_server}, ?MODULE, [], []).

init([]) ->
	{ ok, game_logic:start_game() }.

%% обработчики вызовов.
%% _call требуют ответ: возвращают {reply, Response, NewState}
%% _case не требуют: возвращают {noreply, Response}

handle_call( {who_plays} , _, State) ->
	{ reply, game_logic:who_plays(State),	State	};

handle_call( {who_won} , _, State) ->
	{reply, game_logic:who_won(State), State};

handle_call( {get_last_cells, X, Y}, _, State) ->
	{reply, game_logic:get_last_cells(State), State};

handle_call( {get_field}, _, State) ->
	{reply, game_logic:get_field(State), State};

handle_call( {make_turn, Player, X, Y}, _, State) ->
	{Status, NewState} = game_logic:try_make_turn(Player, X, Y, State),
	{reply, Status, NewState};

handle_call( {join}, _, State) ->
	{NewUserId, NewState} = game_logic:join_game(State),
	{reply, NewUserId, NewState}.

handle_cast( {reset}, _ ) ->
	{noreply, game_logic:start_game()};

handle_cast( {leave, Name}, State) ->
	{noreply, game_logic:leave_game(Name, State)}.

handle_info( _, State) ->
	1.

terminate( _, State) ->
	2.

code_change( _, _, _) ->
	3.