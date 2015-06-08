-module(game_server).
-behaviour(gen_server).

%% что можно вызывать напрямую
-export([start/0]).

%% интерфейс gen_server'а
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("records.hrl").

%% запуск сервера

start() ->
	start_link().

start_link() ->
	gen_server:start_link({global, game_server}, ?MODULE, [], []).

init([]) ->
	{ ok, game_logic:blank_state() }.

%% обработчики вызовов.
%% от handle_call требуется ответ: они возвращают {reply, Response, NewState}
%% от handle_cast не требуется: они возвращают {noreply, Response}

handle_call( {who_plays} , _, State) ->
	{reply, game_logic:who_plays(State), State};

handle_call( {who_won} , _, State) ->
	{reply, game_logic:who_won(State), State};

handle_call( {get_field}, _, State) ->
	{reply, game_logic:get_field(State), State};

handle_call( {try_make_turn, X, Y, Player}, _, State) ->
	{Status, NewState} = game_logic:try_make_turn(X, Y, Player, State),
	{reply, Status, NewState}.

handle_cast( {join_game, Name}, State) ->
	%io:format("~s ~s~n", [Name, State#game_state.winner]),
	{noreply, game_logic:join_game(Name, State)};

handle_cast( {reset}, _ ) ->
	{noreply, game_logic:blank_state()};

handle_cast( {leave, Name}, State) ->
	{noreply, game_logic:leave_game(Name, State)}.

handle_info( _, State ) ->
	{noreply, State}.

terminate( _, _ ) ->
	ok.

code_change( _, State, _) ->
	{ok, State}.