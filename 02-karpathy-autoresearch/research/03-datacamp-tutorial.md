---
title: "A Guide to Andrej Karpathy's AutoResearch: Automating ML with AI Agents"
source: https://www.datacamp.com/tutorial/guide-to-autoresearch
type: tutorial
publication: DataCamp
date_fetched: 2026-05-10
tags: [autoresearch, tutorial, ratchet-loop, val-bpb, git-tracking, program-md, train-py, prepare-py, setup-guide, limitations, results]
related:
  - 01-github-readme.md
  - 04-ken-huang-substack.md
  - 08-marktechpost.md
brief-note: "Reference article flagged in brief as too high-level for our target audience. Use for structure reference only — enrich with deeper technical material."
---

# A Guide to Andrej Karpathy's AutoResearch: Automating ML with AI Agents

**Source:** https://www.datacamp.com/tutorial/guide-to-autoresearch  
**Publication:** DataCamp  
**Brief note:** This is the reference article from the article brief. The brief specifically says it's too high-level for our target audience (advanced AI engineers). Use as structural reference, not as the depth benchmark.

---

## Three-File Architecture (Deep Detail)

### prepare.py — The Immutable Evaluator
- Constructs BPE tokenizer with **8,192-token vocabulary**
- Processes training data
- Defines the validation metric: `val_bpb` (validation bits-per-byte)
- **Neither humans nor agents modify it** → ensures every experiment is measured against the same yardstick

### train.py — The Agent's Sandbox (630 lines)
Includes:
- GPT architecture
- Muon + AdamW optimizer
- Complete training loop

Agent can rewrite anything:
- Swap activation functions
- Restructure attention heads
- Modify learning schedules
- Change weight initialization

Only constraint: code must train and produce a `val_bpb` score.

### program.md — Human Direction
Written in markdown, exclusively human-authored. Contains:
- Research priorities
- Hardcoded baseline metrics (e.g., `val_bpb: 0.997900`, peak VRAM: 45 GB)
- Exact commands for running experiments
- Failure-handling protocols
- The critical directive: *"NEVER STOP. Once the experiment loop has begun, do NOT pause to ask the human if you should continue."*
- Key design principle: *"All else being equal, simpler is better. A small improvement that adds ugly complexity is not worth it."*

---

## The Ratchet Loop: Nine-Step Cycle (Detailed)

| Step | Action |
|------|--------|
| 1 | **Read Context** — Agent examines `program.md`, current `train.py`, and `results.tsv` |
| 2 | **Propose Hypothesis** — Architect change, optimizer adjustment, or training modification |
| 3 | **Implement Change** — Modify `train.py` accordingly |
| 4 | **Commit** — Stage the change in git |
| 5 | **Train** — Run for exactly 5 minutes (fixed wall-clock budget) |
| 6 | **Handle Failures** — Log crashes, revert commits, retry |
| 7 | **Evaluate** — Measure `val_bpb` and record in `results.tsv` |
| 8 | **Ratchet Decision** — If improved → keep commit; otherwise → `git reset HEAD~1` |
| 9 | **Loop** — Return to step 1 |

**Throughput:** ~12 experiments/hour → 80–100 experiments overnight

**Why fixed 5-minute budget?** Ensures "changes that train faster and changes that converge lower are evaluated on equal footing."

---

## Results Tracking (results.tsv)

Complete audit trail containing:
- Commit hash
- `val_bpb` score
- GPU memory usage
- Pass/fail status
- Experimental description

Agent reads its own git history and `results.tsv` to build on promising directions. Early experiments → broad exploration. Later iterations → narrowed focus based on validated directions.

---

## Documented Results

| Run | Experiments | Improvements | Outcome |
|-----|-------------|--------------|---------|
| Initial overnight | 83 | 15 | val_bpb: 1.000 → 0.975 |
| Extended 2-day | ~700 | ~20 | Transferred to depth-24 models |
| Production benchmark | — | — | Time-to-GPT-2: 2.02h → 1.80h (11% faster) |
| Community session | 126 | — | val_bpb: 0.9979 → 0.9697 |

Specific improvements discovered:
- Missing QKnorm scalar multipliers
- Value Embedding regularization benefits
- Banded attention tuning

These are **structural code changes, not random hyperparameter sweeps**.

---

## Setup Guide

**Prerequisites:**
- NVIDIA GPU (20+ GB VRAM recommended)
- Python 3.10+
- `uv` package manager
- Coding agent (Claude Code, Cursor, or similar)

**Installation:**
```bash
git clone https://github.com/karpathy/autoresearch.git
cd autoresearch
uv sync
uv run prepare.py
```

**For smaller hardware:** Switch to TinyStories dataset with reduced vocab (256 tokens) and depth (4 layers).

**Execution:** Open coding agent in project directory, prompt it to read `program.md` — agent independently runs the loop. Monitor via `tail -f results.tsv` or `git log`.

---

## Limitations: The Creativity Ceiling

### 1. The Ratchet Constraint
Only accepts **immediate improvements to val_bpb**. Agent cannot "take a step backward to set up a larger gain" — a reasoning pattern human researchers use routinely.

### 2. Local Search Trap
GitHub Issue #22: agents "cycle through minor variations of whatever worked last, stuck in a local search pattern."

### 3. Agent Conservatism (RLHF Effect)
Karpathy on Hacker News: the agent appears "cagy and scared" on open-ended problems due to RLHF training "which rewards safe, conservative outputs over bold experimentation."

### 4. Short Time Horizon
5-minute window: "changes that would only prove themselves over longer runs remain invisible."

### 5. Overfitting Risk
"Running 100 experiments against the same validation set carries an overfitting risk: some improvements may be specific to that eval rather than genuine gains."

---

## When to Use AutoResearch (Beyond LLM Training)

The three-file contract applies to any domain with an automatic scoring function:
- Search ranking
- Product categorization
- Named entity recognition
- Fraud scoring
- Intent classification

**Requirements:**
- Small models training in minutes
- Clear, consistent scoring functions
- Improvements that scale to production

---

## Key Insight on Human Role

> "Writing a good program.md requires having done the research yourself."

> "If the next generation of engineers skips that formative work because agents handle it now, the field will have plenty of compute and no one with the experience to point it in the right direction."

AutoResearch automates methodical iteration — but **formulating new research directions is still a human job**.
