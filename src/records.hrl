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
  moves_next
}).

%% cells: занятые клетки на поле;
%% set из переменных типа cell

%% online_users: пользователи в игре;
%% set из их id (пока что числа)

%% moves_next: кто ходит следующий.
%% либо {next, Player}, либо {winner, Player}, если кто-то уже победил