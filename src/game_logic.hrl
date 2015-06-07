%% состояние игры

-record(game_state, {
  cells,
  online_users,
  next_online_user,
  winner
}).