#!/usr/bin/env bash
# tsrepl.sh — open a Node REPL in a new WezTerm pane, preloading a file.

FILE="$1"

if [ -z "$FILE" ]; then
  echo "Usage: tsrepl.sh <file.ts|file.js>"
  exit 1
fi

if [ ! -f "$FILE" ]; then
  echo "File not found: $FILE"
  exit 1
fi

ABS_PATH="$(realpath "$FILE")"
EXT="${FILE##*.}"

# Detect local vs global ts-node loader
LOCAL_TSNODE="./node_modules/ts-node/esm.mjs"
GLOBAL_TSNODE="$(npm root -g)/ts-node/esm.mjs"

if [ -f "$LOCAL_TSNODE" ]; then
  TSNODE_LOADER="$LOCAL_TSNODE"
elif [ -f "$GLOBAL_TSNODE" ]; then
  TSNODE_LOADER="$GLOBAL_TSNODE"
else
  TSNODE_LOADER=""
fi

# Only use loader for .ts files
if [ "$EXT" = "ts" ] && [ -n "$TSNODE_LOADER" ]; then
  LOADER="--loader $TSNODE_LOADER"
else
  LOADER=""
fi

# Launch WezTerm pane
wezterm cli split-pane --right -- fish -c "
  set -x NODE_PATH (npm root -g)
  echo 'Loading $ABS_PATH ...'
  node $LOADER -i --eval \"
    import * as mod from 'file://$ABS_PATH';
    import chokidar from 'file://$(npm root -g)/chokidar/index.js';;
    import { pathToFileURL } from 'node:url';
    Object.assign(globalThis, mod);
    console.log('Loaded exports:', Object.keys(mod));
    const watcher = chokidar.watch('$ABS_PATH', { ignoreInitial: true });
    watcher.on('change', async () => {
      const fresh = await import(pathToFileURL('$ABS_PATH') + '?v=' + Date.now());
      Object.assign(globalThis, fresh);
      console.log('🔁 Reloaded on save:', Object.keys(fresh));
    });
    \";
    fish
"

