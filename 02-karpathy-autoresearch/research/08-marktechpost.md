---
title: "Andrej Karpathy Open-Sources AutoResearch: A 630-Line Python Tool for Autonomous ML Experiments"
source: https://www.marktechpost.com/2026/03/08/andrej-karpathy-open-sources-autoresearch-a-630-line-python-tool-letting-ai-agents-run-autonomous-ml-experiments-on-single-gpus/
type: media-coverage
publication: MarkTechPost
date_published: 2026-03-08
date_fetched: 2026-05-10
tags: [autoresearch, open-source, 630-lines, single-gpu, val-bpb, BPB-metric, nanochat, paradigm-shift]
related:
  - 01-github-readme.md
  - 03-datacamp-tutorial.md
  - 04-ken-huang-substack.md
---

# Andrej Karpathy Open-Sources AutoResearch: A 630-Line Python Tool

**Source:** https://www.marktechpost.com/2026/03/08/andrej-karpathy-open-sources-autoresearch-a-630-line-python-tool-letting-ai-agents-run-autonomous-ml-experiments-on-single-gpus/  
**Publication:** MarkTechPost | **Date:** March 8, 2026

---

## Release

Released March 7, 2026. **21,000+ GitHub stars** within days.

---

## Core Architecture Summary

Structured collaboration between human researchers and AI agents:
- **Human role:** Provide high-level research instructions via markdown files
- **AI agent role:** Read instructions, modify Python training scripts
- **Execution:** Fixed 5-minute training cycles to evaluate changes

The framework is a stripped-down version of Karpathy's **nanochat** LLM training core. ~630 lines ensures the entire codebase fits within modern LLM context windows — reducing code generation errors.

---

## Validation Metric: bits-per-byte (BPB)

- **What it measures:** Compression efficiency — how many bits are needed per byte of text
- **Lower = better** (indicates better prediction/compression)
- Agent only commits code modifications when final BPB score **improves** on previous best
- Vocabulary-size-independent → fair comparisons across architectural changes

---

## Performance Results

- Initial demo: validation loss from **1.0 → 0.97 BPB** through autonomous iteration
- Shopify CEO Tobi Lütke: **19% improvement** in validation scores
  - Agent-optimized smaller model eventually **outperformed** a larger manually-configured alternative

---

## Development Paradigm Shift

Transition from manual hyperparameter tuning toward "agentic" workflows:
- Engineering focus shifts from **writing code** to **optimizing prompts**
- Prompts guide AI agents in discovering efficient neural architectures and training configurations
- Humans become directors/reviewers rather than implementers
