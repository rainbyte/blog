---
title: Grouping by key with Python
author: rainbyte
published: 2015-05-19 23:02:37
tags: python, snippets, batch
---

Today I had to process some data, which was inside an unordered list, using the Python language.

Some computations employed all the list items, others were based only on related ones.

<!-- more -->


The data was arranged in tuples, each one contained a main value among others.

That value (let's call it "key"), identified a relation with other tuples.

Simplifying it, quite a bit, was something similar to this:

```python
items = [(1, "a"), (3, "q"), (2, "c"), (2, "x"), (1, "z")]
```

The problem could be solved using some nested "while" iterations.

But actually, I wanted something more brief and readable.

Then, I looked for an alternative, and found itertools.


First I've loaded the required module:

```python
from itertools import groupby
```

Then, the final solution was much like this:

```python
for key, group in groupby(sorted(items), lambda x: x[0]):
    # Do something with the key
    print(key)
    for tuple in group:
        # Process each tuple with same key
        print(tuple)
    # Other statements
    print("^^^^^^^^^")
```

There are some remarkable points in this code:

* The list needs to be `sorted` previously, so keys can be matched up.
* I've used a `lambda` in order to select which element is the key.
* The key can be accessed individually.
* Related tuples can accessed via the group variable.
* Each item inside each group still contains the key.

This code would print something like this:

```txt
1
(1, 'a')
(1, 'z')
^^^^^^^^^
2
(2, 'c')
(2, 'x')
^^^^^^^^^
3
(3, 'q')
^^^^^^^^^
```

At the end, this method was cleaner than using iterations by hand.
