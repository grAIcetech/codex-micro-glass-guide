<p align="center">
  <img src="assets/codex-micro-glass-hero.png" alt="Original 3D concept illustration of a translucent glass macro keypad with glowing keys" width="100%">
</p>

<h1 align="center">Codex Micro Glass Guide</h1>

<p align="center">
  <strong>Your tiny glass copilot for learning every key, dial, light, and layer.</strong><br>
  A movable, resizable macOS guide for the Work Louder × OpenAI Codex Micro.
</p>

<p align="center"><em>Think of it as training wheels—made of glass, with excellent lighting.</em></p>

> [!NOTE]
> The hero image is original concept artwork, not an official product rendering.

## What is it?

**Codex Micro Glass Guide** turns your current Codex Micro layout into a friendly floating cheat sheet. Keep it above your apps while you learn the device, click any control for a plain-language reminder, and tuck it away when muscle memory takes over.

| ✨ Looks delightful | 🧭 Teaches as you go | 🔒 Stays local |
| --- | --- | --- |
| Translucent glass, 3-D beveled buttons, and soft RGB halos. | Explains the dial, joystick, touch sensor, layer lights, and keys. | The generated Mac app launches offline and keeps personal task links out of this repository. |

## The fun bits

- Floats above your other Mac apps
- Moves anywhere and resizes from every edge or corner
- Shows all six programmable layers in plain language
- Gives the six Agent keys colorful backlit glows
- Can label your own key selections and recent Codex tasks
- Uses clickable teaching tiles instead of triggering consequential actions
- Works offline as a guide; live Codex destinations may still need Codex connectivity

## Skill + app: two pieces, one helper

The **skill** teaches Codex how to recover your layout, protect private task data, build the guide, and verify the real rendered window.

The **generated app** is the native macOS overlay you can open, move, resize, and use offline while learning the device.

## Install the skill

In Codex, run:

```text
$skill-installer install https://github.com/grAIcetech/codex-micro-glass-guide/tree/main/skills/build-codex-micro-guide
```

Then ask:

```text
Use $build-codex-micro-guide to build a floating guide for my Codex Micro layout.
```

Or copy [`skills/build-codex-micro-guide`](skills/build-codex-micro-guide) into your local Codex skills directory.

## Requirements

- macOS 13 or newer
- Swift compiler from Xcode Command Line Tools
- Codex desktop for personalized task links and mappings
- macOS 26 for native Liquid Glass; older supported versions use an AppKit visual-effect fallback

## Privacy first

Generated personal apps may contain local Codex task IDs and titles. Never commit or publish a personalized build. This repository contains only a generic template with empty, unlinked sample tasks.

## Project name

- Friendly name: **Codex Micro Glass Guide**
- Skill identifier: **`build-codex-micro-guide`**
- Proposed repository: **`codex-micro-glass-guide`**

## Attribution

This is an independent community project and is not affiliated with or endorsed by OpenAI or Work Louder. Codex, OpenAI, Work Louder, and Codex Micro are names or marks of their respective owners.

- [OpenAI × Work Louder Codex Micro](https://openai.com/supply/co-lab/work-louder/)
- [Work Louder Codex Micro setup](https://worklouder.cc/openai-micro-setup)
- [OpenAI Codex on GitHub](https://github.com/openai/codex)
