# Research Index: A Practical Guide to Andrej Karpathy's AutoResearch

**Article Brief:** [Notion](https://www.notion.so/35a1b721b66d813e962ee55a70b4033a)  
**Status:** Researching  
**Deadline:** 2026-05-21  
**Target Audience:** Advanced / Engineering Managers  
**Word Count:** 2,500–4,000 words  
**Technical Depth:** Deep dive

---

## Source Files

| # | File | Type | Key Value |
|---|------|------|-----------|
| 01 | [GitHub README](./01-github-readme.md) | Primary source | Official architecture, files, ratchet loop, quick start |
| 02 | [Fortune Article](./02-fortune-article.md) | Media | Karpathy Loop framing, AutoML comparison, future vision |
| 03 | [DataCamp Tutorial](./03-datacamp-tutorial.md) | Tutorial (ref article) | Full 9-step ratchet loop, results table, limitations |
| 04 | [Ken Huang Substack](./04-ken-huang-substack.md) | Analysis | Agent-controlled parameters deep dive |
| 05 | [Next Big Future](./05-nextbigfuture.md) | Analysis | Agentic engineering philosophy, LLM app layer |
| 06 | [Shopify Engineering](./06-shopify-engineering.md) | Case study | Generalization beyond ML — 65% faster builds, 300x tests |
| 07 | [PJFP / No Priors Interview](./07-pjfp-no-priors-interview.md) | Interview | Karpathy's personal workflow shift, Dobby, jaggedness |
| 08 | [MarkTechPost](./08-marktechpost.md) | Media | BPB metric explanation, nanochat lineage, release context |
| 09 | [MLJAR](./09-mljar.md) | Analysis | Limitations, AutoLab comparison |
| 10 | [Original Announcement Tweet](./10-original-announcement-tweet.md) | Primary source | Full text of first AutoResearch tweet (Mar 7, 2026) |
| 11 | [nanochat → AutoResearch Lineage](./11-nanochat-relationship.md) | Research note | How AutoResearch derives from nanochat; why the baseline is trustworthy |

### nanochat Background Files

| # | File | Type | Key Value |
|---|------|------|-----------|
| 12 | [nanochat Miniseries v1 Tweet](./12-nanochat-miniseries-tweet.md) | Primary source | Full text (user-provided) — scaling laws, Chinchilla, CORE scores, $100 miniseries |
| 13 | [nanochat Overview](./13-nanochat-overview.md) | Primary source | Full pipeline (7 stages), depth parameter, cost tiers, relationship to AutoResearch |
| 14 | [nanochat Launch Tweet](./14-nanochat-launch-tweet.md) | Primary source | First nanochat announcement (Oct 13, 2025) + full tweet timeline |

---

## Failed Fetches (Paywalled / Rate-limited)

| Source | URL | Reason |
|--------|-----|--------|
| VentureBeat | [Karpathy's autoresearch lets you run hundreds of AI experiments a night](https://venturebeat.com/technology/andrej-karpathys-new-open-source-autoresearch-lets-you-run-hundreds-of-ai) | 429 Too Many Requests |
| Medium (Nikhil) | [Getting Started with Andrej Karpathy's autoresearch — Full Guide](https://medium.com/neuralnotions/getting-started-with-andrej-karpathys-autoresearch-full-guide-c2f3a80b9ce6) | Behind paywall |

---

## Karpathy's X/Twitter Thread (All Paywalled — Read Manually)

These are all the tweets in chronological order. X is fully paywalled so none could be fetched directly.

| Date | Tweet | Content Summary |
|------|-------|-----------------|
| Mar 5, 2026 | [nanochat GPT-2 in 2hrs](https://x.com/karpathy/status/2029701092347630069) | nanochat now trains GPT-2 in 2hrs on 8xH100 (down from 3hrs). Mentions dataset switch from FineWeb-edu + fp8. **Background context — not yet an AutoResearch announcement.** |
| Mar 7, 2026 | [AutoResearch repo release](https://x.com/karpathy/status/2030371219518931079) | "I packaged up the autoresearch project into a new self-contained minimal repo..." — **First public announcement of AutoResearch as a named project.** Went mini-viral over the weekend (8.6M views). |
| Mar 8–9, 2026 | [SETI@home vision](https://x.com/karpathy/status/2030705271627284816) | "The next step for autoresearch is that it has to be asynchronously massively collaborative for agents (think: SETI@home style). The goal is not to emulate a single PhD student, it's to emulate a research community of them." |
| Mar 10, 2026 | [Results tweet](https://x.com/karpathy/status/2031135152349524125) | "Three days ago I left autoresearch tuning nanochat for ~2 days on depth=12 model. It found ~20 changes that improved the validation loss. All additive and transferred to depth=24 models." — 11% training speedup. |
| Mar 10, 2026 | [Follow-up / link](https://x.com/karpathy/status/2031137476438548874) | "oh yeah i should have linked autoresearch probably... (you don't use it directly, it's just a recipe/idea — give it to your agent and apply to what you care about.) and the tweet about it that went mini-viral over the weekend with more context" |

**Note:** The "packaged up" language in the Mar 7 tweet implies AutoResearch was already running privately before that date. The Mar 7 tweet is the earliest *public* AutoResearch announcement found.

---

## Key Concepts Map

### Core Architecture
- **Three files:** `program.md` (human) → `train.py` (agent) → `prepare.py` (immutable)
- **Metric:** `val_bpb` (validation bits per byte) — lower is better, vocab-size-independent
- **Time budget:** Exactly 5 minutes per experiment → ~12/hour → ~100/night
- **See:** [01-github-readme.md](./01-github-readme.md), [03-datacamp-tutorial.md](./03-datacamp-tutorial.md)

### The Ratchet Loop (9 Steps)
Read → Hypothesize → Implement → Commit → Train → Handle Failures → Evaluate → Ratchet Decision → Loop  
- **See:** [03-datacamp-tutorial.md](./03-datacamp-tutorial.md)

### Proven Results
- 700 experiments / 2 days → 20 optimizations → 11% training speedup
- Shopify: 37 experiments → 19% validation improvement
- Shopify pi-autoresearch: 65% faster builds, 300x faster tests
- **See:** [02-fortune-article.md](./02-fortune-article.md), [06-shopify-engineering.md](./06-shopify-engineering.md)

### Limitations
- Ratchet constraint (no backward steps)
- Local search trap
- RLHF conservatism ("cagy and scared")
- 5-min horizon blindness
- Validation overfitting risk
- **See:** [03-datacamp-tutorial.md](./03-datacamp-tutorial.md), [09-mljar.md](./09-mljar.md)

### AutoResearch vs AutoML
- AutoML: random/evolutionary search, no memory
- AutoResearch: LLM-based, learns from prior experiments, internet access, structured hypotheses
- **See:** [02-fortune-article.md](./02-fortune-article.md)

### Broader Philosophy (Agentic Engineering)
- Karpathy stopped writing code December 2025
- "Vibe coding" (2025) → "Agentic engineering" (2026)
- Human role: director/orchestrator, not implementer
- **See:** [05-nextbigfuture.md](./05-nextbigfuture.md), [07-pjfp-no-priors-interview.md](./07-pjfp-no-priors-interview.md)

### Generalizing the Pattern
- Works for any domain with automatic scoring: search ranking, fraud scoring, CI optimization, etc.
- **See:** [06-shopify-engineering.md](./06-shopify-engineering.md)

---

## Suggested Article Angle

The brief asks for a **deep dive for advanced AI engineers / engineering managers** — not a conceptual overview. The DataCamp reference article is too high-level.

Recommended structure:
1. **What it is** — not just "AI runs experiments," but the specific three-file contract and *why* those constraints matter
2. **The ratchet loop in detail** — all 9 steps, the git-as-experiment-log insight, val_bpb as the yardstick
3. **What it actually found** — structural code changes (QKNorm, value embeddings), not hyperparameter tweaks
4. **Limitations that engineers need to know** — the creativity ceiling, RLHF conservatism, overfitting to val set
5. **Generalizing the pattern** — Shopify's results prove this is an engineering pattern, not just an ML tool
6. **Where this fits in the agentic engineering landscape** — Karpathy's broader vision, AlphaEvolve, Claude Code as orchestrator

---

## Target Keywords (from Brief)

AutoResearch, Andrej Karpathy, AI agents, ML experiments, agentic engineering, autonomous research, LLM, AI agents, machine learning, automation, `program.md`, `train.py`, `prepare.py`, ratchet loop, validation loss, `val_bpb`, Git-based experiment tracking, automated ML research, GPU experiments, hyperparameter optimization, AutoML vs AutoResearch, AlphaEvolve, coding agents, Claude Code, agents orchestration, iterative model improvement, NAS, RLHF, evolutionary search, ML workflow automation
