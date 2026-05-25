# A Practical Guide to Andrej Karpathy's AutoResearch

## TL;DR

- AutoResearch is a small project from Andrej Karpathy built around one question: can an AI coding agent improve a machine learning model on its own, with nobody watching? You set it up once, point the agent at it, and walk away. When you come back the model trains a little better than it did when you left, and no human touched it in between.
- What's interesting is the setup around it. The agent keeps proposing tweaks to the training code, tests each one by actually running a short training session, and a strict rule throws out anything that doesn't make the model better. Karpathy calls that setup "the right recipe", and that one rule (keep what works and undo the rest) is a major part of what makes this setup work.
- Over a single night the agent tried 83 different ideas. Most went nowhere but 15 actually improved the model, each by a little. That's the repeating theme here, lots of attempts and a few small improvements which start adding up. It's good at the minor tunings a tired researcher stops noticing but the bigger creative leaps stay out of reach.
- It's worth a weekend if you already have a working training script, a single metric you trust, shorter running experiments (mins not hours), and a goal of squeezing out small wins instead of chasing a breakthrough.
- The real takeaway is the pattern instead of the repo. Give an agent strict boundaries, one number to obsess over improving, and a gate that rejects anything that doesn't push it. The agent is the cook. The recipe is everything you build around it.

## 1. The claim of autoresearch

A few months back Andrej Karpathy pushed a small repo called autoresearch. Maybe a thousand lines of Python, a markdown file, a training script. You point a coding agent at it, walk away for the afternoon, and when you come back the model trains better than it did when you left. Not by a lot. But better, every time, with no one touching the code.

Really think about the implications here. The model isn't getting better because a human sat down with it. There's no person in the loop after the initial push. The agent reads the trainer, proposes a change, runs the training, looks at the result, and either keeps the change or throws it away. Then it does it again, and again, and the validation loss creeps down on its own.

Karpathy calls this "the right recipe." and I think the framing is very well done here. He doesn't claim that LLMs have suddenly become research scientists. If you set up the surrounding system correctly, an agent that is NOT a research scientist can still produce real, measurable improvements to a real model. The recipe is the surrounding system. The repo itself is the recipe. He mentioned in an interview that the goal is not that this replaces researchers but rather the researchers are taken out of the loop of exhaustive training and experimentations and monitoring results.

That's what I want to walk through in this article. What the recipe actually is, why each piece exists, where it works, and where it stalls out. By the end you should be in a position to say whether wiring something like this into your own work is worth a weekend project, or whether the proof of concept is interesting on its own and that's where it ends for you.

We already know that agents are able to write code extremely well but this isn't what makes autoresearch so compelling. The interesting question that the repo is answering is what the scaffolding around the agent has to look like for the loop to go somewhere, and how much of the thinking a human has to do up front before they can hand the keys over.

By "go somewhere" I mean it sounds like, the loop actually improves the system over time without a human in the seat. Each iteration leaves the model a little better than the last. The agent doesn't spin in circles, doesn't propose junk that breaks training, doesn't need a person to come back and clean up the branch. That sounds like a low bar but it's the bit that a lot of agent demos that are marketed to improve system don't get right. Getting an agent to write a change is easy. Getting it to write changes that compound run after run is quite difficult and that's exactly what the scaffolding is doing in a very simple manner which is what all the buzz is about.

## 2. The shape of the system, from 30,000 feet

Before we go any further, you should be able to picture the whole thing, and the good news is the repo is not big. The moving parts can be counted on one hand, three files the human writes, one number the agent tries to push down, and one mechanism that decides whether a change stays or gets thrown out. That's basically it.

```
autoresearch/
├── program.md    ← the human's brief for the agent
├── prepare.py    ← data + the val_bpb yardstick (nobody edits this)
├── train.py      ← the trainer, the only file the agent edits
└── ...
```

The three files are `program.md`, `train.py`, and `prepare.py`, and the names give most of it away.

