# General
GTS Community Edition is an addon collection for the Gate to Sovngarde collection by JaySerpa. (https://www.nexusmods.com/games/skyrimspecialedition/collections/qdurkx)
This addon aims to not deviate too much from GTS, be easy to install, as compatible with other addons as reasonable, and easy to contribute to.
All contributions are welcome. Use Issues to report problems or suggest changes.
You can find CE here. (https://www.nexusmods.com/games/skyrimspecialedition/collections/hvfynw)

# Contributing
You can contribute in the following ways:
- Reporting issues
    - If the issue is with an in-game objects, select it in the console and attach an image.
    - If the issue is with an object that can't be selected, select something nearby.
- Suggesting mods
    - If you think a mod would be a good fit, you can make a mod suggestion issue.
    - If do some research about potential conflicts and patches, it's more likely that the mod will be accepted.
    - Check below for things that will not be accepted
- Making changes and sending PRs
    - Before actually doing the work, please do file an issue about any changes you wish to make.
    - Check below for things that will not be accepted

# Building
**If all you need is to edit the esp plugins, you will just need Spriggit, and can skip the build script entirely.**
**Simply download Spriggit, build the plugins, make your changes, then convert them back to YAML.**

Patches can be built automatically with the included build.py Python script.
To use it, you need the following:
- Python (https://www.python.org/)
- The Python colorama package
    - `pip install colorama`
- SpriggitCLI (https://github.com/Mutagen-Modding/Spriggit/releases)
    - The script uses a "SPRIGGIT_CLI_PATH" environment variable to find the SpriggitCLI binary. It should point to the executable file.
- Papyrus Compiler
    - The Papyrus Compiler comes with the Creation Kit on Steam. If you're using Vortex, you should Purge mods before installing the CK. Run the CK at least once and extract all scripts.
    - The script uses a "SKYRIM_SE_PATH" environment variable to find the compiler and script folders to include. It should point to the directory where the SkyrimSE.exe executable and data directory are.
- The Gate To Sovngarde collection

If you have all those, simply run the script with python `py build.py`. This will create a build directory with the built mod archives inside.

# Rejected Changes
These have already been discussed and will not be included in CE:
- Major overhauls
    - Things like Ordinator, Path of Sorcery, BFCO, etc.
- Anything NSFW
- UI reskins
    - It's been decided that these are best left to other addons.