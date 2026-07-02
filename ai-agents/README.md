# AI Agent Configs

This directory is the source of truth for reusable AI agent instructions.
Keep shared guidance here, then import or link it from individual projects.

## Files

- `AGENTS.md` contains common instructions for agents that read project-level agent guidance.

## Import Into A Project

From a project root, symlink the shared instructions:

```sh
ln -s "$HOME/dotfiles/ai-agents/AGENTS.md" AGENTS.md
```

If a project needs local overrides, keep a project-owned `AGENTS.md` and reference the shared file from it:

```md
# Project agent instructions

Start with the shared instructions in `/Users/kjalba/dotfiles/ai-agents/AGENTS.md`.

Add project-specific instructions below.
```

## Dotfiles Discovery

The repository root `AGENTS.md` is a symlink to `ai-agents/AGENTS.md`.
That keeps agent discovery working in this dotfiles repo while making this directory the place to manage shared config.