- `program.md` is a plain markdown document where the human describes what they want the agent to do, the constraints, the things it's allowed to touch, the things it is NOT allowed to touch. It reads almost like a brief you'd hand to a contractor.
- `train.py` is the actual training script, the model, the optimizer, the loop, the eval, all of it. Around 630 lines, and the file the agent spends most of its time inside, reading, editing, running, trying things.
- `prepare.py` handles the data side, mostly tokenization and the validation set. Unlike `train.py` the agent is locked out of this one, it's the fixed yardstick, the thing that makes sure `val_bpb` means the same thing on run 1 and run 100.

So that's the human side. You write `program.md`, you write `train.py` once in a state where it actually runs end to end, you set up `prepare.py` once to produce the data the trainer can chew on, and then you walk away.

The number the agent is chasing is `val_bpb`, short for validation bits per byte, and we'll spend a whole section on what this measure actually is and why this specific one matters, so don't worry about the details for now. Just know that it's a number, lower is better, the agent reads it from a file after each run, and that's the ONLY signal it uses to decide if a change worked. No vibes, no "this looks better," no second opinions. Just the number.

And then there's the ratchet, which is the thing that makes the whole loop work. After the agent makes a change and runs the training, one of two things happens. Either `val_bpb` went down, in which case the change gets committed to git and becomes the new baseline, or it didn't, in which case the change gets reset out of existence and the agent goes back to where it was before to try something else so we never commit to git failed runs, only runs which meaningfully made an improvement in our training. That's the entire mechanism, and we'll spend a lot of time on it later because it's where most of the cleverness lives.

That's the picture. Three files, one number, one git-backed accept-or-reject step. You can hold all of it in your head at once, which is more than what you can say for a lot of ML pipelines and repos, and is part of what makes the repo worth reading even if you never actually run it.

**[FIGURE 1 — placeholder]**

System architecture diagram showing the autoresearch loop end to end.

## 3. The one number that runs everything

OK so the agent is chasing one number, and it's worth knowing what that number actually is, because the choice of metric matters more than it looks.

`val_bpb` is two ideas stuck together, validation and bits per byte, so lets take them one at a time. Validation means the score of the model is measured on text the model never saw while training (a validation set). A model can memorize the text it trained on and look brilliant while having learned nothing general (what we call over-fitting in machine learning), so you hold a chunk of text back, never show it during training, and grade the model on that. We need to make sure this is done well so that the model can generalize and not over-fit to the training data. That held-back chunk is the validation set.

Now bits per byte. As the model reads the held-back text, at every position it outputs a probability for what the next token will be. The better the model, the higher the probability it puts on the token that actually comes next.

The score Karpathy is using in autoresearch is the number of bits needed to encode the true next token given the model's prediction. Here's what scoring a few tokens actually looks like:

```
Scoring the text "cat sat down", one token at a time.

  true token   model's guess   P(true token)   score (bits)
  cat          cat             0.90            0.15     confident and right, cheap
  sat          ran             0.0625          4.00     confident and WRONG, most expensive
  down         down            0.50            1.00     right but unsure, in between

  total bits = 0.15 + 4.00 + 1.00 = 5.15
  text size  = 12 bytes ("cat sat down")
  val_bpb    = 5.15 / 12 = 0.43
```

Average that over the whole validation set and you have `val_bpb`. The thing to notice is the middle row: one confident wrong call cost more than the other two tokens put together. For scale, blind guessing runs about 8 bits per byte and the published run sat near 1. Lower is always better.

Here is the complete equation:

```
val_bpb = -(1/B) × Σᵢ log₂ P(tᵢ | t₁ ... tᵢ₋₁)
```

This is just the worked example from above written in one line. The `log₂ P(tᵢ | t₁ ... tᵢ₋₁)` part is the score for a single token, the same numbers in the score column, and the minus sign out front flips it into a positive bit count. The Σ adds those up over every token, which is the total bits, and the 1/B divides by B, the total bytes of the validation text, the 12 in the example. tᵢ is just the i-th token. If the symbols don't mean much to you, no worries, the worked example above is the thing to hold onto.

Now the obvious question, why bits per BYTE and not bits per token, or plain cross-entropy, or perplexity which is what most training scripts spit out by default. Tokens are not a fixed unit, they depend entirely on the tokenizer. If your tokenizer has 50,000 entries a typical English word might be 1 or 2 tokens, but if it has 1,000 entries the same word might be 4 or 5. Your loss-per-token will look completely different on the same text. Compare two runs with different tokenizers using perplexity and you're comparing apples and oranges.

