---
title: AAG slides
theme: black
revealOptions:
    transition:  slide
    margin: 0.20  # default 0.04
    preloadIframes: true
---
<style>
  h1, h2, h3, h4, h5, h6 {
    text-align: left;
  }
  figcaption {
    font-size: 0.3em;
    margin: 0;
  }
  .custom-small table {
    font-size: .5em
  }
</style>

<!-- .slide: id="top" -->
<!-- .slide: data-auto-animate -->

<div style="text-align: left;">
# analogy-augmented generation (AAG)
</div>
<div style="text-align: left; font-size: 0.8em;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;for procedural knowledge generation
</div>

<br />

<div style="text-align: right; font-size: 0.5em;"><b>Kyle Roth*</b>, Rushil Gupta*, Simon Halle, Bang Liu</div>

<div style="text-align: right; font-size: 0.5em;">under review at PAKDD</div>

---
<!-- .slide: id="knowledge" -->

## ## types of knowledge

<br />

- **factual knowledge**, or knowledge-that
  <ul style="font-size: 0.7em;">
    <li class="fragment" data-fragment-index="1">e.g. "Kyle was at the university until 2am several nights last week."</li>
    </ul>
- **procedural knowledge**, or knowledge-how
  <ul style="font-size: 0.7em;">
    <li class="fragment" data-fragment-index="2">e.g. crack the eggs into the center of the pan</li>
    </ul>

<br />
<br />
<span class="fragment highlight-red" data-fragment-index="3">
    <span class="fragment" data-fragment-index="3">A lot of procedural knowledge exists as text. Can we leverage it explicitly to build LLM pipelines that can plan?</span>
<span>

Note: For humans, procedural knowledge is difficult to verbalize (e.g. how to ice skate). In the brain these two types of knowledge are stored differently.

Even here I've presented this "procedural knowledge" as factual knowledge, by stating it propositionally, i.e. "It is the case that to add a slide ...". So LLMs have seen procedural knowledge as well as factual knowledge.

***click***

In this work we build such a pipeline, which leverages a prepared procedural knowledge store to produce new solutions to procedural questions.

---
<!-- .slide: id="procedure" -->
<!-- .slide: data-auto-animate -->

## ## procedural knowledge

<pre data-id="code"><code data-trim data-line-numbers=",2,3,4">
class Procedure:
    input_: str
    output: str
    steps: list[str]
</code></pre>

Note: We structure procedures like this.

- Input represents any kind of starting state required for doing the procedure.
- Output represents the goal or end state of the procedure.
- And the steps are the required steps to accomplish the task.

This formalism introduces **structure** so that a procedure is represented in terms of its context, goal, and steps, which allows for composability.

It's **flexible** because it allows those terms to be defined in natural language.

In the future we will extend this with explicit representations of the dependencies between steps, but we wanted to keep it simple for this project.

---
<!-- .slide: id="procedure2" -->
<!-- .slide: data-auto-animate -->

## ## procedural knowledge

<pre data-id="code"><code data-trim data-line-numbers=",2,3,4">
class Procedure:
    input_: str
    output: str
    steps: list[str]
</code></pre>

The task of **procedure generation** is to predict steps given input_ and output.

---
<!-- .slide: id="fun" -->

<img src="predoc/aag/fun_diagram.png" alt="diagram of potential use of procedural knowledge system" style="background-color:#FFFFFF;" />

Note:
The basic idea is to create a system that can adapt known procedures to new tasks, like in this example.

external memory allows **frozen LLM**

---
<!-- .slide: id="method" -->

<img src="predoc/aag/aag_diagram.png" alt="AAG system design using query re-writing, summarization, and self-critique" style="background-color:#FFFFFF;" />

Note:

- procedure memory
- RAG candidate
- query rewriting
- self-critique

---
<!-- .slide: id="experiments" -->
<!-- .slide: data-auto-animate -->

## ## experiments

- 3 domains: recipes, Python tutorials, math
- training set used for procedural memory
- steps generated given input and output
- LLM-based evaluation

---
<!-- .slide: id="eval" -->
<!-- .slide: data-auto-animate -->

## ## evaluation

- LLM-based evaluation
- pairwise evaluation between generated procedures from 2 methods at a time
- evaluate on:
  - ability to accomplish the goal
  - clarity and flow of steps, level of detail
  - used only the resources in input string
- each pair evaluated 10 times, rotating position
- result is a majority vote
- **backed up with human eval where possible**

---
<!-- .slide: id="recipenlg" -->
<!-- .slide: data-auto-animate -->

## ## datasets

### ### RecipeNLG

