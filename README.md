# Kingdom of Ashes

A dark-fantasy, top-down 2D story RPG prototype for Android, built with Godot 4 and GDScript.

## Current playable prototype
- Landscape ashland map with a ruined village and shrine.
- Touch joystick on the lower-left side.
- Real-time and turn-based combat mode toggle.
- Ash Wraith enemies and attack button.
- Enemy health, XP and gold rewards.
- First quest: find and awaken the Ashen Shrine.
- Save/load using a local JSON save file.
- Keyboard support: WASD/arrows, Space, E, Tab and S.

## Open and run
1. Install Godot 4.3 or newer.
2. Import this folder by selecting project.godot.
3. Run the project.

## Android APK export
This is a native Godot project, not a conventional Android Studio application. Godot's Android export pipeline uses the configured Android SDK/JDK and Gradle build tooling.
1. Install Android build templates from Editor → Manage Export Templates.
2. Install Android SDK command-line tools and a compatible JDK.
3. Set SDK paths in Editor Settings → Export → Android.
4. Add an Android preset in Project → Export. Package name: com.kingdomofashes.game.
5. Export a debug APK and install it on your phone.
A signed release APK requires your own release keystore. Never commit signing passwords or private keys.

## Project structure
- project.godot — project settings
- scenes/main.tscn — main game scene
- scripts/game.gd — world, HUD, quests, combat and saves
- scripts/player.gd — player movement and sprite
- scripts/enemy.gd — Ash Wraith enemy

## Scope
This is the first playable foundation, not the complete game. More chapters, locations, art, sound, bosses, equipment, dialogue and full turn-based encounter flow remain planned.