Bytes don't have this problem. A byte is a byte, UTF-8 encodes "the" as 3 bytes no matter what the tokenizer thinks of it. So bits-per-byte measures how well the model compresses the underlying text, not the abstract token stream the tokenizer happened to produce. The unit is universal.

Now you might be thinking, `prepare.py` is immutable, the agent can't change the tokenizer anyway, so does it really matter. And the answer is yes. First, it future-proofs the loop, the day you want to compare an autoresearch run against a different one, or against another model entirely, you can still put the numbers next to each other and trust them. Second, it closes off a category of cheating, the agent doesn't get rewarded for slicing input into easier pieces, only for actually understanding the text.

Pick the wrong metric and the whole loop wobbles. If the agent is chasing perplexity and accidentally finds a way to change tokenization, it scores "better" without the model actually being better. If it's chasing some hand-wavy "feels like a good model" signal, there's nothing to ratchet against. `val_bpb` is one of those choices that looks small in the README but the whole loop depends on it being right.

## 4. The ratchet, the meat of the system

Now we get to the bit that makes the whole thing work. Karpathy calls it "the right recipe" and most of the recipe is just this one mechanism. It's almost embarrassingly simple, which I think is part of what threw a lot of people off when the repo dropped, because the natural assumption with an "agent does ML research" demo is that there must be something clever happening under the hood. There isn't. The cleverness is in choosing not to do anything clever.

Here is what happens, in order, after the agent decides what to try next:

1. The agent edits `train.py`.
2. The agent commits the change to git, on a feature branch.
3. The agent runs the training for 5 minutes of wall-clock time, exactly.
4. The script writes the final `val_bpb` score into `results.tsv` along with the commit hash, GPU memory, and a short note on what was tried.
5. The agent reads `results.tsv` and compares the new `val_bpb` to the previous best.
6. If the new score is lower, the commit stays, the new state is the baseline, move on.
7. If the new score is not lower, the agent runs `git reset HEAD~1`, which throws the commit away and rewinds the working tree back to the previous state, move on.

In practice, the actual sequence of shell commands looks roughly like this:

```bash
# agent edits train.py
git add train.py
git commit -m "widen attention heads to 12"

# train for exactly 5 minutes
python train.py    # appends a row to results.tsv when done

# read the new val_bpb out of results.tsv
# if val_bpb went up vs baseline:
git reset HEAD~1   # the change is gone, like it never happened
# if val_bpb went down: do nothing, the commit becomes the new baseline
```

**[FIGURE 2 — placeholder]**

Ratchet decision flowchart, zoomed in on the accept-or-reject gate.

And `results.tsv` ends up looking something like this (columns: commit, `val_bpb`, GPU memory, status, description):

```
a1b2c3d  0.9979  42.1GB  PASS  baseline
e4f5g6h  0.9971  42.3GB  PASS  widen attention to 12 heads
i7j8k9l  0.9985  41.9GB  PASS  swap Muon for plain AdamW
m0n1o2p  -       -       FAIL  changed init scheme, NaN at step 800
```

That's the ratchet. Step 7 is the whole reason this works. The codebase can only move forward, because the only way a change survives is to actually beat the existing baseline on the metric. There is no "well, maybe this'll pay off later." There is no compromise. Improve `val_bpb` or get rolled back.

So a few things become interesting once you see this written out. First, git is not the version control system here, it is the experiment store. You can think of the entire history of an autoresearch run as a git log. Every commit on the branch is an experiment that won. You don't need MLflow, you don't need Weights & Biases, you don't need a database. The audit trail is `git log --oneline` and the data lake is `results.tsv`. That's all of it.

Second, the choice of git as the store has consequences. The agent reads its own commit history and `results.tsv` at the start of every iteration, so it isn't just running blind experiments, it is doing something closer to what a human researcher does, which is "look at what's worked recently, look at what hasn't, and pick the next experiment from there."