<pre data-id="code"><code data-trim data-line-numbers>
Procedure(
    input_="1 lb. lean ground beef, 1 c. chopped onion, 1 c. chopped celery, 4 c. hot water, 2 c. 1/2-inch potato cubes, 1 c. thinly sliced carrots, 1 tsp. salt, 1/2 tsp. dried basil leaves, 1/4 tsp. ginger, 1 bay leaf, 3 tomatoes, cut into eighths and sliced in half",
    output="Autumn Soup (Microwave Recipe)",
    steps=[
        "Mix ground beef, onion and celery in 5-quart casserole dish",
        ...
    ],
)
</code></pre>

2M+ recipes scraped from the internet

----
<!-- .slide: id="lcstep" -->
<!-- .slide: data-auto-animate -->

## ## datasets

### ### LCStep

<pre data-id="code"><code data-trim data-line-numbers>
Procedure(
    input_="an LLM",
    output="set up a custom input schema for a tool with strict requirements and custom validation logic",
    steps=[
        "Define a class `ToolInputSchema` that inherits from `pydantic.BaseModel`. Include the fields you require, in this case a URL, and a root validator method that checks the domain of the URL against a list of approved domains.",
        ...
    ],
)
</code></pre>

276 procedures extracted from LangChain Python docs using GPT-4

<span class="fragment highlight-red" data-fragment-index="1">
    <span class="fragment" data-fragment-index="1">For all experiments, we used a version of GPT-3.5 with a cutoff date before the public release of LangChain.</span>
<span>

Note:
This dataset is a good test of our system's ability to produce good results for a topic unfamiliar to the frozen LLM.

----
<!-- .slide: data-auto-animate -->

### ### LCStep

#### #### data preparation

![flow chart documenting the process of producing the LCStep dataset](predoc/aag/lcstep.drawio.svg)

----
<!-- .slide: id="champ" -->

## ## datasets

### ### CHAMP

<pre data-id="code"><code data-trim data-line-numbers>
Procedure(
    input_="Category: Number-Theory\nHints: ['Study u^3-u mod 2 and u^3-u mod 3 for arbitrary integer u.']",
    output="For three integer numbers a, b, c, if their sum a+b+c is divisible by 6, is their cubed sum a^3+b^3+c^3 always divisble by 6?",
    steps=[
        "u^3-u mod 2=0 since u^3 and u have the same parity.",
        ...
    ],
)
</code></pre>

270 competition-level math problems with step-by-step solutions

---
<!-- .slide: id="baselines" -->

## ## baselines

- **zero-shot** prompting
- **few-shot** with `$k=3$` random procedures from training set
- **RAG** with `$k=3$` procedures retrieved by similarity to input and output
- **ReAct** with retrieval system from RAG as a "search tool"

Note:

- **zero-shot**: prompt the LM to generate the steps from the input and output
- **few-shot**: sample `$k=3$` random procedures from training set, include in prompt after instructions
- **RAG**: same as few-shot but `$k$` procedures are retrieved by similarity to input and output
- **ReAct**: reason+act loop, with retrieval system from RAG as a "search tool" the LLM can use

- vector store: Weaviate
- embedding model: `all-mpnet-base-v2`
- similarity measure: cosine similarity

---
<!-- .slide: id="results" -->
<!-- .slide: data-auto-animate -->

## ## AAG results

<div style="display: flex; justify-content: space-between;">
  <figure style="width: 33%; text-align: center; margin=0;">
  <img src="predoc/aag/recipenlg_main_bar_plot.png" alt="RecipeNLG results" width="100%" />
  <figcaption>RecipeNLG</figcaption>
  </figure>
  <figure style="width: 33%; text-align: center; margin=0;">
  <img src="predoc/aag/lcstep_main_bar_plot.png" alt="LCStep results" width="100%" />
  <figcaption>LCStep</figcaption>
  </figure>
  <figure style="width: 33%; text-align: center; margin=0;">
  <img src="predoc/aag/champ_main_bar_plot.png" alt="CHAMP results" width="100%" />
  <figcaption>CHAMP</figcaption>
  </figure>
</div>

based on a pairwise evaluation performed by GPT-3.5

Note:
Note here that relative column height represents evaluator confidence, not necessarily how *much* better the examples were.

AAG outperforms the baselines on all datasets. For RecipeNLG and LCStep, it's by a significant margin.

Note that ReAct was not included in these plots, but it performed strictly worse than RAG in comparison with AAG.

----
<!-- .slide: id="human" -->
<!-- .slide: data-auto-animate -->

## ## AAG results

