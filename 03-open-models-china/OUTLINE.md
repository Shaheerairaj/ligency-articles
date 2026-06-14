# Outline: The Open Model Playbook

*Maps the brief's 8 sections onto a piece that argues one thing: open releases are a distribution strategy, and the verified mid-2026 numbers are the evidence. All facts/citations live in [`research/open-model-playbook-synthesis.md`](./research/open-model-playbook-synthesis.md); the four killed claims and the brief's stale version numbers are corrected there. Word count is not a constraint — depth over economy.*

**TL;DR / Key takeaways** (bullet list at the top) — 5–6 bullets a skimming reader can act on: the gap is real but ~6 months and steady; open wins on cost/control not reliability; pick by job (price/agentic/ecosystem/on-prem); Chinese labs lead usage but the economics are fragile; the US trails by single digits, not a chasm.

**Table of contents**

---

## 1. The race everyone is misreading

The story isn't "China caught up." It's that Chinese labs turned open weights into a way to win distribution while the closed frontier stayed ahead on the things that are hard to benchmark — reliability, tool use, assistant robustness, product polish. Set the frame and the one number that proves the gap is real but narrow: the top open-weight model (Kimi K2.6) sits at 54 on the Artificial Analysis Intelligence Index, the closed leaders (Claude Opus 4.8 = 61, GPT-5.5 = 60) at 60–61. A 6–7 point, roughly six-month gap that is holding steady, not closing. Reinforce with the reliability spread that benchmarks hide: hallucination rates (DeepSeek V4 Pro 94% on AA-Omniscience vs Opus 4.7 36%; K2.6 narrowed to ~39%) and the "jagged" point — you'd need several open models to cover what one closed model does. Mention DeepSeek as the spark, then move past it — the rest of the piece is about now.

*Keywords: open models, open-weight LLMs, open models vs closed models, frontier AI, are open models catching up with closed AI models.*

## 2. What you actually get, and give up, with open weights

The honest ledger. Advantages with real numbers: DeepSeek V4 at $3.48/M output tokens (V4-Flash at $0.28/M) vs ~$25–30 for the US labs; Qwen running Airbnb's support; Singapore choosing Qwen over Llama and Malaysia's sovereign stack on DeepSeek; Qwen's 113k derivatives as the fast-diffusion proof. Disadvantages with the same rigor: "open" usually means weights-only (the data-transparent share of downloads fell 79% → 39% from 2022 to 2025, and weights-only models overtook truly-open ones); benchmark claims that don't survive an independent harness (MiniMax M3 as the case study — frontier claims on its own infra, compared against the older Opus 4.7, weights not even out at launch); hardware walls (GLM-5 needs ≥8 H200s, ~$400k nodes, self-hosting often costs more than the API); safety and compliance that shift to whoever deploys, plus content moderation aligned to government policy. One commitment: open weights buy you cost and control, not a free lunch on reliability.

*Keywords: advantages and disadvantages of open AI models, open-weight models for enterprise AI, open-source AI models, open-source AI and geopolitics. Define open-weight vs open-source here on first use.*

## 3. The labs, and what each one actually shipped

The capability tour — what's *new and notable* per lab, not the ranking (that's section 6). Versions corrected from the brief. For each: architecture, license, and the one thing that makes it interesting.
- **DeepSeek V4** (Apr 2026): ~1.6T params, 1M context, MIT, first DeepSeek optimized for Huawei Ascend; the candid "we can't serve V4-Pro at scale, we lack the chips" admission.
- **Kimi K2.6** (Moonshot): 1T-param MoE, 32B active, native multimodal/agentic, Modified MIT, agent-swarm mode up to 300 parallel subagents.
- **Qwen / Alibaba**: the ecosystem itself — 113k derivatives, ~1B cumulative downloads — but the Qwen3.7 Max flagship went *closed* (foreshadows section 8).
- **GLM-5** (Zhipu/Z.ai, Feb 2026): 744B/40B MoE trained *entirely on Huawei Ascend, no CUDA*, integrates DeepSeek Sparse Attention.
- **Xiaomi MiMo-V2.5-Pro**: the surprise co-leader of the open frontier — proof it's no longer a one- or two-lab story.
- **MiniMax M3**: coding focus, the Jan 2026 HK IPO — and the benchmark-theater cautionary tale from section 2.
The commitment: fragmentation across ~10 serious labs, not a DeepSeek/Qwen duopoly (that framing is a dead 2025 snapshot).

