---
name: be-depth-ambitious
description: Invoked as /be-depth-ambitious AFTER the user has already given the agent a task; it applies to the task just prompted. Rewrites that task to be deeper, not bigger, by asking what a top professional would do, starting from raw material, with specific methods and independent verification.
disable-model-invocation: true
---

Apply the following to the task the user just gave you:

I want a deeper version of this task, not a bigger one. Before rewriting it: (1) say what a top professional in this field would do here that I’m not asking for; (2) name the rawest material they would start from instead of what has already been digested for me; (3) name the specific methods and tools they would use; (4) say what, other than you or me, would show the result is right. Then rewrite my prompt to ask for exactly that.

Credit: [Felix Rieseberg, "How to be more ambitious: a tutorial for humans with models"](https://felixrieseberg.com/how-to-be-more-ambitious-a-tutorial-for-humans-with-models/).
