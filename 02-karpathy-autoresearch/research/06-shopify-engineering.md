---
title: "Autoresearch Isn't Just for Training Models"
source: https://shopify.engineering/autoresearch
type: case-study
publication: Shopify Engineering Blog
date_fetched: 2026-05-10
tags: [autoresearch, shopify, case-study, generalization, pi-autoresearch, tobi-lutke, engineering-optimization, real-world-results]
related:
  - 02-fortune-article.md
  - 07-pjfp-no-priors-interview.md
  - 01-github-readme.md
---

# Autoresearch Isn't Just for Training Models

**Source:** https://shopify.engineering/autoresearch  
**Publication:** Shopify Engineering Blog  
**Author:** David Cortés

---

## The Problem

David Cortés was frustrated with repeated CI failures on the Polaris team — spending **30 minutes per test cycle**. He discovered AutoResearch and realized it could be repurposed for **general engineering optimization**, not just model training.

---

## Key Insight: Generalizing the Three-File Contract

The ratchet loop works for **any domain with an automatic scoring function**. The pattern:
1. Identify a metric to optimize
2. Establish baseline measurements
3. Iteratively form hypotheses and test them
4. Retain improvements that beat baseline; discard failures
5. Continue indefinitely, accumulating incremental gains

> "Before autoresearch, AI agents were doing the same work humans did, just faster."

---

## Tobi Lütke's Contribution

Shopify's CEO contributed **32 commits** adding:
- Multi-metric support
- Automated scripts
- Auto-commit functionality

Extension completed and open-sourced within hours → became **pi-autoresearch** (open-source, 3,600+ GitHub stars, 200+ forks).

---

## Concrete Results

| Optimization Target | Improvement |
|--------------------|-------------|
| Polaris build speed | **65% faster** (identified wasteful TypeScript processing) |
| Liquid parse + render | **53% faster** |
| Object allocations | **61% fewer** |
| Unit tests | **300x faster** |
| React mounting | **20% faster** |
| pnpm | Accelerated |

Plus: Internal `#autoresearch-wins` Slack channel documenting ongoing wins across Shopify's engineering org.

---

## Why This Matters for the Article

Shopify's case is the strongest proof that AutoResearch is a **general-purpose engineering pattern**, not just an ML research tool. The three-file contract (describe → modify → measure → ratchet) applies to any system where you can define a scoreable objective.
