---
title: How-to update a git submodule
author: rainbyte
published: 2015-07-02 04:29:59
tags: workflow, git
---

I do not use git submodules too often, so I'll write this recipe here, for future reference.

<!-- more -->

When we have a git repo with a submodule inside, some steps are needed to update both in sync.  
This occurs because, the parent repo and the submodule, are actually two independent repos.

This is the workflow I use to update a submodule:

1. Work inside the submodule:


    `$ # edit <some files>`

    `$ git add <some files>`

2. Now we have some changes ready to commit and push them:

    `$ git commit -m "Edited <some files>`

    `$ git push`

3. Finally, we tell the parent repo that the submodule has changed:

    `$ cd the/parent/repo/path`

    `$ git add the/submodule/repo/path`

    `$ git commit -m "Updated the submodule"`

    `$ git push`

Syncing everytime a change is made to the submodule **is not advisable**, think carefully before doing it.  
Sometimes we should **NOT do it** at all (e.g. there are
compatibility breaking changes).

The parent repo could point to a previous (*and safe*) version of the submodule all the required time.  
At least while is being adapted to assimilate the submodule updates.
