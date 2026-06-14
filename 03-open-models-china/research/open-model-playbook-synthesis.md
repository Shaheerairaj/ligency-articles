# Research Synthesis — "The Open Model Playbook"

*Built from the deep-research workflow corpus (24 sources, 38 adversarially-verified claims: 31 upheld at high confidence, 7 refuted). Workflow was still running when this was assembled, so this is the verified-claims layer, not the workflow's own final write-up. Raw corpus: `research/raw-corpus.md`.*

**As of: mid-2026 (≈ June 9, 2026).** All version numbers below are the *current* mid-2026 releases — they correct several stale assumptions in the original brief (see "Brief corrections" at the end).

---

## ⚠️ Read first — claims the verification pass KILLED (do not put these in the draft)

1. **Qwen3.7 Max is NOT an open-weight model.** It is proprietary/API-only — Artificial Analysis's own page says "Qwen3.7 Max is proprietary. The model weights are not publicly available." The true open-weight frontier on the AA Intelligence Index is **54** (Kimi K2.6, Xiaomi MiMo-V2.5-Pro), **not 57**. Anchoring "best open model" on Qwen3.7 Max at 57 would distort the whole thesis. (Refuted verdicts 11, 17)
2. **Do NOT use Kimi K2.6 as an example of "incomplete / weights-only open."** K2.6 is one of the *most* complete open releases there is — Modified MIT license, full weights on HF (~2.88M downloads/mo), full architecture card. The thin *marketing* blog isn't the release. Using it to illustrate "fake open" is backwards. (Refuted verdicts 6, 19, 23) — use **MiniMax M3** for that point instead (see §2).
3. **"US open models lag far behind" is cherry-picked and false as stated.** That gap (14–33 vs 51–57) pairs Meta's *oldest* models against the strongest Chinese ones. The real current US open leader is **Nvidia Nemotron 3 Ultra (~48)**, trailing the Chinese open frontier (~54) by **single digits**, not a chasm. Frame it as "trails narrowly," not "far behind." (Refuted verdict 14)
4. **"DeepSeek + Qwen are consolidating the market" is a 2025 snapshot.** Mid-2026 reality is *fragmentation* across ~10 serious Chinese labs (Xiaomi, Alibaba, MiniMax, Zhipu, Moonshot, DeepSeek, StepFun…). Only cite the consolidation framing if explicitly dated to 2025 and contrasted with the 2026 fragmentation. This is exactly the "old facts" the brief warns against. (Refuted verdict 31)

**Two numbers to handle carefully (upheld, but easy to misuse):**
- **"80% of US startups use Chinese base models"** (USCC/a16z) — the a16z partner (Martin Casado) actually meant 80% *of the ~20–30% of startups that use open source*, i.e. roughly **16–24% of all** US startups. Present with that qualifier. (Verdict 38)
- **HF "downloads" vs "likes"** are different vanity metrics inflated by derivatives. **Qwen leads downloads** (~1B cumulative); **DeepSeek-R1 leads all-time likes.** Don't conflate either with real usage. (Verdicts 33–35)

---

## §1 — Core thesis: open weights as a real alternative, with a stable gap

- The open-vs-closed capability gap has **narrowed to a stable ~6-month lag, not closed.** Lambert: "the ~6-month gap is holding steady" and is *not* meaningfully shrinking despite the recurring "open models are catching up" narrative. (V — Interconnects "Open models in perpetual catch-up", 2026-02-17)
- Concrete mid-2026 proof of the gap's *size*: top open-weight model **Kimi K2.6 = 54** on the Artificial Analysis Intelligence Index vs **Claude Opus 4.8 = 61 / GPT-5.5 = 60** → a **6–7 point** gap. (At K2.6's April launch the gap was only ~3 points vs the then-leaders at 57; the closed frontier then advanced.) (Verdicts 7, 8, 13 — AA leaderboard, primary)
- The reliability/real-world gap is bigger than the benchmark gap: open models are **"jagged"** in real use — you'd need several to cover what one closed model does. (V21) And the headline hallucination spread is stark: **DeepSeek V4 Pro 94% on AA-Omniscience vs Claude Opus 4.7 36%** (V — source 3). Kimi K2.6 cut its hallucination rate to ~39% (from K2.5's 64.6%), approaching Opus's ~36% — so it's narrowing, unevenly. (V — source 5)
- *Why* open stays behind: top open builders **distill on the strongest available closed APIs**, so closed labs keep defining the frontier. (V21)
- Stanford HAI is quoted (via NPR/AP, 2026-04-24) saying the **US-China gap "has effectively closed"** on top models — useful as a provocative counterpoint, but it's about national capability, not open-vs-closed. (V — source 24)

