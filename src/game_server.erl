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
	{ ok, #game_state{cells=sets:new(), online_users=sets:new(), next_online_user=$z, winner=nobody} }.

%% обработчики вызовов.
%% от handle_call требуется ответ: они возвращают {reply, Response, NewState}
%% от handle_cast не требуется: они возвращают {noreply, Response}

handle_call( {who_plays} , _, State) ->
	{reply, game_logic:who_plays(State), State};

handle_call( {who_won} , _, State) ->
	{reply, game_logic:who_won(State), State};

%% TODO: реализовать метод API
handle_call( {get_last_cells, X, Y}, _, State) ->
	{reply, game_logic:get_last_cells(State), State};

%% TODO: реализовать метод API
handle_call( {get_field}, _, State) ->
	{reply, game_logic:get_field(State), State};

%% TODO: реализовать метод API
handle_call( {make_turn, Player, X, Y}, _, State) ->
	{Status, NewState} = game_logic:try_make_turn(Player, X, Y, State),
	{reply, Status, NewState};

%% TODO: реализовать метод API
handle_call( {join}, _, State) ->
	{NewUserId, NewState} = game_logic:join_game(State),
	{reply, NewUserId, NewState}.

handle_cast( {reset}, _ ) ->
	{noreply, game_logic:blank_state()};

%% TODO: реализовать метод API
handle_cast( {leave, Name}, State) ->
	{noreply, game_logic:leave_game(Name, State)}.

handle_info( _, State ) ->
	{noreply, State}.

terminate( _, _ ) ->
	ok.

code_change( _, State, _) ->
	{ok, State}.