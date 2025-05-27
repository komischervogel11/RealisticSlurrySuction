🚜 Realistic Slurry Suction (FS25 Mod)
RealisticSlurrySuction is a realism-focused mod for Farming Simulator 25, designed to overhaul the slurry and digestate suction speeds of all default slurry tanks and those included in the Precision Farming DLC. The goal: to bring authentic pump behavior based on real-world manufacturer data.

📦 Features
✅ Adjusts slurry suction speeds for all base-game slurry tanks

✅ Supports Precision Farming DLC slurry equipment

✅ Customizable suction speeds for modded slurry tanks via XML

✅ Realistic pump speeds based on the manufacturer's technical specifications

✅ API for modders to define custom suction speeds per vehicle

✅ Lightweight, optimized, and multiplayer compatible (including dedicated servers)

🔧 How It Works
Each slurry tank’s suction rate is determined by one of the following:

Custom rates defined directly in the vehicle’s script (vehicle.realisticSlurryFillRate)

A predefined list of known slurry tank models with realistic suction speeds based on real-world data

A default fallback suction rate if no specific entry is found (currently set to 100 L/s)

The suction rates are converted to liters per millisecond (L/ms), as required by the Farming Simulator engine, for smoother gameplay and compatibility with the game's mechanics.

Example suction rates:
Farmtech Supercis 800 → 80 L/s

Annaburger AW 2227 → 100 L/s

Fliegl PFW18000 MaxxLinePlus → 100 L/s

Samson PG II 28 Genesis → 130 L/s

Kotte PQ32000 → 150 L/s

Wienhoff TA25 ProfiLine → 120 L/s

👨‍💻 API for Modders
Modders can define a custom suction rate for their vehicles by setting the realisticSlurryFillRate variable directly in their vehicle script. For example:

````
<vehicle>
......
vehicle.realisticSlurryFillRate = 120 -- 120 liters per second (L/s)
<vehicle>
````
This will override any default or preconfigured rate, allowing for full customization of slurry suction behavior.

🛠️ New: Fass zu Fass Logic (Tank-to-Tank Suction Logic)
This mod now also enhances tank-to-tank suction logic. When transferring slurry from one vehicle to another, the suction rate will be limited to the lower suction speed of the two tanks.

📁 Installation
Download the latest release .zip from the Releases tab.

Place the .zip file into your mods folder.

Enable the mod in the mod selection menu before loading your savegame.

📊 Performance
This mod is optimized to minimize performance impact, running efficiently in the background without affecting framerate or loading times. It does not override any base game files and is fully multiplayer-compatible (including dedicated servers).

📝 Changelog (latest version)
Improved suction rates for multiple default and modded slurry tanks.

Custom suction rates can now be set via vehicle XML files or the API.

New Tank-to-tank suction logic has been added, with rate limiting based on the slower tank.

Optimizations for better performance and smoother gameplay.

For a detailed list of all changes, please take a look at the Changelog in the Releases section.

📄 License
This mod, RealisticSlurrySuction, is created by komischervogel11 and should not be uploaded to any other websites without permission or claimed as the work of any other user. Any violation of these terms may result in legal action.

Notes:
Modders can add the slurry suction rates for modded vehicles via a simple XML configuration or directly in the script for custom settings.

This mod is aimed at enhancing realism but maintains multiplayer compatibility and server stability.
