# TRAP_npc_polyzone 🚀

![License](https://img.shields.io/badge/License-MIT-green) ![FiveM](https://img.shields.io/badge/FiveM-Compatible-blue) ![Lua](https://img.shields.io/badge/Language-Lua-orange)

**Polyzone NPC Script for FiveM – Automatic vehicle & ped cleanup with 3D in-game visualization**

---

## 🔹 Description

**TRAP_npc_polyzone** is a **script** for **FiveM** that allows you to:
---
**TRAP_npc_polyzone** is a script for FiveM that allows you to:

* Easily create custom polygons (polyzones) in-game.
* Automatically clean **vehicles and peds (NPCs)** inside the zone.
* Visualize zones in real-time with green walls and corner markers.
* Configure multiple zones with independent options.

---

**Perfect for:**

* Garages or RP shops to prevent NPCs or stray vehicles.
* Secure zones for RP missions or events.
* Precisely controlling entities for enhanced RP immersion.
* Removing wandering NPCs in an MLO or any area.
---

## 🔹 Features

* **Multi-zone support**: Configure multiple polyzones individually.
* **Optimized**: Cleans only nearby entities to reduce performance impact.
* **3D Debug**: In-game visualization with vertical walls and corner markers.
* **Easy to configure**: All zones are set up in `config.lua`.
* **Extensible**: Ready for logs, notifications, or integration with other scripts.

---

## 🔹 Installation

1. Copy the `TRAP_npc_polyzone` folder into your `resources` directory.
2. Add to `server.cfg`:

   ```cfg
   start TRAP_npc_polyzone
   ```
3. Configure your polyzones in `config.lua`.
4. Start the server and enable **Config.Debug = true** to visualize zones in-game.

---

## 🔹 Example Configuration

```lua
Config = {}

-- Active ou désactive le debug (mur vert en jeu)
Config.Debug = true

-- Définir toutes les polyzones ici
Config.PolyZones = {
    test = {
        clearVehicles = true, -- supprimer véhicules NPC
        clearPeds = true,     -- supprimer peds NPC
        points = {
            {x = -2054.4846, y = -432.3635, z = 11.5195},
            {x = -1989.6630, y = -485.7856, z = 11.6392},
            {x = -2051.7283, y = -562.8635, z = 5.6088},
            {x = -2120.6768, y = -510.3206, z = 2.3494}
        }
    }
}
```

---

## 🔹 Options

| Option          | Type    | Description                                    |
| --------------- | ------- | ---------------------------------------------- |
| `clearVehicles` | boolean | Removes vehicles within the zone               |
| `clearPeds`     | boolean | Removes peds within the zone                   |
| `radiusCheck`   | number  | Radius around the center to optimize detection |
| `Config.Debug`  | boolean | Displays the zone in 3D for debugging purposes |

---

## 🔹 Debug Mode

* Displays **green walls** around the zone, from ground to height.
* Marks corners with **green markers**.
* Allows you to **test your polyzones** before removing vehicles or NPCs.

💡 **Tip:** Increase `zMax` in `DrawPolyZone` for taller, more visible walls.

---

## 🔹 Screenshots / GIFs

<img width="1044" height="636" alt="image" src="https://github.com/user-attachments/assets/ee3135e1-ad2a-495d-9b54-5657c3329b9d" />

---

## 🔹 License

MIT License 

---


