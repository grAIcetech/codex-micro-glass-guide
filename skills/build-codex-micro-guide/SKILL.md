---
name: build-codex-micro-guide
description: Build, personalize, and visually verify a native macOS floating glass guide for the Work Louder x OpenAI Codex Micro. Use when a user asks to create, update, resize, restyle, explain, package, or safely publish a Codex Micro learning overlay based on their current buttons, dial, joystick, layers, and recent Codex tasks.
---

# Build a Codex Micro glass guide

Create a local teaching overlay from the bundled native Swift template. Keep personal task data private and distinguish verified hardware behavior from inferred mappings.

## 1. Recover the real layout

1. Read the installed Codex Micro configuration when available. On Codex desktop for macOS, inspect the relevant `desktop.codex-micro-layout` section without printing unrelated configuration or secrets.
2. Recover up to six recent Codex tasks through an available Codex thread tool. If task IDs are unavailable, keep the sample tiles unlinked instead of inventing IDs.
3. Read [references/device-controls.md](references/device-controls.md) before changing hardware explanations.
4. Treat task titles and thread IDs as private. Never place them in a public repository, screenshot, release bundle, or example.

## 2. Scaffold the app

Run:

```bash
zsh scripts/scaffold-guide.sh /absolute/output/path
```

The command copies `assets/app-template/` without overwriting an existing destination.

## 3. Personalize the copy

Edit only the scaffolded copy:

- Replace the six `ThreadSlot` samples with confirmed titles, descriptions, and IDs. Leave `id` empty when no confirmed deep link exists.
- Replace dial and joystick labels with the installed mappings.
- Match the user's selected command keycaps.
- When the user wants one-button access, label the selected physical key **GUIDE · Show / hide** and map it to `Control + Option + Command + G`; the template registers that global shortcut while it is running.
- Preserve the touch-sensor and layer-light explanations unless current primary documentation contradicts them.
- Keep approval, rejection, microphone, and command tiles instructional. Do not make a teaching overlay execute consequential actions.
- Preserve `.titled`, `.fullSizeContentView`, and `.resizable` so every edge and corner resizes natively.

## 4. Build and verify

Run `zsh build-app.sh` in the scaffolded directory. The build is local and uses AppKit; macOS 26 receives native Liquid Glass and older supported macOS versions receive the visual-effect fallback.

Then launch the generated `.app` and inspect the real window. Verify:

- it floats above other apps and moves by dragging empty glass;
- every edge and corner resizes between the declared minimum and maximum sizes;
- text remains legible at minimum, default, and expanded sizes;
- all six Agent tiles have RGB-style halos while command tiles remain comparatively unlit;
- teaching tiles update the explanation strip;
- `Control + Option + Command + G` shows and hides the guide while the helper is running;
- only Agent tiles with confirmed IDs open `codex://threads/...`;
- the app launches without a network connection, while live Codex destinations may still require Codex connectivity;
- `plutil -lint` and `codesign --verify --deep --strict` pass.

Use a macOS UI-control capability for the rendered check when one is available. Do not claim visual or resize success from compilation alone.

## 5. Publish safely

Publish the generic skill and template, not a generated personal app.

- Scan the public tree for thread IDs, personal project names, usernames, secrets, and private paths.
- State that the project is an unofficial community tool and is not affiliated with or endorsed by OpenAI or Work Louder.
- Link to primary product/setup sources instead of copying protected product artwork.
- Mention `openai/codex` as a compatibility reference; do not imply that an organization mention is an endorsement.
- Do not claim a Work Louder GitHub handle unless an official verified account is found.
- Require a fresh remote URL, pushed commit, rendered GitHub page, and owner acceptance before calling publication complete.
