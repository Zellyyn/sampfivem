enum PlayerData // We'll create a new enum to store player's information(data)
{
	ID,
	Password[129],
	Cash,
	Kills,
	Deaths
};
new PlayerInfo[MAX_PLAYERS][PlayerData];