## §2 — Honest assessment: advantages vs disadvantages

**Advantages (verified):**
- **Cost / price pressure:** DeepSeek V4-Pro at **$3.48/M output tokens** vs OpenAI ~$30 and Anthropic ~$25 — and a V4-Flash tier at **$0.28/M**. (V1, V — source 1) MiniMax M3 launched at ~1/10 the cost of Claude Opus 4.7. (V — source 19)
- **Customization / sovereignty / adoption:** ~**16–24% of US startups** (see caveat) build on Chinese base models; **Airbnb uses Qwen** for support chatbots; **Singapore chose Qwen over Llama**, **Malaysia's sovereign stack runs on DeepSeek**. (V38, V — source 14) Cursor (Anysphere) built a product on Moonshot's Kimi. (V — source 24)
- **Fast diffusion / ecosystem:** Qwen has **113,000+ derivative models** on HF — more than Google + Meta combined. (V28, V32)

**Disadvantages (verified):**
- **"Open" is often weights-only, not truly open.** In 2025, weights-only models **surpassed truly-open (data-transparent) models for the first time**; share of downloads with disclosed training data fell from **79.3% (2022) → 39% (2025)**. (V20, V21, V30 — arXiv 2512.03073) DeepSeek-R1 ships weights + partial code under MIT but no training data/methodology. (V — source 22, arXiv 2502.18505)
- **Benchmark chasing / unverified claims — use MiniMax M3 as the case study:** M3 self-reported **59.0% SWE-Bench Pro** (claiming to beat GPT-5.5) but *every figure was run on MiniMax's own infrastructure*, independent evals (AA, LMArena) were pending, and **the promised open weights weren't released at launch.** Claude Opus 4.8 actually beats it 69.2% vs 59.0%; M3 compared against the *older* Opus 4.7 to hide the gap. (V — source 19) Lambert also notes Chinese labs optimize "slightly more for benchmark scores." (V — source 11)
- **Serving-quality variance & hardware walls:** GLM-5 needs ≥8 H200/H20 GPUs (~1.5TB in BF16); Kimi K2 docs recommend 16-GPU clusters, **node cost often >$400k**. Self-hosted inference is frequently *more* expensive than the API due to low GPU utilization. (V — source 23)
- **Safety risk shifts to the user:** open-weight safety is **domain-dependent and framing-sensitive** — compliance with harmful requests ranged **14.7%→85.7% (a 71-point span)**, and models flag a request as harmful yet comply anyway ("hypocrisy" up to 79%). ⚠️ **Caveat: this study tested small models (12–70B), NOT the frontier Chinese labs** — don't over-generalize to DeepSeek V4 / Kimi. (V36 — arXiv 2606.04035) Also: Chinese models carry **content-moderation aligned to government policy.** (V — source 22)
- **Business sustainability unclear:** see §8.

## §3 — Major breakthroughs from Chinese labs (current mid-2026 versions)

- **DeepSeek V4** (Apr 2026): ~1.6T params, 1M-token context, **MIT-licensed**. V4-Pro trails GPT-5.4 / Gemini 3.1 Pro by ~3–6 months per its own report; AA Intelligence Index **52**. First DeepSeek trained/optimized for **Huawei Ascend** (see §5). Notable: DeepSeek **"admits it can't currently serve V4-Pro to most customers — it lacks the chips."** (V1, V — sources 1, 2)
- **Qwen / Alibaba — the ecosystem king:** 113,000+ derivatives, ~1B cumulative downloads, plurality of HF. **But the current flagship Qwen3.7 Max is CLOSED** (only smaller 27B/35B tiers slated open) — itself evidence of the monetization squeeze. (V28, V32, V11)
- **Moonshot / Kimi K2.6** (Apr 20, 2026): 1T-param MoE, 32B active, native multimodal/agentic, **Modified MIT, self-hostable**. **Top open-weight model at AA Index 54.** Agentic coding: Terminal-Bench 2.0 **66.7**, SWE-Bench Pro **58.6** (edges GPT-5.4's 57.7 *on Moonshot's harness* — harness-dependent, flag it). Agent-swarm mode up to 300 parallel subagents. (V1, V2, V9, V12 — caveat in V1: harness-dependent)
- **Zhipu / Z.ai GLM-5** (Feb 11, 2026): 744B-total/40B-active MoE, 28.5T tokens, **trained entirely on Huawei Ascend, no CUDA**, integrates DeepSeek Sparse Attention. SWE-bench Verified **77.8%**. GLM-5.1 at AA Index 51. (V — source 6)
- **Xiaomi MiMo-V2.5-Pro:** ties Kimi at **AA Index 54** — the surprise co-leader of the open-weight frontier. (V3, V — source 7)
- **MiniMax:** M3 coding model (see §2 — frontier claims, unverified at launch); Jan 2026 HK IPO doubled day one. (V — sources 15, 19)
- **Huawei + DeepSeek direction:** see §5.

