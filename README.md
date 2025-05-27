# 🚜 Realistic Slurry Suction (FS25 Mod)

**RealisticSlurrySuction** is a realism-focused mod for **Farming Simulator 25**, designed to overhaul the slurry and digestate suction speeds of all **default slurry tanks** and those included in the **Precision Farming DLC**. The goal: to bring authentic pump behavior based on real-world manufacturer data.

---

## 📦 Features

- ✅ Adjusts suction rates for **all base-game slurry tanks**
- ✅ Also supports **Precision Farming DLC slurry equipment**
- ✅ Based on **realistic pump performance** from manufacturer technical sheets
- ✅ Includes an optional **API for modders** to define custom suction speeds per vehicle
- ✅ Lightweight and optimized – works in **multiplayer** and on **dedicated servers**

---

## 🔧 How It Works

Each slurry tank's fill rate is determined by one of the following:

1. A **custom rate** defined in the vehicle's script (`vehicle.realisticSlurryFillRate`)
2. A predefined list of **known XML config filenames**
3. A **default fallback** suction rate, if no specific entry is found

Example suction rates:
- Farmtech Supercis 800 → `3 L/s`
- Samson PG II 28 → `6 L/s`
- Kotte PQ 32000 → `12 L/s`

Internally, fill rates are measured in **liters per millisecond** to match FS25 engine behavior. 
All rates are defined in liters per second (L/s) for simplicity. The script automatically converts them to liters per millisecond internally.

---

## 👨‍💻 API for Modders

Modders can define a custom suction rate directly in their vehicle script by setting:

```lua
vehicle.realisticSlurryFillRate = 0.006 / 1000 -- 6 liters/second
```
This will override any default or known config rate.

---

## 📁 Installation
1. Download the latest release .zip from the Releases tab.
2. Place the .zip file into your mods folder.
3. Enable the mod in the mod selection menu before loading your savegame.

---

## 📊 Performance
This mod is performance-friendly and runs in the background without affecting framerate or loading times. It does not override base game files and is fully multiplayer compatible.

## 📄 License
This mod, "RealisticSlurrySuction", shall not be uploaded to any other websites without permission of "komischervogel11" or claimed as the work of any other user except "komischervogel11". Any infraction of these conditions may result in legal action.
