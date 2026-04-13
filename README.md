# Combined Arms - Docker

Build a Docker container for Combined Arms, an OpenRA mod.  the main usage of this is to setup a dedicated (headless) server on Linux for multiplayer matches

## Getting this to work

As of today, the only release built for Linux is an AppImage, which won't work for us easily.  Therefore we take the "winportable" release and tweak the config to point it to the Linux Dotnet runtime instead.

Some other things that needed tweaking include:

* mod.config points to the wrong place for the OpenRA dlls (the "engine")
* This further requires changes to the `launch-dedicated` script.  It makes more sense to have a forked copy of this locally with our changes, rather than using sed \ some other magic.

## Deploying a new version

* Check for changes to `mod.config`, `OpenRA.Server.runtimeConfig.json` and `launch-dedicated.sh`.  The main thing here is to check if any changes are going to break the tweaks made in the Dockerfile
* Confirm the dotnet version hasn't changed - if it has, update the base image
* If everything is fine, just tag `camod/<version>` and GitHub actions should do the rest
