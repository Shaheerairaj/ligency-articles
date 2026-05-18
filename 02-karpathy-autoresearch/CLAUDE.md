# A Practical Guide to Andrej Karpathy's AutoResearch

You are writing a single technical article for the Ligency publication. Read this file completely before writing anything. Then read the reference material in `/reference/` before drafting.
 
---
 
## The angle
 
This is an engineering deep-dive. The reader should finish the article feeling like they've been inside the repo with someone who actually read the code. Every claim about how AutoResearch works gets backed by an artifact: a file, a command, a commit hash, a line of code, a config value. Concept-first explanations are what the existing DataCamp article does. Don't repeat that. Show the mechanics.
 
If you can't point to a specific file, function, or line, the claim probably belongs in a different article.
 
## The reader
 
One person: an ML engineer who has shipped models to production and wants to know whether AutoResearch is worth wiring into their workflow. They are not deciding whether the idea is interesting. They are deciding whether to spend a weekend on it. Write for that decision.
 
Their familiarity ranges from senior ML engineers to early-career practitioners. Define technical terms when they first appear — short parentheticals are usually enough. Don't lecture, but err on the side of explaining rather than assuming the reader has the same training as you. They have not read every line of the autoresearch repo. Do that work for them.
 
## Voice

Default voice: smart friend over coffee who has read the repo carefully and is walking you through it. Plain language. Hedged instead of declarative. Slight conversational looseness in word choice. Reads like thinking out loud, not edited prose.

What the default register looks like in practice:

- **Hedged phrasing kept rough.** "Kind of clever." "All there is to it." "Is not a lot of room." Where a stricter writer would smooth these, leave them. The friction is the human-ness.
- **Slightly imprecise word choice on purpose.** "Actually determined a success" instead of "succeeded." "The moves the agent actually makes" instead of "the agent's moves." A polished writer would tighten; you leave the looseness.
- **Plain language over jargon when both work.** "Bits the model needs to predict each byte" before "compressed entropy per byte." When jargon shows up because it has to, explain it in a short parenthetical instead of assuming the reader already knows.
- **Avoid absolute claims.** "Might not be as quantitative," "is by far the trickiest part," "lots of room for improvement." No marketing-speak, no "revolutionary," no "powerful."
- **Image-y verbs over flat ones.** "Creeps down" instead of "decreases." "Spins in circles" instead of "fails to converge." "Chew on" instead of "process." Pick the verb that gives the reader a picture.
- **Colloquial metaphors that ground abstract ideas.** "Hand the keys over." "In the seat." "A brief you'd hand to a contractor." A concrete physical image where a polished writer would reach for an abstract verb.
- **Personal opinion inserted as a casual mid-sentence aside.** Drop your take in without giving it its own paragraph: "and I think the framing is very well done here." Treats the reader as a peer rather than an audience.
- **Repetition for anchoring.** Restate a key idea from a different angle to lock it in. "The recipe is the surrounding system. The repo itself is the recipe." Don't avoid repetition when the point matters, lean into it.

Four signature moves are available as accents. Use sparingly. The right cadence is once or twice per section, at moments that earn them. Used in every paragraph they lose their edge.

- **ALL CAPS for spoken stress.** "The WAY this is done." "The whole POINT." Use where a stricter writer would italicize or bold. Caps mimic conversational stress; italics feel sterile by comparison.
- **Mock-formal opener for casual content.** "One might ask at this point how this is different to AutoML." The slightly stilted construction sets up plain-English content. The register clash is the joke; do not pay it off with more formal prose after.
- **Reassuring direct address.** "Don't worry if you didn't understand all of that, we will dive into each one of these concepts in detail." Use at transitions between hard concepts, not as filler. Treats the reader as a guest, not a student.
- **Run-on connective with `and...and...`.** Let clauses chain where a stricter writer would split into sentences or use semicolons. Mimics how thinking unfolds out loud.

First person singular throughout. "I read the repo," not "we read the repo" or "one might read the repo." The article is published under a byline.

## Hard bans
 
These words and phrases do not appear in the final article. Not once.
 
**Banned vocabulary:** delve, leverage, leveraged, leveraging, robust, seamless, transformative, navigate (metaphorical), unlock, harness, tapestry, landscape (metaphorical), realm, ecosystem (metaphorical), game-changer, revolutionary, groundbreaking, powerful (as filler), cutting-edge, state-of-the-art (as filler), paradigm shift, holistic, synergy, streamline, empower, foster, facilitate, utilize (use "use"), commence (use "start"), terminate (use "end" or "stop"), demonstrate (use "show"), elucidate, illuminate (metaphorical), underscore, crucial, vital, essential (as filler), pivotal, paramount, fundamental (as filler).
 
**Banned filler phrases:** "in today's [anything] world," "in the ever-evolving," "it's worth noting that," "it's important to note that," "moreover," "furthermore," "crucially," "notably," "ultimately," "at its core," "at the end of the day," "when it comes to," "in order to" (use "to"), "the fact that" (cut it), "needless to say," "that being said," "load-bearing" / "load bearing," "unpacking" (as a meta-word for explanation, e.g. "needs more unpacking"), "earns its keep," "the comparison still holds," "heavy lifting" (as filler), "most demos skip [this]" / "[this is] what most demos don't do" (any framing implying other demos/articles fall short), "doing a lot of quiet work" / "doing a lot of the work" / "[X] is doing a lot of [adjective] work" as a framing for under-the-hood mechanisms.
 
