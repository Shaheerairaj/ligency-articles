# Research Index: The Open Model Playbook

**Article Brief:** [Notion](https://app.notion.com/p/3731b721b66d8176ad4dcefb646ddffa) · local copy: [`../references/article-brief.md`](../references/article-brief.md)
**Status:** Researching
**Deadline:** 2026-06-15
**Target Audience:** Mixed / general technical
**Word Count:** 2,500–4,000 words
**Technical Depth:** Deep dive

---

## How this research was produced

A deep-research workflow fanned out across 5 angles, fetched 24 sources, and ran 38 falsifiable claims through 3-vote adversarial verification (**31 upheld at high confidence, 7 refuted**). Two working files:

| File | What it is |
|------|-----------|
| [`open-model-playbook-synthesis.md`](./open-model-playbook-synthesis.md) | **Start here.** Verified findings organized by the brief's 8 sections, with citations, the 7 killed claims flagged, and a "brief corrections" table for stale version numbers. Draft from this. |
| [`raw-corpus.md`](./raw-corpus.md) | The complete unprocessed corpus — every source, extracted claim, and adversarial verdict. Reference when you need the exact quote or verdict reasoning. |

> Note: the workflow was stopped before it wrote its own final report (we had enough verified material). The synthesis is the human-assembled verified-claims layer, not the workflow's auto-summary.

---

## Four claims the verification pass KILLED — do not put these in the draft

1. **Qwen3.7 Max is closed, not open-weight.** True open-weight frontier on AA Intelligence Index is **54** (Kimi K2.6, Xiaomi MiMo), not 57.
2. **Kimi K2.6 is NOT a "fake open / weights-only" example** — it's one of the most complete open releases. Use **MiniMax M3** for that point instead.
3. **"US open models lag far behind" is cherry-picked** — Nvidia Nemotron 3 Ultra (~48) trails the Chinese frontier (~54) by single digits.
4. **"DeepSeek + Qwen consolidation" is a 2025 snapshot** — mid-2026 is fragmented across ~10 labs. (Exactly the "old facts" the brief warns against.)

Two upheld-but-easy-to-misuse numbers: the "80% of US startups" stat really means ~16–24% of all startups; HF "downloads" (Qwen leads) ≠ "likes" (DeepSeek-R1 leads) ≠ real usage. See synthesis for both.

---

## Key sources by section
- **Benchmarks / rankings:** Artificial Analysis leaderboard (primary), BenchLM, deeplearning.ai The Batch
- **Ecosystem / adoption data:** HF "State of Open Source Spring 2026", arXiv 2512.03073 (Economies of Open Intelligence), ATOM Report (arXiv 2604.07190)
- **Strategy / economics:** Interconnects/Nathan Lambert (the brief's canonical voice), AIProem, MIT Tech Review
- **Geopolitics / chips / policy:** USCC "Two Loops", CFR, Fortune, Reuters, NPR/AP, WIRED
- **Skeptical / safety:** arXiv 2606.04035 (Unpredictable Safety), arXiv 2502.18505 (transparency), TowardsAI
- **Model primaries:** kimi.com (K2.6), Qwen blog, OpenAI gpt-oss, GLM-5 writeups
