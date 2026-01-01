# QB-Banking - Time-Based Door Locking System

A QBCore banking script with automatic time-based door locking functionality. Bank doors automatically lock and unlock based on configured business hours using in-game time.

## Features

- 💰 Full banking system with account management
- 🚪 **Automatic door locking based on in-game time**
- 🔔 **Proximity notifications when approaching locked doors**
- ⏰ **Configurable banking hours (supports normal and overnight hours)**
- 🔄 **Real-time synchronization with qb-weathersync**
- 🛠️ **Admin commands for testing and management**
- 📊 Multiple account support (checking, shared, job, gang accounts)
- 💳 Bank card system with PIN protection
- 📝 Transaction statements and history
- 🏦 ATM and bank card integration
- 👥 Shared accounts between players
- 🏢 Auto creation of job/gang accounts on bank first open
- 👔 Boss-only access to job/gang accounts

Documentation: https://docs.qbcore.org/qbcore-documentation/qbcore-resources/qb-banking

## Dependencies

- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-doorlock](https://github.com/qbcore-framework/qb-doorlock) - **Required for door management**
- [qb-weathersync](https://github.com/qbcore-framework/qb-weathersync) - **Required for time synchronization**
- [qb-inventory](https://github.com/qbcore-framework/qb-inventory)
- [qb-input](https://github.com/qbcore-framework/qb-input)
- [oxmysql](https://github.com/overextended/oxmysql)
- [PolyZone](https://github.com/mkafrin/PolyZone) (if not using qb-target)

## Installation

### 1. Install the Resource

1. Download and extract `qb-banking` into your `resources/[qb]/` folder
2. Ensure the resource is started in your `server.cfg`:
```cfg
ensure qb-banking
```

### 2. Database Setup

Run the `banking.sql` file in your database to create the required tables.

### 3. Configure Door Locking System

#### Step 3.1: Add Export to qb-doorlock

**IMPORTANT:** Add the following export function to the end of `qb-doorlock/server/main.lua` (after the commands section, around line 326):

```lua
-- Exports

exports('SetDoorLocked', function(doorID, locked)
	if not Config.DoorList[doorID] then
		print(('[qb-doorlock] ERROR: Door ID "%s" not found in Config.DoorList'):format(doorID))
		return false
	end

	Config.DoorList[doorID].locked = locked
	if Config.DoorStates[doorID] == nil then
		Config.DoorStates[doorID] = locked
	elseif Config.DoorStates[doorID] ~= locked then
		Config.DoorStates[doorID] = nil
	end

	TriggerClientEvent('qb-doorlock:client:setState', -1, -1, doorID, locked, false, true, false)
	print(('[qb-doorlock] Door "%s" set to locked: %s'):format(doorID, tostring(locked)))
	return true
end)
```

#### Step 3.2: Create Bank Door Configuration

Create a new file `qb-doorlock/configs/bankdoors.lua` with your bank door configurations:

```lua
-- Pacific Standard Bank - Legion Square
Config.DoorList['bank_door_1'] = {
    objName = 'hei_prop_hei_bankdoor_new',
    objCoords = vector3(232.61, 214.16, 106.4),
    objYaw = 115.2,
    locked = true,
    doorType = 'door',
    distance = 2.0,
    doorLabel = 'Bank Door',
    fixText = false,
}

Config.DoorList['bank_door_2'] = {
    objName = 'hei_prop_hei_bankdoor_new',
    objCoords = vector3(231.51, 216.52, 106.4),
    objYaw = 295.34,
    locked = true,
    doorType = 'door',
    distance = 2.0,
    doorLabel = 'Bank Door',
    fixText = false,
}
```

**Note:** The door IDs (`bank_door_1`, `bank_door_2`) must match the IDs in your `qb-banking/config.lua`.

#### Step 3.3: Find Door Coordinates (Optional)

If you need to find door coordinates for other bank locations:

1. Stand near the door in-game
2. Use the command `/newdoor` (requires admin permission)
3. Follow the prompts to get the door object name and coordinates
4. Add the door configuration to `qb-doorlock/configs/bankdoors.lua`

### 4. Configure qb-banking

Edit `qb-banking/config.lua` to customize your settings:

```lua
Config = {
    -- Door locking system configuration
    doorlock = 'qb-doorlock',

    -- Banking hours (24-hour format)
    doorHours = {
        open = 9,   -- 9 AM
        close = 17  -- 5 PM (17:00)
    },

    -- Door configuration - must match qb-doorlock door IDs
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

    -- Notification settings
    notice = 'Banks are open from 9 AM to 5 PM. Please plan your transactions accordingly.',
    notifyCooldown = 30000, -- Time between notifications (milliseconds)
}
```

### 5. Restart Resources

```
restart qb-doorlock
restart qb-banking
```

## Configuration Options

### Banking Hours

The system supports both normal and overnight hours:

**Normal Hours (9 AM - 5 PM):**
```lua
doorHours = {
    open = 9,
    close = 17
}
```

**Overnight Hours (10 PM - 6 AM):**
```lua
doorHours = {
    open = 22,  -- 10 PM
    close = 6   -- 6 AM
}
```

### Adding More Bank Doors

To add additional bank locations:

1. **Add to qb-doorlock config** (`qb-doorlock/configs/bankdoors.lua`):
```lua
Config.DoorList['bank_door_paleto'] = {
    objName = 'door_model_here',
    objCoords = vector3(x, y, z),
    objYaw = heading,
    locked = true,
    doorType = 'door',
    distance = 2.0,
    doorLabel = 'Paleto Bank Door',
    fixText = false,
}
```

2. **Add to qb-banking config** (`qb-banking/config.lua`):
```lua
lockedDoors = {
    ['bank_door_1'] = {
        coords = vector3(232.61, 214.16, 106.4),
        notifyDistance = 2.0
    },
    ['bank_door_paleto'] = {
        coords = vector3(x, y, z),
        notifyDistance = 2.0
    }
}
```

## Admin Commands

### `/bankdoorstatus`
Check the current door locking status and banking hours.

**Example Output:**
```
Current Time: 12:00 | Doors Should Be: UNLOCKED
Bank Hours: 9:00 AM - 17:00 PM
```

### `/bankdoortoggle [doorid]`
Manually toggle a specific door's lock state (for testing).

**Usage:**
```
/bankdoortoggle bank_door_1
```

## How It Works

### Time Synchronization

1. **Server-side**: The script checks in-game time every minute using qb-weathersync
2. **Automatic Locking**: Doors automatically lock at closing time and unlock at opening time
3. **Real-time Updates**: All clients are notified immediately when door states change

### Door Lock Logic

```lua
-- Doors lock when:
hour < openHour OR hour >= closeHour

-- Example with 9 AM - 5 PM hours:
-- Locked: 0-8 (midnight to 8:59 AM) and 17-23 (5 PM to 11:59 PM)
-- Unlocked: 9-16 (9 AM to 4:59 PM)
```

### Proximity Notifications

- Players receive a notification when approaching locked doors
- Notifications only appear during closed hours
- 30-second cooldown prevents spam
- Separate cooldown per door

## Debugging

### Console Output

The script provides detailed debug information in the server console:

```
[qb-banking] Initializing door locking system...
[qb-banking] DEBUG: Using qb-weathersync time: 12:00
[qb-banking] DEBUG: Normal hours logic - Hour: 12, Open: 9, Close: 17, Should Lock: false
[qb-banking] Successfully updated door "bank_door_1" to locked: false
[qb-doorlock] Door "bank_door_1" set to locked: false
```

### Common Issues

**Issue:** Doors are always locked
- **Solution:** Check that qb-weathersync is running and the in-game time is within banking hours
- **Test:** Use `/time 12 0` to set time to noon, then check `/bankdoorstatus`

**Issue:** Doors don't lock/unlock
- **Solution:** Verify door IDs match between qb-banking and qb-doorlock configs
- **Solution:** Ensure the qb-doorlock export was added correctly (Step 3.1)
- **Test:** Use `/bankdoortoggle bank_door_1` to manually test

**Issue:** No notifications near doors
- **Solution:** Check that door coordinates in qb-banking config match actual door locations
- **Solution:** Increase `notifyDistance` in config if needed

**Issue:** Server console shows "qb-doorlock is not running"
- **Solution:** Ensure qb-doorlock is started before qb-banking in server.cfg

## Testing

1. Set time to within banking hours: `/time 12 0` (noon)
   - Doors should unlock
   - No notification when approaching doors

2. Set time outside banking hours: `/time 18 0` (6 PM)
   - Doors should lock
   - Notification appears when approaching doors

3. Check status: `/bankdoorstatus`
   - Shows current time and lock status

## Credits

- Original qb-banking by Kakarot/QBCore Framework
- Time-based door locking system enhancement
- Built for QBCore Framework

## Support

For issues and feature requests, please create an issue on GitHub.

# License

    QBCore Framework
    Copyright (C) 2021 Joshua Eger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>