**Banned sentence patterns:**
- "From X to Y" framing for showing range or variety
- Participial tails: "The system does X, revealing Y" / "...allowing for Z" / "...enabling W." Cap at 2 in the entire article.
- Symmetric tricolons: "faster, cheaper, smarter." Use two items or break the symmetry.
- Rhetorical questions immediately answered: "So what does this mean? It means..."
- Conclusion paragraphs that restate what was just said
- "Not just X, but Y"
- "It's not X, it's Y"
- "Imagine if..." openings

**Punctuation rules:**
- Avoid em dashes completely. Default to commas, parentheses, or periods. If you find yourself writing one, ask whether a period would work. It usually does.
- No bold inside running prose for emphasis. Bold is reserved for headers and technical terms on first introduction (file names, function names).
- Avoid the colon-then-list pattern unless the list is genuinely enumerable. Don't use it to dress up two items.

## Positive specs
 
These are the moves that make the article not sound like every other ML explainer.
 
**Burstiness.** Vary sentence length aggressively. A 4-word sentence next to a 32-word one. Human technical writing has high variance. AI writing regresses to ~18-word means. Sentences of 8, 9, 10 words in a row are a warning sign.
 
**Specificity over generality.** Always reach for the concrete number, name, file path, line of code, commit hash, GPU memory figure, version number, dollar cost. "21,000 stars and 8.6M views" beats "went viral." "45 GB peak VRAM" beats "memory-intensive." "ratchet only accepts changes that immediately improve val_bpb" beats "the system is conservative." Replace abstractions with mechanics.
 
**Show the code.** Pull actual snippets from `/reference/repo/`. Reference line numbers. Show the program.md directives verbatim, not paraphrased. Show one row of results.tsv. Show the git commands the ratchet uses. If a section explains how something works and doesn't have a code block, that's a smell.
 
**One commitment per section.** Each section advances a specific claim and defends it. Not a survey of considerations. If you can rearrange the paragraphs in a section without changing the meaning, the section has no argument.
 
**Don't reintroduce the basics.** The reader knows what AutoResearch is by section three. Stop reintroducing it. Avoid generic warmup like "in today's world..." or "as we all know" — start sections with content the reader doesn't already have.
 
**Asymmetry.** Lists don't need parallel structure. Paragraphs don't need topic sentences. Some sentences are fragments. Some paragraphs are one line. The DataCamp article has rigid topic-sentence-support-conclusion paragraphs throughout. Don't write that.
 
**Name people, tools, versions.** "Tobi Lütke" not "the Shopify CEO." "Claude Code" not "a coding agent." "FineWeb-Edu" not "the training corpus." "Muon+AdamW" not "the optimizer." Specifics signal that the writer actually knows the space.
 
**Commit to opinions.** When discussing the creativity ceiling, take a position on whether it's the framework or the model. When comparing to AlphaEvolve, say which is the better fit for which use case and why. Hedged analysis is what generic content does.

**Grammatical Errors are Ok.** Things like missing commas and run on sentences make the text feel natural. Lean into this rather than perfect grammar. Specific patterns to leave alone:
- Lowercase after a quote-period: `Karpathy calls this "the right recipe." and I think the framing is...`
- Missing articles in mid-sentence asides: "agent demos that are marketed to improve system don't get right"
- Comma splices where a stricter writer would use a period or semicolon
- Run-on sentences that chain clauses with `and...and...`
- Sentence fragments that punch where they need to

These are not errors to fix in a final pass. They are the texture.

## Suggested Chapters

1. What is AutoResearch — short, ~250 words, frames the three-file contract as the actual idea and positions it against AutoML, NAS, AlphaEvolve, and general coding agents.
2. Why val_bpb specifically — bits-per-byte vs perplexity vs cross-entropy, why it's tokenizer-invariant, why that matters when the agent might change tokenization.
3. The prompt engineering inside program.md — show a real program.md, dissect why each directive works, what happens when you change them.
4. Actual code walkthrough of train.py — what the GPT architecture looks like, how Muon+AdamW is wired up, which hooks the agent typically modifies.
5. Git mechanics of the ratchet — exact commands, how git reset HEAD~1 interacts with failed runs, branch strategy, how results.tsv gets parsed back into agent context.
6. The agent's decision loop in detail — what context window Claude Code sees, how it picks the next experiment, token costs per experiment.
7. Reproducing a run end-to-end — actual commands, actual results.tsv excerpts, what the staircase looks like in practice.
8. Comparison with code, not prose — AlphaEvolve's evolutionary loop vs AutoResearch's ratchet, shown as pseudocode side-by-side.
9. The creativity ceiling, mechanistically — why RLHF causes it, what a fix would look like, what forks have tried.

## Reference Material

Below are files you can use as reference when writing this article

1. autoresearch repo - the actual github repo by Andrej `references/autoresearch`
2. Brief - The brief submitted by the client asking me to write this article `references/article-brief.md`
3. Research - Material like articles and papers around the topic `research`
