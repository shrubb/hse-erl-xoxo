%% клетка на поле
-record(cell, {
  x,
  y,
  player
}).

%% x, y: координаты
%% player: id того, кто занял клетку

%% состояние игры
-record(game_state, {
  cells,
  online_users,
  winner
}).

%% cells: занятые клетки на поле;
%% set из переменных типа cell

%% online_users: пользователи в игре;
%% set из их id (пока что числа)

%% next_online_user: какой id присвоим
%% следующему пользователю?

%% winner: id победителя либо NOBODY
-define(NOBODY, "\@nobody").