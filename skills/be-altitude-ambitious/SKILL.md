---
name: be-altitude-ambitious
description: Invoked as /be-altitude-ambitious AFTER the user has already given the agent a task; it applies to the task just prompted. Rewrites that task to be higher, not bigger, by asking what goal sits behind it and what the owner of that outcome would do.
disable-model-invocation: true
---

Apply the following to the task the user just gave you:

I want a higher version of this task, not a bigger one. Before rewriting it: (1) say what goal sits behind this goal; (2) say what outcome I’d actually want if this task succeeded; (3) say what the person owning that outcome would do that I’m not asking for; (4) say how we’d know the outcome happened, not just that the task was done. Then rewrite my prompt to own that outcome.

Credit: [Felix Rieseberg, "How to be more ambitious: a tutorial for humans with models"](https://felixrieseberg.com/how-to-be-more-ambitious-a-tutorial-for-humans-with-models/).
