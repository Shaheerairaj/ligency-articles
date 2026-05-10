# Article Outline: A Practical Guide to Andrej Karpathy's AutoResearch

**Working Title:** The Machine That Outran Its Creator  
**Brief:** [Notion](https://www.notion.so/35a1b721b66d813e962ee55a70b4033a)  
**Word Count:** 2,500–4,000 words  
**Target Audience:** Advanced AI engineers / Engineering managers  
**Deadline:** 2026-05-21  
**Research:** [/research/INDEX.md](./research/INDEX.md)

---

## Throughline

Most of ML research is search, not creativity. Agents are better at search than humans. The only thing left that's irreducibly human is knowing what to search for.

---

## Section 1 — Open With the Punchline (~200 words)

**Don't explain AutoResearch. Start with the finding.**

Karpathy had been refining the same training code for two decades. He handed it to an agent for two days. The agent found something he'd missed — weight decay on value embeddings, an optimizer parameter he'd tuned by hand and gotten wrong. The agent fixed it.

No setup. No explanation yet. Just: the machine beat the expert at the expert's own game.

**Goal:** Force the reader to ask "how?" before explaining anything. Earn attention instead of assuming it.

---

## Section 2 — What Kind of Problem Is ML Research, Really? (~300 words)

**Reframe the field before introducing the tool.**

- Most ML research isn't creative — it's search: hypothesis → implement → measure → keep or discard → repeat
- Creativity lives only at the edges: picking the direction, knowing when a result is interesting
- AutoResearch didn't discover anything new about AI — it discovered something uncomfortable about research: most of the work is mechanical, and we've been doing it by hand
- Name the real claim of the article before the reader knows it's the claim

---

## Section 3 — The Recipe (Not the Tool) (~350 words)

**Introduce AutoResearch as a pattern, not a product.**

- Karpathy's own words: *"You don't use it directly, it's just a recipe/idea."*
- The nanochat origin: why starting from a Chinchilla-validated, proven training setup matters (the ratchet is only meaningful if the baseline is solid)
- Introduce the three-file contract as a **philosophy of constraints**, not an architecture:
  - `prepare.py` — locks the metric so you can't cheat the yardstick
  - `program.md` — locks the direction so the human stays in the loop on what matters
  - `train.py` — frees the implementation; everything else is the agent's problem
- The constraints aren't limitations — they're what make the system work

---

## Section 4 — The Ratchet (~450 words)

**Explain the mechanism as a story, not a list.**

- Tell it narratively: the agent wakes up, reads its own history, makes a bet, runs the clock, commits or erases, repeats — 700 times
- Two design decisions that deserve more attention than they usually get:
  - **Why git?** The commit history isn't just version control — it's the agent's long-term memory. Each commit is a data point. The agent reads its own history to know what direction to push next.
  - **Why exactly 5 minutes?** It puts speed improvements and convergence improvements on equal footing — a change that trains 20% faster gets the same shot as one that finds lower loss. The time window is the equalizer.
- `val_bpb` explained: why bits-per-byte and not raw loss (vocabulary-size-independent → fair across architectural changes)
- `results.tsv` as the agent's working memory — how early runs (broad exploration) differ from late runs (narrow refinement)

---

## Section 5 — What It Actually Found — and Why It's Surprising (~400 words)

**The credibility section. Be specific.**

- Not "it found improvements" — walk through the actual findings: QKNorm reordering, value embedding regularization, banded attention tuning
- These are structural code changes, not hyperparameter tweaks — the kind a human researcher would write a paper about
- The sharpest point: the agent found the weight decay mistake on value embeddings — code Karpathy had optimized by hand, looked at hundreds of times
- The agent didn't know it was supposed to be hard. It just measured.
- The result: depth-12 improvements transferred to depth-24 → time-to-GPT-2 cut from 2.02h → 1.80h (11% speedup)
- Uncomfortable implication: expertise creates blind spots. The agent had none.

---

## Section 6 — Here's Where It Breaks (~400 words)

**Don't bury the limitations. Lead with them.**

- Open strong: AutoResearch cannot take a step backward — no sacrificing today's val_bpb for a larger gain tomorrow. Every human researcher does this constantly. The agent cannot.
- The local search trap: agents cycle through minor variations of whatever worked last (GitHub Issue #22)
- The RLHF problem: the agent is "cagy and scared" — trained to be safe and conservative, it avoids the bold experiments that might fail spectacularly but teach you something
- The 5-minute blindness: improvements that only show up over longer runs are invisible
- The hardest limitation: **writing a good `program.md` requires having done the research yourself.** Fast iteration toward the wrong direction is just fast failure.
- This section is where you earn the trust of an advanced reader.

---

## Section 7 — It Was Never Really About ML (~350 words)

**The pivot. The boldest structural move.**

- Introduce Shopify not as a footnote but as the central reveal
- Shopify applied the three-file ratchet to CI build optimization: 65% faster builds, 300x faster unit tests, 53% faster render times — no model training involved
- The point: AutoResearch accidentally invented a general-purpose engineering pattern
- Any domain with fast feedback and a scoreable objective is a candidate: search ranking, fraud scoring, compiler optimization, intent classification
- Restate the three-file contract as a general principle: **lock the metric, define the direction, free the implementation**
- This isn't about LLMs. It's about the shape of problems that agents can solve.

---

## Section 8 — What This Means for You (~300 words)

**Address the engineering manager directly.**

- The shift from writing code to directing agents is already happening — AutoResearch is the most concrete version of it: a human writes 50 words of markdown, an agent writes 700 experiments worth of code
- The question for engineering managers isn't whether this pattern applies to their work — it's whether their teams know enough to write the `program.md`
- The agents can search. Only humans can decide what's worth finding.
- Karpathy's SETI@home vision: swarms of agents as a research community running asynchronously
- End on the warning Karpathy himself gave: if the next generation of engineers skips formative research work because agents handle it now, the field will have plenty of compute and no one to point it in the right direction. **The ratchet only moves in one direction. Make sure you know which direction that is.**

---

## Section 9 — Getting Started (~150 words)

Short and practical:
- Prerequisites: NVIDIA GPU (20+ GB VRAM), Python 3.10+, `uv`, a coding agent (Claude Code, Cursor)
- Setup in 4 lines:
  ```bash
  git clone https://github.com/karpathy/autoresearch.git
  cd autoresearch
  uv sync
  uv run prepare.py
  ```
- Open your agent, point it at `program.md`, walk away
- The one real piece of advice: **spend more time on `program.md` than you think you need to.** That file is the only thing between the agent and the wrong direction.
- For smaller hardware: TinyStories dataset, depth 4, vocab 256

---

## Section 10 — Key Takeaways / TL;DR

5–6 bullets. Required by brief. Write them to be genuinely useful, not SEO padding.

---

## Section 11 — FAQ

5–6 questions targeting search/GEO. Required by brief. Suggested questions:
- Is AutoResearch the same as AutoML?
- Do I need an H100 to use it?
- Can I apply AutoResearch outside of ML?
- Which coding agent works best?
- How do I write a good `program.md`?
- What's the difference between AutoResearch and AlphaEvolve?
