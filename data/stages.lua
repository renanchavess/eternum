-- Minlevel and multiplier are MANDATORY
-- Maxlevel is OPTIONAL, but is considered infinite by default
-- Create a stage with minlevel 1 and no maxlevel to disable stages
experienceStages = {
	{
		minlevel = 1,
		maxlevel = 8,
		multiplier = 7,
	},
	{
		minlevel = 9,
		maxlevel = 20,
		multiplier = 6,
	},
	{
		minlevel = 21,
		maxlevel = 50,
		multiplier = 5,
	},
	{
		minlevel = 51,
		maxlevel = 100,
		multiplier = 4,
	},
	{
		minlevel = 101,
		multiplier = 2,
	},
}

experienceStages = {
	{ minlevel = 1, maxlevel = 9, multiplier = 50, },
    { minlevel = 10, maxlevel = 109, multiplier = 500, },
    { minlevel = 110, maxlevel = 209, multiplier = 475, },
    { minlevel = 210, maxlevel = 309, multiplier = 450, },
    { minlevel = 310, maxlevel = 409, multiplier = 425, },
    { minlevel = 410, maxlevel = 509, multiplier = 400, },
    { minlevel = 510, maxlevel = 609, multiplier = 375 },
    { minlevel = 610, maxlevel = 709, multiplier = 350 },
    { minlevel = 710, maxlevel = 809, multiplier = 325 },
    { minlevel = 810, maxlevel = 909, multiplier = 300 },
    { minlevel = 910, maxlevel = 1009, multiplier = 275 },
    { minlevel = 1010, maxlevel = 1109, multiplier = 250 },
    { minlevel = 1110, maxlevel = 1209, multiplier = 225 },
    { minlevel = 1210, maxlevel = 1309, multiplier = 200 },
    { minlevel = 1310, maxlevel = 1409, multiplier = 175 },
    { minlevel = 1410, maxlevel = 1509, multiplier = 150 },
    { minlevel = 1510, maxlevel = 1609, multiplier = 125 },
    { minlevel = 1610, maxlevel = 1709, multiplier = 100 },
    { minlevel = 1710, maxlevel = 1809, multiplier = 75 },
    { minlevel = 1810, maxlevel = 1909, multiplier = 50 },
    { minlevel = 1910, maxlevel = 1999, multiplier = 35 },
    { minlevel = 2000, multiplier = 25 },
}

skillsStages = {
	{
		minlevel = 10,
		maxlevel = 60,
		multiplier = 100,
	},
	{
		minlevel = 61,
		maxlevel = 80,
		multiplier = 80,
	},
	{
		minlevel = 81,
		maxlevel = 110,
		multiplier = 60,
	},
	{
		minlevel = 111,
		maxlevel = 125,
		multiplier = 40,
	},
	{
		minlevel = 126,
		multiplier = 20,
	},
	{
		minlevel = 150,
		multiplier = 10,
	},
}

magicLevelStages = {
	{
		minlevel = 0,
		maxlevel = 60,
		multiplier = 80,
	},
	{
		minlevel = 61,
		maxlevel = 80,
		multiplier = 60,
	},
	{
		minlevel = 81,
		maxlevel = 100,
		multiplier = 40,
	},
	{
		minlevel = 101,
		maxlevel = 110,
		multiplier = 30,
	},
	{
		minlevel = 111,
		maxlevel = 125,
		multiplier = 20,
	},
	{
		minlevel = 126,
		multiplier = 10,
	},
	{
		minlevel = 150,
		multiplier = 5,
	},
}
