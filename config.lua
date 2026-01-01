Config = {
    useTarget = GetConvar('UseTarget', 'false') == 'true',
    atmModels = { 'prop_atm_01', 'prop_atm_02', 'prop_atm_03', 'prop_fleeca_atm' },
    useDailyLimit = true,
    dailyLimit = 5000,
    maxAccounts = 2,
    blipInfo = {
        name = 'Bank',
        sprite = 108,
        color = 2,
        scale = 0.55
    },
    locations = {
        vector3(149.05, -1041.3, 29.37),
        vector3(313.32, -280.03, 54.17),
        vector3(-351.94, -50.72, 49.04),
        vector3(-1212.68, -331.83, 37.78),
        vector3(-2961.67, 482.31, 15.7),
        vector3(1175.64, 2707.71, 38.09),
        vector3(247.65, 223.87, 106.29),
        vector3(-111.98, 6470.56, 31.63)
    },

    doorlock = 'qb-doorlock',

    doorHours = {
        open = 9,  -- 9 AM
        close = 17 -- 5 PM
    },

    -- Door IDs must match entries in qb-doorlock/configs/*.lua
    -- Each door needs ID, coordinates for proximity detection, and notification distance
    lockedDoors = {
        ['bank_door_1'] = {
            coords = vector3(232.61, 214.16, 106.4),
            notifyDistance = 2.0  -- Distance to show notification
        },
        ['bank_door_2'] = {
            coords = vector3(231.51, 216.52, 106.4),
            notifyDistance = 2.0
        }
    },

    notice = 'Banks are open from 9 AM to 5 PM. Please plan your transactions accordingly.',
    notifyCooldown = 30000, -- Cooldown between notifications in milliseconds (30 seconds)
}
