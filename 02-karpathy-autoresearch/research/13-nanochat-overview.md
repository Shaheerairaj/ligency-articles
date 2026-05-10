---
title: "nanochat — Project Overview"
source: https://github.com/karpathy/nanochat
type: primary-source
publication: GitHub
date_launched: 2025-10-13
date_fetched: 2026-05-10
tags: [nanochat, karpathy, LLM-training, full-stack, pipeline, nanoGPT-successor, depth-parameter, scaling-laws, CORE-score, pretraining, SFT, RLHF, autoresearch]
related:
  - 11-nanochat-relationship.md
  - 12-nanochat-miniseries-tweet.md
  - 14-nanochat-launch-tweet.md
  - 01-github-readme.md
---

# nanochat — Project Overview

**GitHub:** https://github.com/karpathy/nanochat  
**Launched:** October 13, 2025  
**Tagline:** "The best ChatGPT that $100 can buy."  
**Successor to:** nanoGPT (which only covered pretraining — now deprecated)

---

## What nanochat Is

A minimal, from-scratch, full-stack LLM training and inference pipeline for building ChatGPT-style models. ~8,000 lines of PyTorch. Designed to be readable, hackable, and reproducible. Will be the capstone project of Karpathy's **LLM101n** course (in development).

Key difference from nanoGPT: nanochat covers the *entire* LLM pipeline — not just pretraining.

---

## The Seven Pipeline Stages

| Stage | What it does | Time (8×H100) |
|-------|-------------|---------------|
| **1. Tokenization** | Custom Rust-based BPE tokenizer (rustbpe), 65,536-token vocab, trained on FineWeb-EDU shards, ~4.8 chars/token compression | ~minutes |
| **2. Pretraining** | Base GPT transformer on ~11.2B tokens (FineWeb-EDU). Muon optimizer for matmul params, AdamW for embeddings | ~2–3 hours |
| **3. Mid-training** | Adapts base model to conversations via SmolTalk + MMLU + GSM8K. Teaches tool use (`<\|python_start\|>...<\|python_end\|>`) | ~8 minutes |
| **4. Supervised Fine-Tuning (SFT)** | Refines on high-quality conversations, matches test-time formatting | ~7 minutes |
| **5. RL (optional)** | Simplified GRPO on GSM8K — no KL penalties or reference models | ~1 hour |
| **6. Evaluation** | Generates `report.md` with CORE, ARC-Easy/Challenge, MMLU, GSM8K, HumanEval, ChatCORE scores | — |
| **7. Inference / Chat UI** | Custom Engine with KV cache, prefill/decode, Python interpreter sandbox + ChatGPT-like web UI | — |

---

## The Depth Parameter — The Single Dial

One integer (`--depth`) controls everything. It sets:
- Transformer layers (depth)
- Width (hidden channels)
- Number of attention heads
- Learning rate
- Training horizon
- Weight decay

This implements Chinchilla's compute-optimal principle automatically — you pick your budget, the system picks the right model size and training duration.

**Reference depths:**
- `--depth 20` → ~560M parameters, ~$100 speedrun, GPT-2 capability range
- `--depth 24–26` → ~$300–500, surpasses GPT-2 CORE score
- Higher → scales toward GPT-3 range

---

## Cost & Performance Tiers

| Budget | Duration | MMLU | ARC-Easy | Notes |
|--------|----------|------|----------|-------|
| ~$48 | ~2 hours | — | — | GPT-2 capability ($15 on spot instances) |
| ~$100 | ~4 hours | 0.3151 | — | Full speedrun baseline |
| ~$300 | ~12 hours | — | — | Slightly surpasses GPT-2 CORE |
| ~$1,000 | ~42 hours | ~0.40 | ~0.70 | Coherent reasoning + coding |

*Pricing based on 8×H100 at ~$24/hour (Lambda GPU Cloud)*

**Historical context:** GPT-2 cost ~$43,000 to train in 2019. nanochat achieves the same capability for $48 in 2026.

---

## Key Technical Details

- **Loss metric:** Bits-per-byte (bpb) — tokenizer-invariant, used for fair cross-model comparison (same metric as AutoResearch's `val_bpb`)
- **Evaluation:** DCLM CORE score — standardized across nanochat, GPT-2, GPT-3 for direct comparison
- **Distributed training:** torchrun, multi-GPU via DDP
- **Precision:** bfloat16 / float32 / float16 support
- **Batch size:** 32 × 2048 = 524,288 (~0.5M) tokens per optimization step on 8×H100
- **Custom Linear layer:** manages mixed-precision computation explicitly
- **Model FLOPs utilization:** ~50% through careful batching

---

## Relationship to AutoResearch

The nanochat **leaderboard** explicitly documents AutoResearch iterations:
- Entries 5–6 reference "autoresearch rounds" achieving progressive speedups toward GPT-2 capability
- AutoResearch takes nanochat's training core (train.py, ~630 lines) and wraps it in the agent loop
- The `val_bpb` metric used in AutoResearch is the same bpb metric defined in nanochat's `prepare.py`
- `scaling_laws.sh` and `miniseries.sh` scripts in nanochat enabled the systematic exploration that preceded AutoResearch

**The lineage:**
```
nanoGPT (pretraining only, deprecated)
  → nanochat (full pipeline, 8,000 lines, Oct 2025)
    → nanochat training core extracted (~630 lines)
      → AutoResearch (agent-driven experiment loop, Mar 2026)
```

---

## Sources

- [GitHub repo](https://github.com/karpathy/nanochat)
- [Launch discussion #1](https://github.com/karpathy/nanochat/discussions/1)
- [Miniseries v1 discussion #420](https://github.com/karpathy/nanochat/discussions/420)
- [MarkTechPost launch article](https://www.marktechpost.com/2025/10/14/andrej-karpathy-releases-nanochat-a-minimal-end-to-end-chatgpt-style-pipeline-you-can-train-in-4-hours-for-100/)
- [Analytics Vidhya overview](https://www.analyticsvidhya.com/blog/2025/10/andrej-karpathys-nanochat/)
