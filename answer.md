**Biggest issue before push:** your repo is currently tracking generated/local files that should usually stay out of Git.

1. **`.dart_tool` is tracked right now** (`381` tracked files, many modified/untracked).  
   Add to root `.gitignore`:
   ```gitignore
   .dart_tool/
   build/
   .idea/
   .vscode/
   *.log
   ```
   Then untrack it once:
   ```powershell
   git rm -r --cached .dart_tool
   ```

2. **You have a lot of deletions staged as working changes** (especially `.agent/*`, `figma designs/*`, prompts/scripts).  
   If those deletions are intentional, fine. If not, restore before commit:
   ```powershell
   git restore -- .agent "figma designs" prompts find_images.py parser.py
   ```

3. **No obvious secret files found** (`.env`, keystore/p12/pem, firebase-admin JSON not found).  
   `lib\firebase_options.dart` has Firebase API keys, which is normal for Flutter client apps, but make sure Firebase rules/restrictions are properly set.

4. **Root `.gitignore` is too minimal** (currently basically just `build/`).  
   Expand it now, otherwise this keeps happening.
