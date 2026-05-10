---
title: "Karpathy's Original AutoResearch Announcement Tweet"
source: https://x.com/karpathy/status/2030371219518931079
type: primary-source
date_published: 2026-03-07
date_fetched: 2026-05-10
tags: [autoresearch, karpathy, announcement, nanochat, ratchet-loop, agent-loop, program-md, train-py, first-post]
related:
  - 01-github-readme.md
  - 11-nanochat-relationship.md
---

# Karpathy's Original AutoResearch Announcement Tweet

**Source:** https://x.com/karpathy/status/2030371219518931079  
**Date:** March 7, 2026  
**Note:** This is the first public tweet announcing AutoResearch as a named project. Full text captured manually by user.

---

## Full Tweet Text

> I packaged up the "autoresearch" project into a new self-contained minimal repo if people would like to play over the weekend. It's basically nanochat LLM training core stripped down to a single-GPU, one file version of ~630 lines of code, then:
>
> - the human iterates on the prompt (.md)
> - the AI agent iterates on the training code (.py)
>
> The goal is to engineer your agents to make the fastest research progress indefinitely and without any of your own involvement. In the image, every dot is a complete LLM training run that lasts exactly 5 minutes. The agent works in an autonomous loop on a git feature branch and accumulates git commits to the training script as it finds better settings (of lower validation loss by the end) of the neural network architecture, the optimizer, all the hyperparameters, etc. You can imagine comparing the research progress of different prompts, different agents, etc.

---

## Key Points from This Tweet

- **Confirms nanochat origin:** "basically nanochat LLM training core stripped down to a single-GPU, one file version of ~630 lines of code"
- **The two-role split stated plainly:** human → `.md` prompt; agent → `.py` training code
- **Goal stated directly:** "make the fastest research progress indefinitely and without any of your own involvement"
- **Each dot in the image = one complete 5-minute LLM training run**
- **The agent works on a git feature branch** and accumulates commits as it finds improvements
- **What the agent optimizes:** architecture, optimizer, all hyperparameters — anything that lowers validation loss within the 5-minute window
- **Implied future direction:** comparing research progress across different prompts and different agents