Third, the 5-minute fixed wall-clock budget is what keeps every experiment comparable to every other in the first place. Karpathy's reason for fixing it is that "changes that train faster and changes that converge lower are evaluated on equal footing." If you let the agent train longer when things looked promising, you'd introduce a confound, because longer training is sort of always better and the score would creep down for reasons unrelated to the agent's change. Pin the budget at exactly 5 minutes and the only variable that's allowed to move is `train.py`.

And then there is the failure handling, which is the kind of unglamorous engineering that decides whether the loop survives overnight. The PASS/FAIL column in `results.tsv` exists because `train.py` crashes sometimes. The agent makes a change, training NaNs out at step 800, no `val_bpb` gets produced. The system has to notice this, mark it FAIL in `results.tsv`, `git reset HEAD~1` the broken commit, and keep going. No human cleanup. Otherwise the loop stalls at 2am while you're asleep, which defeats the whole point.

The numbers on an initial overnight run, from the released stats, are 83 experiments and 15 improvements, with `val_bpb` going from 1.000 down to 0.975. So 15 out of 83 changes actually beat the existing baseline, the other 68 got reset back into the void. That ratio, roughly 1 in 5, is what the ratchet looks like in practice.

**[FIGURE 3 — placeholder]**

`val_bpb` staircase plot from Karpathy's overnight run.

For a sense of what the ratchet is actually finding, here is an example. In one of his earlier tests Karpathy ran the loop overnight against a small LLM training setup he had personally been refining for close to twenty years, and the system surfaced improvements even Karpathy had missed. Two specific ones come up in interviews, he was not applying weight decay to the value embeddings, and his optimizer parameters were under-tuned. Both the kind of small, mechanical things a tired human stops noticing after the hundredth pass over the same code. The ratchet does not get tired.

That's the entire mechanism. Three or four git commands, one log file, a 5-minute timer, and the simple rule that only winners get to commit. You can write the whole loop on a napkin, which is, I think, exactly what makes it interesting. The "right recipe" wasn't a clever algorithm, it was a clear contract for what counts as progress and a strict enforcement of it. The agent does not need to be smart, the scaffolding around the agent needs to be UNFORGIVING.

## 5. What the agent actually does in the loop

So far, the picture has been from the outside, files, metric, ratchet. Now let's flip it and look at the loop from the agent's seat, because what the agent is doing minute to minute is more boring and more interesting than people usually assume.

At the start of every iteration the agent reads three things. It reads `program.md`, the human's brief. It reads the current `train.py`, all 630 lines or so of it. And it reads `results.tsv`, which is the running list of every experiment so far and how it scored. The 630-line size of `train.py` is not an accident, by the way. The codebase is deliberately kept small enough that the entire trainer fits inside a modern LLM's context window with room left over for the agent's own reasoning. If `train.py` were 6,000 lines instead of 630, the agent would have to pick and choose what to read on each iteration, which is a known source of dumb mistakes. The repo is designed to dodge that problem entirely.

`program.md` is a fairly detailed set of instructions, with research priorities, the baseline numbers to beat (`val_bpb` of 0.997900, peak VRAM under 45 GB), the exact shell commands for running an experiment, what to do when training crashes, and a couple of directives that are worth quoting verbatim:

> "NEVER STOP. Once the experiment loop has begun, do NOT pause to ask the human if you should continue."

> "All else being equal, simpler is better. A small improvement that adds ugly complexity is not worth it."

The first one stops the agent from doing the very-coding-agent thing where, halfway through, it stops and asks "should I keep going?" and waits for a human. The whole point is that the human is not there. The second is a tiebreaker, because the agent will sometimes find changes that improve `val_bpb` by a tiny amount but blow up the code complexity, and Karpathy is telling it to choose against that. The metric does not capture code quality, the directive does.

