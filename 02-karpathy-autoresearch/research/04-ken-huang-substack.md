---
title: "Exploring Andrej Karpathy's Autoresearch: AI Agents Driving Autonomous ML Experimentation"
source: https://kenhuangus.substack.com/p/exploring-andrej-karpathys-autoresearch
type: analysis
publication: Ken Huang (Substack)
date_fetched: 2026-05-10
tags: [autoresearch, autonomous-ml, agent-architecture, technical-analysis, val-bpb, hyperparameters, attention-mechanisms]
related:
  - 01-github-readme.md
  - 03-datacamp-tutorial.md
  - 08-marktechpost.md
---

# Exploring Andrej Karpathy's Autoresearch: AI Agents Driving Autonomous ML Experimentation

**Source:** https://kenhuangus.substack.com/p/exploring-andrej-karpathys-autoresearch  
**Publication:** Ken Huang (Substack)

---

## Overview

A technical analysis of AutoResearch focusing on the core architecture and agent-controlled parameters in `train.py`.

---

## Core Architecture

AutoResearch runs on a stripped-down version of nanochat, Karpathy's minimal LLM training framework. ~630 lines, single-GPU.

**Workflow:**
- Humans provide high-level guidance via `program.md`
- External LLM-powered agent autonomously modifies `train.py`
- Fixed 5-minute training cycles to evaluate changes
- Objective: lowest `val_bpb` within time budget

---

## Agent-Controlled Parameters in train.py

Key parameters the agent can adjust:

| Parameter | Description | Baseline |
|-----------|-------------|---------|
| `DEPTH` | Number of model layers | 8 (reducible to 4) |
| `vocab_size` | Token vocabulary size | 8192 (customizable to 256) |
| `MAX_SEQ_LEN` | Context window length | — |
| Batch configs | Device and total batch sizes | Powers of 2 |
| `WINDOW_PATTERN` | Attention mechanisms | "SSSL" or "L" |
| Optimizer hyperparameters | Learning rates, warmup | LR improvements: 0.5 → 4.7 |

---

## Experimental Methodology

Each complete training run = one data point. Successful configurations committed via Git, creating an iterative research cycle:

1. Propose modification
2. Execute experiment
3. Evaluate outcome
4. Preserve improvements

**Design for accessibility:** Single-GPU design remains open for hardware-specific adaptations via community forks.

---

## Data Preparation

`prepare.py` handles:
- Dataset retrieval
- Byte-pair encoding tokenizer training (8,192-token vocabulary)
- This component stays static → prevents agent from destabilizing foundational operations
