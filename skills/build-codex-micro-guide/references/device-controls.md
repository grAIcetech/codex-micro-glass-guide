# Codex Micro control reference

Use these primary sources when labeling the physical device:

- OpenAI product page: https://openai.com/supply/co-lab/work-louder/
- Work Louder setup guide: https://worklouder.cc/openai-micro-setup
- Work Louder product page: https://worklouder.cc/codex-micro
- OpenAI Codex repository: https://github.com/openai/codex

Verified setup behavior as of 2026-08-18:

- The six frosted Agent keys show Codex status: white idle, blue thinking, green complete, amber requires input, red error, and off when no Agent is assigned.
- The glossy bottom-left circle is a touch sensor.
- A quick sensor tap cycles programmable layers `1 -> 2 -> 3 -> 4 -> 5 -> 6 -> 1`.
- The three layer LEDs use these patterns from top to bottom: `100`, `010`, `001`, `110`, `011`, `111`.
- Holding the touch sensor for three seconds enters communication mode; it is not the layer-switch gesture.
- Work Louder Input can map separate actions per layer and AppSense can associate a layer with the focused application.
- Long-pressing the dial inside Codex opens Codex Micro configuration according to the setup guide.

Recheck primary sources before publishing a behavioral change. Product capabilities and software mappings can change.