What does the agent actually do once it has read all this? It picks one change to try. The space of changes is wide, the published examples include things like tweaking the learning rate or its warmup schedule, changing the vocabulary size, switching attention patterns (Karpathy's notation `WINDOW_PATTERN = "SSSL"` versus just `"L"`, where the letters describe local-vs-global attention layouts), adjusting batch sizes, swapping init schemes. Sometimes it tries architectural changes, sometimes pure hyperparameter tweaks. The agent decides what looks promising given what worked last time and what it sees in `results.tsv`.

Then it edits `train.py`, commits, runs `python train.py` for exactly five minutes, looks at the new `val_bpb` in `results.tsv`, and either keeps the commit or runs `git reset HEAD~1`. We've been over this part. From the agent's point of view though, this is one tight loop, and it repeats around twelve times an hour, and eighty to a hundred times overnight. The agent does not stop, does not ask for confirmation, does not pause for instructions. It just goes.

On the cost side, the published runs don't break out token counts but the per-iteration shape is straightforward. Each iteration the agent reads `program.md` (a few thousand tokens), the current `train.py` (around 6,000 to 8,000 tokens given the line count), some chunk of `results.tsv`, then produces some chain of reasoning and the diff for `train.py`. Multiply by 80 to 100 iterations and you're looking at a meaningful but not extreme inference bill, the kind of thing a small ML team can run overnight without it being a budget event. The actual cash cost depends on which agent you point at it, Claude Code, Cursor, and whatever else exposes a coding-agent interface will all work.

The thing worth holding onto from this section is what the agent is NOT doing. It is not reasoning from first principles about deep learning theory. It is not inventing new architectures. It is not exploring out into wild ideas to see what sticks. It is reading `program.md` and `results.tsv`, looking at what has worked recently, picking a small, plausible adjustment, and running the experiment.

There's a catch here though. What looks simple from the outside is only simple because Karpathy has decades of experience with this exact problem and has done the grunt work to make the loop possible in the first place. He has trained these small LLM setups by hand hundreds of times, written the code from scratch every time, and he knows where the failure modes are, which is why `prepare.py` looks the way it does and why `program.md` says what it says. He knows what's reasonable for the agent to touch and what isn't, which is why `train.py` is shaped the way it is. The agent does not have to figure out any of this, it walks into a kitchen where someone has already laid out the tools, marked the safe areas, and written down what good looks like. Without that scaffolding, the same agent pointed at a different repo would not get anywhere useful. The right recipe assumes the kitchen has already been built.

That this kind of bounded, scaffolded loop is still enough to find improvements a human missed for twenty years is what makes the whole thing interesting, and we'll come back to what that means in the next section.

## 6. Where it works, where it doesn't

Last section closed with the twenty-year point. Karpathy's loop, run overnight, surfaced something he had missed across decades of refining the same training setup, specifically that he wasn't applying weight decay to the value embeddings. That kind of small, mechanical fix is exactly what the ratchet is good at. The question for this section is what other kinds of changes it finds, and what kinds it never will. That's the call you need to make if you're deciding whether to wire this into your own work.

What it reliably finds is the same shape of thing as the weight decay change. One-line edits, no architectural risk, the kind of thing a researcher writes once, ships, and then never goes back to look at again because there are a hundred other knobs to turn. The ratchet doesn't move on to the next knob. It sits on the same knob and tries every reasonable value, then the next adjacent knob, then the next. It's good at this. Optimizer parameters that drifted out of tune over the years, init schemes that were chosen before the network depth changed, learning rate schedules that were copy-pasted from a different paper, all of these get noticed because the loop has time to actually check them and the human doesn't.

What it doesn't find is anything that requires going backwards before going forwards. Anything that needs the model to get worse for a few iterations before the bigger payoff lands. Anything that's outside the local neighborhood of the existing `train.py`. GitHub Issue #22 on the repo describes this, the agents "cycle through minor variations of whatever worked last, stuck in a local search pattern." Once the loop has found a good neighborhood it stays there.

Why does this happen? And is it the model's fault or the framework's? My take is that it's both, and you have to be honest about both contributions or you'll spend a weekend trying to fix the wrong one.

The model contribution is RLHF, specifically the reward shaping that makes Claude (and GPT, and the rest) friendly and helpful and safe. Karpathy himself talked about this on Hacker News, the agents on open-ended problems come across as "cagy and scared," which is exactly the wrong personality for a creative search task. An agent that's been trained to produce safe, conservative outputs is going to keep proposing safe, conservative experiments, things like tweaking a number, adding weight decay, or switching the activation function, rather than something like "rewrite the attention mechanism from scratch as something that doesn't exist in the literature yet." Even if the model could write that code, it has been gently trained out of suggesting it.

The thing that is contributing to the framework the most is the ratchet. The rule is simple, every change has to immediately improve `val_bpb` or it gets reset out. A change that would have improved the metric in the long run, but first made it worse for a few iterations, cannot survive `git reset HEAD~1`. The loop has no concept of "I'll allow this to be worse for two iterations and see what happens." It's strict. That strictness is also what makes the loop reliable, you can't get both. You either trust monotonic improvement as the signal and lose the ability to explore valleys, or you allow exploration and lose the guarantee that things are getting better.

If you put the two together, what you have is an agent that wouldn't propose a wild change anyway, running inside a framework that wouldn't accept one if it did. Belt and suspenders for incremental progress. Which is fine, as long as you know that's what you're buying.

Now how does this compare to the older tools and to the more recent ones, mechanically rather than as marketing categories. AutoML and NAS (neural architecture search) are basically blind search. AutoML picks hyperparameters by random sampling or evolutionary algorithms, no memory of why a previous try failed, no ability to read your code, just a budget and a search space you defined ahead of time. NAS does the same thing but for architecture choices, usually with a lot more compute thrown at it. Both can find things AutoResearch can't because they're not biased the way an LLM is toward small, safe-looking suggestions. They can also find things AutoResearch can find, but they'll take longer because they can't reason about why a change might work, they just try it.

AlphaEvolve from DeepMind is the more interesting comparison. It maintains a population of programs and uses an LLM as the mutator inside an evolutionary loop, so it gets the "agent can read code and reason" benefit of AutoResearch and the "exploration via population diversity" benefit of evolutionary search. It allows fitness to drop temporarily for some members of the population, which is the exact thing AutoResearch's ratchet rules out. The trade-off is compute. AlphaEvolve is a Google-scale system. AutoResearch is one GPU and one branch.

Here it is in pseudocode side-by-side:

```python
# AutoResearch — monotonic ratchet
while True:
    change = agent.propose(context=[program_md, train_py, results_tsv])
    apply(change); git_commit(change)
    score = train_for_5_minutes()
    if score < best:
        best = score                       # commit stays
    else:
        run("git reset HEAD~1")            # discard, never happened

# AlphaEvolve — evolutionary loop with LLM mutator
population = [seed_program]
while True:
    parent = sample(population, weighted_by=fitness)
    child = agent.mutate(parent)
    child.fitness = evaluate(child)
    population = prune(population + [child])   # diversity preserved,
                                               # low-fitness members survive
```

So if I had to put it plainly.

- AutoML when your problem is a clean hyperparameter sweep and you don't want to write search code yourself.
- NAS when you have a lot of compute and you genuinely don't know what architecture you need.
- AlphaEvolve-style approaches when you want creative leaps and you have the budget to keep a whole set of candidate `train.py` variants alive at once, letting some of them sit at lower scores in case they pay off later.
- AutoResearch when you have a working system, a clean metric, a single GPU, and you want to squeeze out the wins that a human would miss because they got bored.

Honestly, AutoResearch is closer to a polish machine than anything else. You set the dials in the right neighborhood and the agent finds the better numbers. Asking it to invent something new is asking it to do a job the loop doesn't allow and the model isn't built for.

## 7. Whether to wire it into your workflow

So back to the question from page one. Is this worth you taking out a weekend and taking it for a spin?

Mostly comes down to whether your problem looks like the problem AutoResearch was built for. There are four things in particular that have to line up.

- A system that already trains end to end, because the loop only works on a working baseline.
- A metric you trust, not just any number but one that genuinely captures what "better" means for your model, because the ratchet has only that signal to work with.
- Experiments that fit inside a short wall-clock window, because the loop relies on running many of them per night.
- A goal of incremental improvements rather than breakthroughs, because the model and the framework will both push the agent toward the polish-machine corner.

When all four of those line up, it's definitely worth your weekend, and maybe a bit more than that. You write your version of `program.md`, you make sure your `train.py` is in a clean state, you pick a tight metric, you point Claude Code or Cursor at it, and you go to sleep. In the morning you look at `git log` and `results.tsv` and see what fell out. Maybe it's a weight-decay-on-value-embeddings type win that you'd been blind to for years. Maybe it's a learning rate retune. Maybe it's nothing useful that night and you try again the next. The numbers work out fine, you'll spend some money on the agent's inference calls overnight but not enough to flinch at, you only need one GPU, and if nothing useful turns up the downside is a few hours of compute, no more.

If any of those four are missing, it might not be the best approach.

- If your training run takes a week instead of five minutes, the loop is dead in the water from the start, you'll get one or two experiments in the time AutoResearch would have done a hundred and you've removed the volume that makes the ratchet work.
- If your metric is noisy and tiny improvements aren't trustworthy, the agent will treat noise as signal and commit changes that didn't actually move the model, leaving you a chain of pretend-progress to clean up in the morning.
- If you need creative leaps, like a new architecture or a different training paradigm, the ratchet will not get you there for the reasons section 6 laid out, and you'd be better off either reading some papers or trying something like AlphaEvolve.

There's a second thing worth taking from the repo even if you decide against wiring it in. The recipe itself, by which I mean the four-piece thing of "a tight metric, a trainer, a brief, and a ratchet that only accepts winners," is reusable as a PATTERN for any agent-driven workflow you might be designing. Shopify, the company behind the e-commerce platform, ran a piece on their engineering blog applying this exact shape outside of ML, to their internal build pipelines and test runs, and reported things like 65 percent faster builds from the same pattern. The lesson applies outside of ML too, pick a number you trust, write a brief that names the rules, point an agent at it, and reject anything that doesn't move the number. The autoresearch repo is a small concrete example of a much larger way of looking at how to improve any kind of system that meets the 4 criteria set at the start of this section.

So. Should you wire it in? If your problem matches the four-part criteria and you have a weekend, yes, give it a shot, you'll come away with something whether or not the metric ends up dropping by much. If your problem doesn't match, the more useful takeaway is the pattern itself.

Either way you walk away with a real sense of what's actually inside the box. The three files, the one number, the ratchet that only accepts winners, where the loop works, where it doesn't, and the recipe pattern that you can lift out and reuse on something else. None of that knowledge is wasted whether you spin up the loop tonight or never touch the repo again.

## 8. Conclusion

One more thing before we close out. The reason this repo got the reaction it got, the stars, the interviews, the long threads on Hacker News, has very little to do with the agent itself. Coding agents already existed before autoresearch dropped. Claude Code existed. Cursor existed. People had been pointing them at ML repos for a year and getting nowhere useful.

What was new was the scaffolding, and I want to make this very clear, because "the scaffolding" sounds abstract. The metric choice, `val_bpb` instead of perplexity. The 5-minute wall-clock budget. The git-as-experiment-store trick. The immutable yardstick in `prepare.py`. The directive in `program.md` prompting the coding agent to avoid complexity. The 630 lines of `train.py` that fit inside a context window with room to spare. The git reset that throws away losses so the codebase only moves forward. None of these is impressive on its own. Most of them are one paragraph in a README. Put them together though and you have the difference between an agent that drifts and an agent that improves.

Your choice in what metric you choose to have the coding agent improve upon is the key decision you will have to make working with this repo. Point it at `val_bpb` and it will find every legal way to push that number down, including the ones you didn't intend. The reason autoresearch works is that `val_bpb` is very difficult to cheat. The only way to push it down is to predict the text better. The tokenizer is locked in `prepare.py`, so there's no cheap trick that moves the number without actually improving the model.

If any other metric were to be chosen that doesn't meet that criteria, the improvements to the model would be questionable. Eg. optimize click-through rates for a website and you might get clickbait. The agent doesn't know the difference between a real win and a gamed one, it only knows the number went down. So the most important question to ask becomes: can your metric be gamed? A working trainer is the easy part. A performance metric with no loophole is difficult. And the agent will never warn you which kind you have. It does its thing the same way whether the win is real or gamed, the number went down, the change stays. The metric is the only thing standing between an overnight improvement and self-deception.
