---
name: be-range-ambitious
description: Invoked as /be-range-ambitious AFTER the user has already given the agent a task; it applies to the task just prompted. Rewrites that task to be wider, not bigger, by bringing in specialists from other fields, including one who attacks the result.
disable-model-invocation: true
---

Apply the following to the task the user just gave you:

I want a wider version of this task, not a bigger one. Before rewriting it: (1) name the specialists from other fields who would see this differently, including one whose job is to attack the result; (2) say what each would do, in verbs, not what they’d know; (3) name the tools or methods each would bring that I wouldn’t think of; (4) say where their views would conflict and how to settle it. Then rewrite my prompt so each of them does their part.

Credit: [Felix Rieseberg, "How to be more ambitious: a tutorial for humans with models"](https://felixrieseberg.com/how-to-be-more-ambitious-a-tutorial-for-humans-with-models/).
