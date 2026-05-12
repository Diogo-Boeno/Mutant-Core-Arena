return {
	MatchDuration = 20, --180
	MaxPlayersPerMatch = 8,

	EnemySpawnInterval = 3,
	MaxEnemiesAlive = function()
		local amount = #game:GetService('Players'):GetChildren()
		return (amount > 0 and amount or 1) * 20 -- 20 = BASE_MAX_ENEMIES
	end, -- f(MaxEnemiesAlive) f(2) = MaxEnemyAlives x2 = 40

	MutationOfferInterval = 5, -- 45
	MutationChoices = 3,

	BaseRewardCells = 50,
	CellsPerKill = 2,
	WinBonusCells = 75,
}