*Keywords: Chinese AI labs, China AI models, DeepSeek V4, Qwen3-Coder, Kimi K2.6, GLM-5, Xiaomi MiMo, MiniMax. Subhead candidate: "why DeepSeek changed the open model race."*

## 4. The playbook itself

The center of gravity. Name the moves, in order: release fast and often, optimize for benchmark visibility, ship with day-one ecosystem support (HF, vLLM, OpenRouter, coding tools, local formats), price below the closed labs, build the tooling, monetize through cloud later. Tie it to the result: Chinese open models at ~45% of OpenRouter token volume (from <2% a year earlier), 41% plurality of Hugging Face downloads — with the honest caveat that the "61%" figure is the top-10 slice, not the whole platform, and proprietary still holds ~70% of global API share. Frame open release as both free advertising and a chip-export workaround (the USCC "two loops" framing — openness as state-aligned industrial policy that turns external feedback into a substitute for constrained compute). One commitment: the model is the marketing.

*Keywords: the Chinese open-model playbook, why Chinese open-source AI models are gaining ground, Chinese AI models on Hugging Face, Chinese AI models on OpenRouter, open AI model leaderboard.*

## 5. What's happening right now

The news section — kept current and tight so it doesn't crowd the buying-decision sections. Three beats:
- **Chip independence** (the headline shift): DeepSeek V4 and GLM-5 on Huawei Ascend, claimed 73% inference-compute / 90% KV-cache reductions; the tension that V4 was reportedly still *trained* on smuggled Nvidia Blackwell and can't yet be served at scale.
- **The trust objection that affects a buying decision**: China's National Intelligence Law (firms must "support, assist, cooperate" with state intelligence) — the core enterprise blocker.
- **The US policy reaction** (color, kept brief): the Kratsios Apr 2026 distillation memo, the bipartisan House bill, the 24,000-fake-accounts distillation allegations.
Then the forward look: the next phase is agents, coding, long-context, on-prem, and physical AI — the "two loops" deployment data that export controls can't touch — not chatbots.

*Keywords: DeepSeek and Huawei AI chips, open models for on-premise AI deployment, local AI models for companies, open-source AI and geopolitics.*

## 6. Which open model should you actually use

