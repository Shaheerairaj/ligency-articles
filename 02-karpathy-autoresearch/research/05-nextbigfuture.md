---
title: "Andrej Karpathy on Code Agents, AutoResearch and the Self-Improvement Loopy Era of AI"
source: https://www.nextbigfuture.com/2026/03/andrej-karpathy-on-code-agents-autoresearch-and-the-self-improvement-loopy-era-of-ai.html
type: analysis
publication: Next Big Future
date_published: 2026-03
date_fetched: 2026-05-10
tags: [autoresearch, agentic-engineering, self-improvement-loop, code-agents, LLM-application-layer, karpathy-philosophy, context-engineering]
related:
  - 07-pjfp-no-priors-interview.md
  - 02-fortune-article.md
  - 01-github-readme.md
---

# Andrej Karpathy on Code Agents, AutoResearch and the Self-Improvement Loopy Era of AI

**Source:** https://www.nextbigfuture.com/2026/03/andrej-karpathy-on-code-agents-autoresearch-and-the-self-improvement-loopy-era-of-ai.html  
**Publication:** Next Big Future

---

## AutoResearch in Action

Karpathy's quote on what the agent does:

> "Agents edit train.py, try ideas (including novel architecture tweaks like reordering QK Norm and RoPE), learn from failures, and keep going."

**Results:** AutoResearch executed 700 experiments across two days on a single GPU, discovering 20 training optimizations **without human intervention**. The system independently:
- Designed experiments
- Edited code
- Collected data
- Refined hyperparameters

---

## The "Loopy Era" of AI

Karpathy characterizes this period as one where:

> "Agents running continuous self-improvement loops on code and research will become standard at frontier laboratories."

His vision: **"Teams of agents collaborating asynchronously"** as the emerging research model — *"the seed for emulating a research community of agents."*

---

## Paradigm Shift: From Coding to Orchestration

| Era | Human Role |
|-----|-----------|
| Pre-2025 | Writing code directly |
| 2025 ("Vibe Coding") | Describing functionality, receiving working software |
| 2026 ("Agentic Engineering") | Directing, supervising, orchestrating agents |

Karpathy acknowledges this personally: his *"manual coding skills are atrophying because agents"* reached a coherence threshold around **December 2025**.

---

## LLM Application Layer

Karpathy's view on specialized AI applications (like Cursor, Claude Code):

- They're distinct from general LLM laboratories
- Bundle multiple coordinated LLM calls
- Provide context engineering
- Offer autonomy controls
- Supply domain-specific interfaces

He predicts they'll *"organize, finetune and actually animate teams"* of models into *"deployed professionals in specific verticals."*

---

## MicroGPT

Released alongside AutoResearch concept discussions: a functional GPT implementation in just **243 lines of Python**, designed to demystify core algorithms for both human and agent comprehension.