## §4 — The Chinese open-model playbook (distribution-as-strategy)

- **Open release = free advertising + a chip-export workaround:** releasing openly "accelerates the cycle of external feedback that compensates for constrained compute." (V — source 22, MIT Tech Review, USCC "Two Loops")
- **Undercut on price:** the V4 / M3 / Kimi pricing above; an explicit "race to the bottom" on API sales, with **cloud as the real revenue engine** behind loss-leader weights. (V — AIProem)
- **Day-one ecosystem support** (HF, vLLM, OpenRouter, coding tools, local formats) is the moat — devs build products "without negotiating with a US gatekeeper." (V — source 22)
- **Result — usage dominance:** Chinese open models = **~45%+ of OpenRouter token volume** (from <2% a year earlier); **61% of the top-10 OpenRouter slice** in late Feb 2026; **41% plurality of HF downloads** (year ending ~Feb 2026), China surpassing the US. (V26, V27, V29; V — source 3) ⚠️ The 61% is the *top-10 slice*, not the whole platform; a 100T-token study put the Chinese open share at ~30% of total weekly volume mid-2025 with Western *proprietary* still ~70% of global API share. (V — source 3)
- **USCC "Two Loops" framing:** open releases are deliberate **state-aligned industrial policy** — a "self-reinforcing competitive advantage." (V37, V38 — USCC, primary)

## §5 — Current & upcoming news angle (the "now")

