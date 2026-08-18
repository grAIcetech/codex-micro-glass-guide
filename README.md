# Codex Micro Glass Guide

An unofficial community Codex skill for generating a personalized, floating macOS learning guide for the Work Louder × OpenAI Codex Micro.

The generated app is a native, offline-capable Mac overlay with Liquid Glass styling, resizable edges and corners, 3-D key bevels, Agent-key RGB halos, plain-language hardware explanations, and optional links to recent Codex tasks.

## Install the skill

In Codex, run:

> $skill-installer install https://github.com/grAIcetech/codex-micro-glass-guide/tree/main/skills/build-codex-micro-guide

Or copy `skills/build-codex-micro-guide/` into your Codex skills directory. Then ask:

> Use $build-codex-micro-guide to build a floating guide for my Codex Micro layout.

The skill contains a generic app template. It does not contain the creator's private Codex task IDs or conversation titles.

## Requirements

- macOS 13 or newer
- Swift compiler from Xcode Command Line Tools
- Codex desktop for personalized task links and mappings
- macOS 26 for native Liquid Glass; older supported versions use an AppKit visual-effect fallback

## Privacy boundary

Generated personal apps can contain local Codex task IDs and titles. Do not commit or publish a personalized build. Publish only the generic template in this repository.

## Attribution

This is an independent community project and is not affiliated with or endorsed by OpenAI or Work Louder. Codex, OpenAI, Work Louder, and Codex Micro are names or marks of their respective owners.

Product and setup references:

- [OpenAI × Work Louder Codex Micro](https://openai.com/supply/co-lab/work-louder/)
- [Work Louder Codex Micro setup](https://worklouder.cc/openai-micro-setup)
- [OpenAI Codex on GitHub](https://github.com/openai/codex)
