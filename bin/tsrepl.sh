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
GLOBAL_MODULES="$(npm root -g)"

# Launch WezTerm pane
wezterm cli split-pane --right -- fish -c "
  echo 'Loading $ABS_PATH ...'
  echo 'Global modules: $GLOBAL_MODULES'
  
  # Create a temporary loader script
  set LOADER_FILE (mktemp).mjs
  
  echo \"
import { pathToFileURL } from 'node:url';

(async () => {
  try {
    const fileUrl = pathToFileURL('$ABS_PATH').href;
    
    // Load the file
    const mod = await import(fileUrl);
    Object.assign(globalThis, mod);
    console.log('✓ Loaded exports:', Object.keys(mod).join(', '));
    
    // Setup hot reload with explicit path
    const chokidarPath = pathToFileURL('$GLOBAL_MODULES/chokidar/index.js').href;
    const chokidar = await import(chokidarPath);
    const watcher = chokidar.default.watch('$ABS_PATH', { ignoreInitial: true });
    watcher.on('change', async () => {
      try {
        const fresh = await import(fileUrl + '?v=' + Date.now());
        Object.assign(globalThis, fresh);
        console.log('🔁 Reloaded:', Object.keys(fresh).join(', '));
      } catch (err) {
        console.error('❌ Reload failed:', err.message);
      }
    });
    
    console.log('Ready! (file watching enabled)');
    console.log('');
  } catch (err) {
    console.error('Failed to load:', err);
  }
})();
  \" > \$LOADER_FILE
  
  # Start Node REPL with the loader
  node --experimental-strip-types --experimental-repl-await -i -r \$LOADER_FILE
  
  # Cleanup
  rm \$LOADER_FILE
"
