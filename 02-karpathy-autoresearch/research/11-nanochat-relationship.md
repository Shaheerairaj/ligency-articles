---
title: "The nanochat → AutoResearch Lineage"
type: research-note
date_created: 2026-05-10
tags: [nanochat, autoresearch, lineage, scaling-laws, chinchilla, architecture, context]
related:
  - 10-original-announcement-tweet.md
  - 01-github-readme.md
  - 05-nextbigfuture.md
---

# The nanochat → AutoResearch Lineage

**Key insight:** AutoResearch is not a standalone project. It is a stripped-down, agent-ready slice of nanochat.

---

## What is nanochat?

nanochat is Karpathy's full-stack, from-scratch LLM training pipeline. It covers:
- Pretraining
- Fine-tuning / instruction tuning
- RLHF
- Inference
- Scaling law experiments
- Multi-GPU and multi-node training

It is the "real" research codebase — the production-grade system Karpathy uses for serious model training.

---

## How AutoResearch Derives from nanochat

Karpathy's own words (from the announcement tweet):

> "It's basically nanochat LLM training core stripped down to a single-GPU, one file version of ~630 lines of code."

The extraction process:
```
nanochat (full pipeline, multi-GPU, multi-file)
  → training core only (removes inference, RLHF, multi-GPU)
    → single file (train.py, ~630 lines)
      → single GPU (tested on H100)
        → wrapped with program.md + ratchet loop
          = AutoResearch
```

**Why strip it down?**  
So the entire codebase fits inside an AI agent's context window. An agent can read all 630 lines, understand the full system, and make safe modifications — without missing context or hallucinating about code it hasn't seen.

---

## The nanochat Miniseries: The Foundation That Makes AutoResearch Trustworthy

Before AutoResearch, Karpathy published the **nanochat miniseries v1** post (github.com/karpathy/nanochat/discussions/420). In it he:

- Proved nanochat obeys **Chinchilla scaling laws** (parameter-to-token ratio exponent ≈ 0.5)
- Found the compute-optimal constant for nanochat is **8** (vs Chinchilla's 20)
- Swept models from d10 to d20, showing clean non-intersecting training curves
- Related nanochat to GPT-2/GPT-3 via **CORE scores** (from DCLM paper)
- Total cost of this miniseries: ~$100

**Why this matters for AutoResearch:** The miniseries established that nanochat is a well-behaved, predictable training setup. When AutoResearch finds a `val_bpb` improvement, you can trust it's real — not an artifact of a noisy or misconfigured training loop. The solid baseline is what makes the agent's ratchet meaningful.

---

## The nanochat GPT-2 in 2hrs Tweet (March 5, 2026)

Tweet: https://x.com/karpathy/status/2029701092347630069

Two days before the AutoResearch announcement, Karpathy tweeted:

> "nanochat now trains GPT-2 capability model in just 2 hours on a single 8XH100 node (down from ~3 hours 1 month ago). Getting a lot closer to ~interactive! A bunch of tuning and features (fp8) went in but the biggest difference was a switch of the dataset from FineWeb-edu to..."

This improvement in training speed almost certainly came from early autoresearch runs (or autoresearch-style experiments). It's the direct precursor showing the approach was already working before the public release.

---

## Summary of the Relationship

| | nanochat | AutoResearch |
|---|---|---|
| **Scope** | Full LLM pipeline | Training core only |
| **Files** | Multi-file, multi-stage | 3 files (`program.md`, `train.py`, `prepare.py`) |
| **GPU** | Multi-GPU, multi-node | Single GPU |
| **Lines** | Large codebase | ~630 lines |
| **Operated by** | Human researcher | AI agent |
| **Purpose** | Serious model training | Autonomous optimization research |
| **Context window** | Too large for agent | Fits in agent context window |
