---
title: "Andrej Karpathy on AutoResearch, AI Agents, and Why He Stopped Writing Code (No Priors Interview Breakdown)"
source: https://pjfp.com/andrej-karpathy-on-autoresearch-ai-agents-and-why-he-stopped-writing-code-full-breakdown-of-his-2026-no-priors-interview/
type: interview-breakdown
publication: PJFP.com
date_fetched: 2026-05-10
tags: [karpathy, agentic-engineering, no-code, orchestration, dobby, jaggedness, open-source, digital-transformation, interview, quotes]
related:
  - 05-nextbigfuture.md
  - 02-fortune-article.md
  - 09-mljar.md
---

# Andrej Karpathy on AutoResearch, AI Agents, and Why He Stopped Writing Code

**Source:** https://pjfp.com/andrej-karpathy-on-autoresearch-ai-agents-and-why-he-stopped-writing-code-full-breakdown-of-his-2026-no-priors-interview/  
**Publication:** PJFP.com (breakdown of 2026 No Priors podcast interview)

---

## The December 2025 Turning Point

Karpathy experienced a dramatic workflow transformation starting **December 2025**:
- Shifted from writing ~80% of his own code to writing essentially **none**
- Describes it as a **"hard flip"** rather than gradual change
- Entered a state of **"AI psychosis"** — idle agent capacity creates constant anxiety about maximizing token throughput

---

## AutoResearch as Proof of Concept

When tested overnight on a model Karpathy had personally optimized over **two decades**, the system identified improvements he'd missed:
- Overlooked **weight decay on value embeddings**
- Insufficiently tuned **optimizer parameters**

This is the most striking data point: AutoResearch beat a world-class expert's own work on code he'd been refining for 20 years.

---

## The New Role: Orchestrator, Not Coder

Key reframe: **removing yourself as the bottleneck**.

New workflow:
- Delegate entire features to parallel agents (~20 minutes per assignment)
- Review outputs
- Manage multiple systems simultaneously
- Direct and supervise rather than write individual functions

---

## On Claude Specifically

Karpathy on coding agents:

> "Claude's personality feels like a teammate who gets excited about what you are building."

Contrasts favorably with alternatives he describes as "very dry" and disengaged. Notes that earned praise (which recognizes genuine quality) differs from indiscriminate approval.

---

## Dobby: Home Automation Through Agents

Karpathy created **"Dobby"** — an autonomous home agent controlling smart systems via **WhatsApp**.

The agent independently:
- Scanned his network
- Reverse-engineered device APIs
- Unified disparate smart home systems

Implication: most consumer apps should become **API endpoints that agents can access on users' behalf**.

---

## The Jaggedness Problem

Current models exhibit striking capability disparities:
- **Superhuman** on verifiable tasks (coding, mathematics)
- **Persistent mediocrity** elsewhere (e.g., still repeating identical jokes from years prior)

Karpathy: this "jaggedness" reveals **reinforcement learning's limitations** in domains lacking objective metrics.

---

## Open Source Assessment

- Open-source models lag closed alternatives by **6–8 months** (down from 18 months)
- Parallels Linux's ecosystem role
- Advocates for "ensemble" governance approaches
- Skeptical of further centralization

---

## Digital Transformation Sequence

Karpathy predicts sequential disruption:
1. **Digital transformation first** — maximum efficiency on data-based work
2. **Digital-physical interfaces** — sensors, cameras, equipment
3. **Physical robotics** — decades later, requires enormous capital

---

## Why He Remains Independent

Chose independence over frontier lab employment:
- Misalignment between frontier lab employees' financial incentives and broader humanity's interests
- Values maintaining independent analytical capacity on transformative technology governance
