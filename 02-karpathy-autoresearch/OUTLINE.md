# Outline: A Practical Guide to Andrej Karpathy's AutoResearch

**TL;DR / Key takeaways** (bullet list at the top)

**Table of contents**

---

## 1. The claim worth checking

Open with what AutoResearch actually is at the level a friend would describe it: a small repo Karpathy published where you let a coding agent edit a model trainer in a loop, and the model gets better on its own. The point isn't that it produces a frontier model. The point is the proof of concept: *with the right recipe, an agent can incrementally improve a system without a human in the loop*. That's the interesting bit, and it's why this repo matters more than its size suggests. Frame the article as a walk through what that "right recipe" actually is.

## 2. The shape of the system, from 30,000 feet

Before any code, the reader should be able to picture the whole thing. Three files the human writes. One number the agent tries to push down. One mechanism that decides whether each change sticks. Introduce the names (program.md, train.py, prepare.py, val_bpb, the ratchet) but defer the mechanics. The goal of this section is: the reader can now hold the whole system in their head.

## 3. The one number that runs everything

Walk through val_bpb in plain language. What "bits per byte" means without assuming the reader remembers cross-entropy from a textbook. Why this specific measure is the right one when the agent might rewrite tokenization or the model itself. Short comparison to perplexity, which most readers will reach for first. The argument here: pick the wrong number and the whole loop breaks. AutoResearch's choice is not incidental. Be sure to give an example using another scenario so readers can picture what a similar metric can look like when trying to implement AutoResearch for a different system. This example is going to be repeated in the coming sections so each sections example will build on this idea.

## 4. The ratchet, which is the actual idea

This is the heart of the article. The "recipe" Karpathy refers to is mostly this: the agent proposes a change, the change runs, and git decides whether it lives. Improves val_bpb → commit. Doesn't → `git reset`. Walk through it concretely. Use git as the experiment store, not a database, not MLflow. That choice has consequences worth discussing. This section should make the reader say: oh, that's it? Yes, that's it. That's why it's interesting. Give an example here similar to section 3.

## 5. What the agent actually does in the loop

Now zoom in on the agent's side. What coding agents read at each iteration, what they edit, what kind of experiments it tends to propose, roughly what each run costs in tokens and GPU time. The reader should leave this section understanding the loop end-to-end: from the agent reading program.md to the next commit on the branch. Keep the code excerpts short and well-chosen. Again use analogies from the on-going example.

## 6. Where it works, where it stalls

Honest section. The system reliably finds small wins. It does not invent new architectures. Take a position on why: is the ceiling the model (RLHF flattens exploration) or the framework (program.md constrains the search to safe moves)? Then a short comparison to AutoML, NAS, and AlphaEvolve (briefly explain each in brackets), framed by mechanism rather than category. Which one would you reach for, and when.

## 7. Whether to wire it into your workflow

Closing section that pays off the implicit question the reader had on page one. When this is the right tool (you have a clean trainer, a well-chosen metric, and you want a system that explores while you sleep). When it isn't (you need creative leaps, or your metric is noisy, or your training run takes a week). Keep it short and committed.

---

**FAQ** at the bottom — five or so questions a reader will actually ask after finishing (cost per experiment, hardware, can you run it locally, does it work for non-LLM models, what about the creativity ceiling).

---

## Shape notes

- Sections 1–3 are gentle. Section 4 is the article's center of gravity. Sections 5–7 build on it.
- Each section is roughly 350–550 words. Section 4 gets the most space.
- Diagrams: one for the three-file contract (section 2), one for the ratchet flow (section 4), one comparing AutoResearch to AlphaEvolve as side-by-side pseudocode (section 6).
- Technical terms introduced only when needed, explained in a parenthetical the first time.
