# Article Outline: A Practical Guide to Andrej Karpathy's AutoResearch

**Working Title:** AutoResearch by the Line: A Code-First Walkthrough of Karpathy's Overnight Loop
**Brief:** [Notion](https://www.notion.so/35a1b721b66d813e962ee55a70b4033a)  
**Word Count:** 2,500–4,000 words  
**Target Audience:** Advanced AI engineers / Engineering managers  
**Deadline:** 2026-05-21  
**Research:** [/research/INDEX.md](./research/INDEX.md)


## Working Title options

1. Karpathy's AutoResearch, Read From The Repo
2. Three Files, One GPU, One Night: Inside Karpathy's AutoResearch
3. AutoResearch by the Line: A Code-First Walkthrough of Karpathy's Overnight Loop

---

## Section 1 — Introduction

The `autoresearch` repo is small enough to read cover to cover in an afternoon. About 1,100 lines of Python and Markdown across three files. Karpathy pushed it in March 2026. The repo collected 21,000 stars that weekend and spawned forks for MLX, Windows RTX, and AMD inside ten days.

The idea is pretty cool. Point a coding agent at the repo. Leave it overnight. Return to ~100 training experiments and a model a bit better on the last set than the one you went to sleep with.

The WAY this is done is the interesting part. The agent edits `train.py` and only `train.py`. The human edits `program.md` between runs. The third file, `prepare.py`, is locked for both parties. A single number, `val_bpb`, decides which experiments are actually determined a success.

[FIGURE 1: The three-file contract. Human writes program.md. Agent writes train.py. prepare.py stays locked. All three feed into val_bpb, the single score that decides what survives.]

That single number is the whole reason the loop works. Without it, the agent has no way to tell if its last edit made the model better or worse, and the overnight session turns into a long list of half-finished ideas. With it, the loop becomes a one-way ratchet. The word is borrowed from mechanics: a ratchet is the part inside a socket wrench that lets the handle turn one way and locks against turning back. Same idea here, implemented in git. Every edit becomes a `git commit`. If val_bpb drops, that commit stays on the branch and the next experiment starts from it. If it doesn't, the agent runs `git reset HEAD~1`, which deletes the commit and puts `train.py` back to exactly what it was before the edit. The branch only ever grows with commits that lowered the score. The result is about 12 experiments per hour on an H100, ~100 per night, ~700 over a long weekend.

Don't worry if you didn't understand all of that, we will dive into each one of these concepts in detail.

## Section 2 — What AutoResearch actually is

AutoResearch is basically a recipe that Karpathy came up with to automate machine learning experimentation using coding agents/LLMs.

The repo is three files. Two of them are quick to describe:

- **`prepare.py`** — immutable, the agent cannot touch it. 389 lines that handle the data, the tokenizer, and the scoring function. This is what makes results comparable across every run.
- **`train.py`** — the agent's sandbox. 630 lines containing the model, the optimizer, and the five-minute training loop. Architecture, hyperparameters, optimizer choice, batch size, sequence length: all fair game.

The third one, `program.md`, is what the human uses as a lever in this whole engagement. 114 lines of Markdown that lay out the experiment loop, the TSV schema, the "simpler is better" rule, and the NEVER STOP directive. The actual loop the agent reads is on lines 94-104:

```
LOOP FOREVER:
1. Look at the git state: the current branch/commit we're on
2. Tune `train.py` with an experimental idea by directly hacking the code.
3. git commit
4. Run the experiment: `uv run train.py > run.log 2>&1`
5. Read out the results: `grep "^val_bpb:\|^peak_vram_mb:" run.log`
6. If the grep output is empty, the run crashed. [...]
7. Record the results in the tsv
8. If val_bpb improved (lower), you "advance" the branch, keeping the git commit
9. If val_bpb is equal or worse, you git reset back to where you started
```

The human iterates and modifies `program.md`. The agent iterates and modifies `train.py`. In practice the loop reduces to five steps the agent does over and over again: edit `train.py`, `git commit`, run `uv run train.py > run.log 2>&1`, grep `val_bpb`, ratchet forward or `git reset HEAD~1`.

One might ask at this point how this is different to AutoML or NAS which are frameworks to also help automate ML training and experimentation. The short answer is bounded search. AutoML and NAS only search a predefined hyperparameter or architecture space; the space is fixed in advance and no code gets written. AlphaEvolve (Google DeepMind's 2025 system that evolves programs with an LLM in the loop) does write code. It asks the LLM for edits, scores each one against a target metric, and carries the best forward as the seed for the next round. The catch is that its search runs a parallel population against multiple objectives, not a single linear ratchet on one number. A generic coding agent session writes code freely, but has no grader. Nothing accumulates between turns.

AutoResearch is what you get when all three of those properties hold at once: the agent writes code, an immutable scorer (prepare.py) grades every change, and one strict metric decides what survives. The README quotes ~12 experiments per hour on an H100, ~100 per night. Karpathy's published two-day run logged ~700 experiments, retained ~20 changes, and cut training time on the depth-24 nanochat model (a long running project of his) by 11%.

## Section 3 — Why val_bpb specifically

val_bpb is the average number of bits the model needs to predict each byte of held-out text; lower means the model is a stronger predictor. It is a close cousin of perplexity and cross-entropy (the two most common ways to score a language model on a validation set during training) with one specific property that makes it the right score for an autonomous agent to optimize against. The number for this metric is computed in `prepare.py` in a six-line function called `evaluate_bpb`:

```python
def evaluate_bpb(model, tokenizer, batch_size):
    token_bytes = get_token_bytes(device="cuda")
    val_loader = make_dataloader(tokenizer, batch_size, MAX_SEQ_LEN, "val")
    steps = EVAL_TOKENS // (batch_size * MAX_SEQ_LEN)
    total_nats = 0.0
    total_bytes = 0
    for _ in range(steps):
        x, y, _ = next(val_loader)
        loss_flat = model(x, y, reduction='none').view(-1)
        y_flat = y.view(-1)
        nbytes = token_bytes[y_flat]
        mask = nbytes > 0
        total_nats += (loss_flat * mask).sum().item()
        total_bytes += nbytes.sum().item()
    return total_nats / (math.log(2) * total_bytes)
```

The function walks through the held-out validation set, asks the model "how surprised were you by this token?" for every token, and converts that surprise into bits.

Cross-entropy comes out in a unit called nats by default. Nats are just the natural-log version of bits, and dividing by ln(2) is how you convert one into the other (that is what `math.log(2)` is doing in the last line). The function then throws away special tokens, the ones whose byte length is zero, which is what the `mask` line is doing. The final return value divides total bits by total bytes of text. That ratio is what gets reported as val_bpb.

The reason for bytes specifically is that every other obvious choice can be gamed by the agent. Perplexity and raw cross-entropy both report information per token, and "token" is whatever the current tokenizer says it is so that isn't right. Shrink the vocab and tokens get longer; per-token loss rises even when the model's actual predictive quality is identical. Increase the vocab and the same metric falls without any real improvement.

Bits per byte anchors the score to the raw UTF-8 text, which stays the same no matter how the model eventually spits out that metric. The agent can rewrite the tokenizer, halve the model width, double the steps inside the 300-second budget, and the score still means what it meant before, because the denominator is the validation text itself. That property is what makes val_bpb safe to hand to an autonomous agent.

The general lesson for anyone trying to copy the pattern: the agent is allowed to rewrite the thing being measured, so the units of your metric have to be anchored to something the agent cannot edit. If the agent can move the score just by changing the code (rather than by making the code actually better), the ratchet is broken. With val_bpb, the agent can swap the tokenizer or rewrite the model, but it cannot change the raw bytes of the validation text in the denominator. That fixed reference point is what keeps every run comparable against each other.

Shopify is the obvious case in point. Tobi Lütke (Shopify's CEO) contributed 32 commits to fork the repo into pi-autoresearch, and Shopify Engineering has since pointed the same ratchet at non-ML problems: CI build speed (65% faster), Liquid rendering (53% faster), and unit-test runtime (300x faster). The equivalent of val_bpb in those domains is whatever score the agent's edits cannot quietly corrupt. Deciding that metric is the trickiest part of trying to apply AutoResearch to use cases where the metrics might not be as quantitative.

## Section 4 — Prompt engineering inside program.md

- Walk through the six directives that actually carry the loop: LOOP FOREVER (lines 94-104), simplicity criterion (line 37), NEVER STOP (line 112), redirect to run.log (line 99), TSV schema (lines 70-72), "edit train.py only" [CODE: program.md excerpts at each line range]
- For each directive, the specific failure mode if you remove it (drop simplicity → complexity stacks for fractional gains; drop NEVER STOP → agent pauses, human is asleep)
- Karpathy's own framing on why the prompt is intentionally minimal and "the human is the bottleneck" [QUOTE: interview/tweet source + citation]
- One before/after where a one-line program.md edit visibly changed agent behavior across a run [CODE: program.md diff + matching results.tsv rows]

## Section 5 — Code walkthrough of train.py

- The architecture skeleton: GPTConfig defaults (depth-12, 768 dim, 6 heads, 32K vocab) and the three building blocks (CausalSelfAttention, MLP, Block) [CODE: train.py:33-50 GPTConfig + class hierarchy]
- The Muon+AdamW split — 2D matrix params routed through Muon (with NorMuon variance reduction), everything else through fused AdamW [CODE: train.py:356 MuonAdamW class]
- The hyperparameters the agent edits most often (TOTAL_BATCH_SIZE, MATRIX_LR, EMBEDDING_LR, UNEMBEDDING_LR, WEIGHT_DECAY) and the 300-second TIME_BUDGET that caps every run [CODE: train.py:438-443]
- The three buckets of surviving edits (shape, optimizer, small architectural tweaks) with one real kept commit per bucket [CODE: three git diffs from Karpathy's run]

## Section 6 — Git mechanics of the ratchet

- The two-command selection mechanism: `git commit` to propose, `git reset HEAD~1` to discard on no improvement [CODE: real `git log --oneline` excerpt from an autoresearch branch]
- Branch naming convention (`autoresearch/<tag>`) and why results.tsv is deliberately untracked (program.md line 102) — otherwise reset would erase the agent's memory
- Two parallel logs working in tandem: branch commits = winners only, TSV = every attempt including crashes [DIAGRAM: branch timeline + matching TSV rows side-by-side]
- How crashes are recorded (`val_bpb=0.000000`, status `crash`) so dead-ends inform the agent without being re-tried [CODE: TSV excerpt showing crash row]

## Section 7 — The agent's decision loop in detail

- What the agent reads at iteration start: program.md (114 lines), current train.py (630 lines), results.tsv (one row per past experiment), cached prepare.py + README — roughly 15-25k tokens of grounding [DIAGRAM: stacked-bar context budget breakdown]
- Per-cycle additions are deliberately cheap: one diff, a 5-minute wait, a 4-line grep of run.log, one new TSV row
- The redirect rule (`> run.log 2>&1`) as the token firewall — a streamed training run would dump ~50k tokens per experiment into the context
- The real overnight bill: H100 rental ($16-24 for 8 hrs at ~$2-3/hr) is larger than the Sonnet API spend (tens of dollars) [DIAGRAM: cost stacked bar, GPU vs API]

## Section 8 — Reproducing a run end-to-end

- The two-command setup: `uv run prepare.py` once to build dataset + tokenizer cache, then `claude` from inside the repo with program.md as the opening message [CODE: terminal session transcript]
- Baseline numbers to expect on first run: ~5 minutes, val_bpb ≈ 0.997 on a fresh H100 (matches program.md's own example output)
- The staircase shape of Karpathy's published run: steep first hour of easy wins, long flat overnight, occasional late jumps from stitched-together near-misses [DIAGRAM: val_bpb vs experiment number staircase chart]
- Karpathy's headline numbers: ~700 experiments across two days, ~20 retained, 11% training-time cut on nanochat depth-24 [CODE: results.tsv excerpt showing kept rows]

## Section 9 — Comparison with code, not prose

- Side-by-side pseudocode of the two loops on one page [CODE: AutoResearch linear ratchet + AlphaEvolve population evolution, ~10 lines each]
- The four differences that matter: population size (1 vs N), metric (single number vs multi-objective tuple), selection (git reset vs diversity-preserving prune), infrastructure (~1.1K LOC harness vs coordinated cluster services)
- The decision rule for picking between them: one metric + one GPU → AutoResearch; multi-objective + a fleet → AlphaEvolve
- They are not competing tools — they target different problem shapes, and saying so honestly is more useful than ranking them [DIAGRAM: 2x2 matrix of metric count vs compute footprint]

## Section 10 — The creativity ceiling, mechanistically

- What the ceiling looks like in practice: the agent proposes in-distribution variants (LR sweeps, attention pattern tweaks) but never genuinely novel architectures — no Mamba, no state-space mixing, no replacement of softmax attention
- Two mechanistic hypotheses for why: RLHF penalizes "let me try something weird" during preference learning, and the simplicity criterion in program.md reinforces the same bias against radical changes
- A possible fix: a parallel exploration branch that runs without the simplicity rule and feeds back into main only when a clear winner emerges [DIAGRAM: two-branch loop, main ratchet + exploration ratchet]
- None of the three published forks (MLX, AMD, Windows RTX) have tried it — concrete weekend project for a reader who wants to push past the ceiling