<div style="display: flex; justify-content: space-between;">
  <figure style="width: 25%; text-align: center; margin=0;">
  <img src="predoc/aag/recipenlg_main_bar_plot.png" alt="RecipeNLG results" width="100%" />
  <figcaption>RecipeNLG (LLM eval)</figcaption>
  </figure>
  <figure style="width: 25%; text-align: center; margin=0;">
  <img src="predoc/aag/recipenlg_human_bar_plot.png" alt="RecipeNLG human evaluation results" width="100%" />
  <figcaption>RecipeNLG (human eval)</figcaption>
  </figure>
  <figure style="width: 25%; text-align: center; margin=0;">
  <img src="predoc/aag/lcstep_main_bar_plot.png" alt="LCStep results" width="100%" />
  <figcaption>LCStep (LLM eval)</figcaption>
  </figure>
  <figure style="width: 25%; text-align: center; margin=0;">
  <img src="predoc/aag/champ_main_bar_plot.png" alt="CHAMP results" width="100%" />
  <figcaption>CHAMP (LLM eval)</figcaption>
  </figure>
</div>

Note:
***zoom***

The orange bars represent examples where AAG was preferred over the baseline.

The blue bars represent times when the baseline was preferred.

The gray bars represent ties.

Note here that relative column height represents evaluator confidence, not necessarily how *much* better the examples were.

AAG outperforms the baselines on all datasets. For RecipeNLG and LCStep, it's by a significant margin.

Note that ReAct was not included in these plots, but it performed strictly worse than RAG in comparison with AAG.

----
<!-- .slide: id="example" -->

### ### LCStep example

![side-by-side comparison of the procedures generated by each baseline and AAG for the autumn soup recipe](predoc/aag/side_by_side.png)

Note:
Here you can see the difficulty in comparing generated procedures with the reference text.

---
<!-- .slide: id="ablation" -->

## ## ablations

<div style="display: flex; justify-content: space-between;">
  <figure style="width: 30%; text-align: center; margin=0;">
  <img src="predoc/aag/recipenlg_ablation_bar_plot.png" alt="RecipeNLG ablation results" width="100%" />
  <figcaption>RecipeNLG</figcaption>
  </figure>
  <figure style="width: 30%; text-align: center; margin=0;">
  <img src="predoc/aag/lcstep_ablation_bar_plot.png" alt="LCStep ablation results" width="100%" />
  <figcaption>LCStep</figcaption>
  </figure>
  <figure style="width: 30%; text-align: center; margin=0;">
  <img src="predoc/aag/champ_ablation_bar_plot.png" alt="CHAMP ablation results" width="100%" />
  <figcaption>CHAMP</figcaption>
  </figure>
</div>

<br />

<div style="display: flex; justify-content: space-between;">
<div style="width: 50%; text-align: center;">
<ul>
<li><b>NOQR</b>: no query rewriting</li>
<li><b>NOCR</b>: no self-critic</li>
</ul>
</div>
<div style="width: 50%; text-align: center;">
<ul>
<li><b>NOSUM</b>: no summarization</li>
<li><b>NOSUM-NOCR</b></li>
</ul>
</div>
</div>

Note:
Here we see that in most cases the 3 main components of AAG added to the quality of the results.

---
<!-- .slide: id="conclusion" -->

## ## contributions

- simple theoretical framework for operating on procedural knowledge
- novel LLM pipeline that leverages this framework
- showed increased performance over RAG and ReAct
  - esp. on an unseen topic (LCStep)

---
<!-- .slide: id="graph" -->
<!-- .slide: data-auto-animate -->

## ## next steps

<pre data-id="code"><code>class Procedure:
    input_: str
    output: str
    steps: list[str]
</code></pre>

----
<!-- .slide: id="graph2" -->
<!-- .slide: data-auto-animate -->

## ## next steps

<pre data-id="code"><code data-trim data-line-numbers="5,6|8,9,10,11">class Graph[T, U]:
    inputs: list[Input[T, U]]
    outputs: list[Output[T, U]]

class Procedure(Graph[Step, str]):
    pass

class Step:
    api: str
    desc: str
    args: list[str]

</code></pre>

----
<!-- .slide: id="graph3" -->
<!-- .slide: data-auto-animate -->

## ## next steps

**benefits of a graph representation**:

- explicitly represent dependencies
- represent cycles, decision branches
- "API" can represent categories of actions within the action space
- can also retrieve from subgraphs
  - e.g. capture structure of "preheat" baking step

----
<!-- .slide: id="graph4" -->
<!-- .slide: data-auto-animate -->

## ## next steps

**difficulties of a graph representation**:

- How do we ensure we extract "correct" graphs from text data to create a procedural memory?
- How do we measure accuracy of generated graphs, given a reference graph?

---
<!-- .slide: id="end" -->

<div style="text-align: right">thank you!</div>
<br />
<div style="text-align: right; font-size: 0.4em;"><a href="https://kylrth.com">https://kylrth.com</a></div>