The decision artifact — the section the target reader came for. Lead with the corrected leaderboard (open frontier 52–54: Kimi K2.6 54 = Xiaomi MiMo 54 > DeepSeek V4 Pro 52 > GLM-5.1 51; closed Opus 4.8 = 61, GPT-5.5 = 60; **do not list the closed Qwen3.7 Max as open**), then resolve it into a pick-by-job recommendation, which is the actually useful output:
- **Cheapest / highest-volume automation** → DeepSeek (price leader).
- **Agentic coding and tool use** → Kimi K2.6 (caveat: its SWE-Bench edge is on Moonshot's own harness — flag harness-dependence).
- **Breadth, sizes, modalities, fine-tuning** → Qwen, decisively (the ecosystem play).
- **Raw benchmark scores** → GLM-5.
- **Most historic** → DeepSeek-R1 (now the most-liked model in HF history).
- **Best for real adoption** → usually *not* the top-benchmark model; it's the cheap, stable, well-served, permissively-licensed one in the right size.
Close on the caveat that rankings move on a ~72-hour window and provider implementation (quantization, prompt format, tool-calling) changes the result — the same model is not the same model on two providers. The commitment: four different labs lead four different dimensions; there's no single "best."

*Keywords: best open AI models, best open-weight AI models in 2026, Qwen vs DeepSeek vs Kimi, open-source LLM benchmark comparison, open AI model leaderboard.*

## 7. Where the US open scene actually stands

Correct the "US collapsed" reflex — it trails narrowly, it didn't fold. Llama faded ("the soul of the Llama series died by not releasing enough models frequently enough"; Llama 4's fake arena-tuned ELO). gpt-oss (Aug 2025, Apache 2.0, 120b ~o4-mini on one 80GB GPU) was a real return but positioned as a *complement* to closed APIs, not a Llama-style default. The current US open leader is Nvidia Nemotron 3 Ultra at ~48 — trailing the Chinese frontier (54) by single digits, not a chasm. Players to watch: Ai2/OLMo 3, Nemotron 3, Google Gemma 4 (Apache 2.0, "a wild success" per Lambert), IBM Granite, Arcee, Reflection. The ATOM Project (Lambert's push to keep ≥1 US lab training truly-open models on 10k+ leading-edge GPUs, "truly open" = data + training code, not just weights) and the likely hybrid future: open for ecosystem influence, frontier kept closed.

*Keywords: U.S. open-source AI models, U.S. open-source AI strategy, Meta Llama 4, OpenAI gpt-oss (gpt-oss-120b/20b), Google Gemma, Nvidia Nemotron, Ai2 OLMo, ATOM Project. Name Nathan Lambert and Interconnects explicitly here.*

## 8. Why this might not last

The close, paying off section 1's frame. Open releases work as distribution, but the economics are fragile. Lambert's bet that Chinese open-weight labs hit funding trouble first, possibly by late 2026. Qwen3.7 Max going closed, Alibaba and Z.ai releasing some models closed-first and hiking prices — the squeeze is already bending the playbook. The game-theory note: as long as one frontier lab stays open, none can fully close. End on the real question, stated plainly — does open become a permanent parallel stack, or stay a fast-following layer beneath the closed frontier? Economics, regulation, safety, and the need to monetize all pull toward the latter.

*Keywords: future of open-source AI models, open models vs proprietary AI models, Nathan Lambert, Interconnects.*

---

**FAQ** at the bottom — long-tail SEO + the questions a buyer actually asks:
- What's the difference between open-weight and open-source AI models?
- Are Chinese open models safe to use in an enterprise? (National Intelligence Law, licensing, content moderation.)
- Which open model should I actually pick? (Points back to the section-6 pick-by-job table.)
- Can I run these models locally? (Hardware walls, the $400k-node reality, when the API is cheaper.)
- Will the open models stay open? (Points to section 8.)
- How do Chinese open models compare to US ones right now?

---

## Shape notes
- Section 4 (the playbook) is the center of gravity; section 1 sets the frame, 8 pays it off; section 6 is the reader's payoff.
- **Division of labor between 3 and 6:** section 3 is *what each lab shipped and why it's notable* (specs, license, the novel thing). Section 6 is *ranking and recommendation only* (the leaderboard + pick-by-job). Same labs, different jobs — don't repeat the AA Index numbers as the point in both; in 3 they're context, in 6 they're the ranking.
- Diagrams: (1) open vs closed Intelligence-Index gap over time (shows the ~6-month lag holding steady); (2) the playbook as a flow (release → ecosystem → price → adopt → monetize); (3) OpenRouter / HF download share shift, China vs US.
- Every model name carries its current version and one hard number on first mention.
- Keep the DeepSeek-phenomenon material to section 1 only — the brief is explicit about not dwelling on old facts.
- Watch the four killed claims (synthesis "read first"): Qwen3.7 Max is closed; don't use Kimi K2.6 as a "fake open" example (use MiniMax M3); the US trails by single digits not a chasm; the duopoly framing is dead. And qualify the "80% of US startups" stat as ~16–24% of all startups.
