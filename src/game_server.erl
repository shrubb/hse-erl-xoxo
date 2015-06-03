-module(game_server).
-behaviour(gen_server).

%% что можно вызывать напрямую
-export([start/0]).

%% интерфейс gen_server'а
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start() ->
	start_link().

start_link() ->
	gen_server:start_link({global, game_server}, ?MODULE, [], []).

init([]) ->
	{ ok, start_game() }.

%% состояние игры

-record(game_state, {
	cells,
	online_users,
	next_online_user,
	winner
}).

handle_call( {who_plays} , _, State) ->
	{reply, who_plays(State), State};

handle_call( {who_won} , _, State) ->
	{reply, who_won(State), State};

handle_call( {get_last_cells, X, Y}, _, State) ->
	{reply, get_last_cells(X, Y, State), State};

handle_call( {get_field}, _, State) ->
	{reply, State#game_state.cells, State};

handle_call( {make_turn, Player, X, Y}, _, State) ->
	{Status, NewState} = try_make_turn(X, Y, Player, State),
	{reply, Status, NewState};

handle_call( {join}, _, State) ->
	{Status, NewUserSymbol, NewState} = join_game(State),
	{reply, {Status, NewUserSymbol}, NewState}.

handle_cast( {reset}, _ ) ->
	{noreply, start_game()};

handle_cast( {leave, Name}, State) ->
	{noreply, leave_game(Name, State)}.

handle_info( _, State) ->
	666.

terminate( _, State) ->
	666.

code_change( _, _, _) ->
	666.

%% игровая логика
%% TODO: написать все эти функции

start_game() ->
	#game_state{cells=[], online_users=sets:new(), next_online_user=$a, winner=nobody}.

who_plays(State) ->
	"reply".

who_won(State) ->
	State#game_state.winner.

get_last_cells(X, Y, State) ->
	666.

try_make_turn(X, Y, PlayerName, State) ->
	{ok, State}.

join_game(State) ->
	NewState = #game_state{
		cells = State#game_state.cells,
		online_users = sets:add_element(State#game_state.online_users, State#game_state.next_online_user),
		next_online_user = State#game_state.next_online_user + 1,
		winner = State#game_state.winner},
	{ok, NewState#game_state.next_online_user, NewState}.

leave_game(Name, State) ->
	#game_state{
		cells = State#game_state.cells,
		online_users = sets:del_element(State#game_state.online_users, Name),
		next_online_user = State#game_state.next_online_user,
		winner = State#game_state.winner}.