- **Chip independence is the headline shift:** DeepSeek **V4 optimized for Huawei Ascend inference, reportedly at Beijing's direction** (73% inference-compute and 90% KV-cache reductions claimed); Huawei announced "full Ascend support." GLM-5 trained entirely on Ascend. *Tension:* US officials assert V4 was still **trained on smuggled Nvidia Blackwell**, and DeepSeek can't yet serve V4-Pro at scale for lack of chips. (V — sources 1, 2, 6; CFR, Fortune)
- **US policy reaction is escalating and concrete:** White House science adviser **Michael Kratsios's Apr 23, 2026 memo** accuses China-"principally based" entities of "industrial-scale" distillation; a **bipartisan House Foreign Affairs bill** would identify and sanction model-distillation actors; April 29 House joint investigation into Moonshot, MiniMax, Alibaba, DeepSeek. Anthropic (Feb 2026) and OpenAI allege DeepSeek ran distillation via **24,000+ fake accounts / 16M+ interactions.** (V — sources 3, 24; NPR/AP)
- **Data-risk / National Intelligence Law** angle: Chinese firms legally must "support, assist, cooperate" with state intelligence — the core enterprise-trust objection. (V — source 3)
- **Next phase = agents, coding, long-context, on-prem, physical AI** (the "two loops" physical-deployment data loop that export controls don't touch). (V — source 16 long-context; USCC two-loops)

## §6 — Fair assessment of the best open models (mid-2026, corrected)

- **Open-weight frontier (AA Intelligence Index):** Kimi K2.6 **54** = Xiaomi MiMo-V2.5-Pro **54** > DeepSeek V4 Pro **52** > GLM-5.1 **51**. (Closed leaders: Opus 4.8 = 61, GPT-5.5 = 60.) **Do not list Qwen3.7 Max (57) here — it's closed.** (V3, V7, V15 — note V15 correction: Chinese open range is ~52–54, not "51–57")
- **BenchLM composite** (different methodology, Mar/Apr 2026): DeepSeek V4 Pro/Max **87** > Kimi K2.6 **84** > GLM-5/5.1 **83** > Qwen3.5 397B **79**; best Chinese open trails the 93-point proprietary leader by ~6. Xiaomi MiMo mid-tier (~63). (V — source 8)
- **Best ecosystem:** Qwen, decisively (breadth + 113k derivatives). (V28, V32)
- **Most historic breakthrough:** DeepSeek-R1 — now the **most-liked model in HF history**, displacing Llama. (V33, V34, V35)
- **Best for practical adoption:** the cheap/stable/well-served/permissively-licensed model, not the top-benchmark one. (V — source 8) + the explicit caveat that **rankings shift on a 72-hour window** and provider implementation changes results. (V — source 7)
- **Chinese labs hold ~4 of top-5 open slots — but they're 4 *different* labs** leading different dimensions (GLM=benchmarks, Kimi=agentic, DeepSeek=price, Qwen=breadth). Breadth, not a duopoly. (V25, V31)

## §7 — US open-model trend (corrected: "trails narrowly," not "collapsed")

- **Llama's faded leadership:** "The soul of the Llama series died by not releasing enough models frequently enough." Llama 4 (Apr 2025) was "one of the weirdest releases of the year" — its headline LMArena ELO 1417 came from an **unreleased, arena-tuned Maverick variant** ("The results below are fake"). Llama is "no longer the open standard." (V — sources 10; Aug 2025: top-10 LMArena open models *all* Chinese.) (V — source 9)
- **OpenAI gpt-oss return** (Aug 2025): gpt-oss-120b + 20b, **Apache 2.0**, MoE, day-one ecosystem support; 120b ~o4-mini parity on one 80GB GPU. AA Index 33. (V10, V — source 13) Positioned as a *complement* to closed APIs, not a Llama-style default. (V — source 23)
- **Current US open leader = Nvidia Nemotron 3 Ultra** (Jun 4, 2026): 550B/55B MoE, **AA Index ~48** — highest of any US open model, ahead of Gemma 4 31B (39) and gpt-oss-120b (33), and ~parity with DeepSeek V4 Flash on GDPval — but **trails the Chinese open frontier (54) by single digits.** (V — source 12) Nvidia reportedly committing ~$26B to open-weight models (WIRED).
- **Players to watch:** Ai2/OLMo 3, Nvidia/Nemotron 3, Google/Gemma 4 (Apache 2.0, "a wild success" per Lambert), Arcee, Reflection, IBM Granite. (V — source 11)
- **ATOM Project:** Lambert's proposal to keep ≥1 US lab training open models on **10,000+ leading-edge GPUs**; matured from the "American DeepSeek Project" after summer-2025 when Chinese models overtook the US open lead. Defines "truly open" = open data + training code, not just weights. (V — source 9; WIRED "US needs an open-source intervention")
- **Likely US future = hybrid:** useful open models for ecosystem influence, frontier kept closed. (V — source 11)

## §8 — Conclusion: distribution strategy + fragile economics

- **The model is the marketing, the benchmark is the launch event, the ecosystem is the moat, cheap inference is the adoption engine** — and the race "will largely be a game of **economic staying power and fast-following**, until the market structure constricts." (V — source 11)
- **Fragility is already visible:** Lambert bets **Chinese open-weight labs hit funding difficulties first — possibly by late 2026.** Alibaba/Qwen and Z.ai have begun releasing some models **closed-first and hiking prices** (Reuters "open-source dilemma"); Qwen3.7 Max being closed is the proof point. China's hypercompetitive market makes monetization hard; game theory says **as long as one frontier lab stays open, the others can't permanently close.** (V — source 11; Reuters Mar 25; AIProem)
- **The open question:** does open become a permanent parallel stack, or stay a fast-following layer beneath the closed frontier? Economics, regulation, safety, and monetization all pull toward the latter.

---

## Brief corrections (version/date fixes vs the original brief)

| Brief said | Mid-2026 reality |
|---|---|
| "Qwen3 / Qwen3-Coder" as flagship | Current flagship is **Qwen3.7 Max — and it's CLOSED**; open tier is smaller variants |
| "Kimi K2 / K2.6" | **K2.6** is current and is the **#1 open-weight model (AA 54)** |
| "GLM-5" upcoming | **GLM-5 already shipped Feb 11, 2026**; GLM-5.1 out (AA 51) |
| "DeepSeek R1/V4" | **V4 shipped Apr 2026** (MIT, 1.6T, Ascend-optimized); R1 now legacy/most-liked |
| Xiaomi/MiMo "rising" | **MiMo-V2.5-Pro ties for #1 open-weight (AA 54)** — co-leader, not fringe |
| US "Ai2/Nvidia/Gemma to watch" | **Nemotron 3 Ultra (Jun 4, 2026) is the current US open leader (~48)** |

## Source quality note
Strongest anchors: Artificial Analysis (primary leaderboard), arXiv 2512.03073 & 2606.04035 (peer-style), HF Spring 2026 report (first-party), USCC "Two Loops" (govt), Interconnects/Lambert (the brief's canonical voice). Reuters/Fortune/CFR/NPR for news. Treat single-source vendor benchmarks (MiniMax M3, launch-day Kimi numbers) as **self-reported** until AA/LMArena confirm.
