---
title: "AutoResearch — Official GitHub README"
source: https://github.com/karpathy/autoresearch
type: primary-source
date_fetched: 2026-05-10
tags: [autoresearch, karpathy, github, technical, ratchet-loop, val-bpb, program-md, train-py, prepare-py]
related:
  - 03-datacamp-tutorial.md
  - 04-ken-huang-substack.md
  - 08-marktechpost.md
---

# AutoResearch: Official GitHub README

**Source:** https://github.com/karpathy/autoresearch  
**Type:** Primary source (Karpathy's own repo)

---

## Project Overview

AutoResearch is an experimental framework where AI agents autonomously conduct machine learning research on a single GPU. The system allows agents to modify training code, run 5-minute experiments, evaluate results, and iterate — completing approximately 100 experiments overnight.

The premise: *"Give an AI agent a small but real LLM training setup and let it experiment autonomously overnight. It modifies the code, trains for 5 minutes, checks if the result improved, keeps or discards, and repeats."*

---

## Three Essential Files

### prepare.py (Immutable / Static)
- Handles one-time dataset preparation (downloads data, trains BPE tokenizer with 8,192-token vocab)
- Defines the validation metric: `val_bpb` (validation bits per byte)
- **Neither humans nor agents modify this file** — it's the fixed yardstick

### train.py (Agent's Sandbox)
- 630 lines containing the GPT architecture, Muon+AdamW optimizer, and training loop
- The **only file the agent is allowed to edit**
- Agent can rewrite anything: swap activation functions, restructure attention heads, modify learning schedules, change weight initialization
- Must produce a `val_bpb` score to count as a valid experiment

### program.md (Human Direction Layer)
- Written in markdown, **exclusively human-authored**
- Specifies research priorities, baseline metrics (e.g., `val_bpb: 0.997900`, peak VRAM: 45 GB)
- Contains exact commands for running experiments and failure-handling protocols
- Critical directive: *"NEVER STOP. Once the experiment loop has begun, do NOT pause to ask the human if you should continue."*
- Design principle: *"All else being equal, simpler is better. A small improvement that adds ugly complexity is not worth it."*

---

## The Ratchet Loop Mechanism

Fixed 5-minute training window (wall-clock time). After each run:
- Agent compares `val_bpb` (validation bits per byte — lower is better)
- Improvements → kept
- No improvement → discarded
- `val_bpb` is vocabulary-size-independent, enabling fair comparison across architectural changes

---

## Key Technical Details

| Detail | Value |
|--------|-------|
| Metric | `val_bpb` (validation bits per byte) |
| Time budget per experiment | 5 minutes (wall clock) |
| Experiments per hour | ~12 |
| Experiments per night | ~80–100 |
| Platform | Single NVIDIA GPU (tested on H100) |
| Dependencies | PyTorch, minimal packages via `uv` |

---

## Requirements & Quick Start

**Prerequisites:**
- Python 3.10+
- `uv` package manager
- Single NVIDIA GPU (20+ GB VRAM recommended)

**Setup:**
```bash
git clone https://github.com/karpathy/autoresearch.git
cd autoresearch
uv sync
uv run prepare.py
```

Then open a coding agent (Claude Code, Cursor, etc.) in the project directory and prompt it to read `program.md`.

---

## Design Philosophy

Deliberately simple: one GPU, one modifiable file, one metric. Self-contained approach enables fair benchmarking across hardware platforms via fixed time budget (not iteration counts).
