---
title: Enviroment variables using fish shell
author: rainbyte
published: 2016-02-07 02:46:00
tags: fish, shell
---

## Overview

Sometimes we need to *export* some value as an `env var` (eg. android sdk path).
It is important to know how to do this well for smooth system administration. 

Each shell has its own way to manage environment, I'm using fish shell.

In order to list current vars, standard `env` command is available.


## Local env vars

We could run an app with custom enviroment vars, like this:

```
env LALA='foo bar' some_cmd
```
    
This does not always work, because `env` bypasses our shell.

In those situations, we could use `set` instead:

```
set -lx LALA='foo bar'; some_cmd
```
    
The `-l` switch means *local scope*, the variable is temporal.


## Persistent env vars

When we need env vars to be *persistent* only across a session, we use `global` ones (`-g` switch):

```
set -gx LALA='foo bar'
some_cmd
other_cmd
```

Finally, we could use `universal` env vars, which are *fully persistent* across multiple sessions (`-U` switch).

For example, I used them in order to configure android sdk, like this: 


```
set -U ANDROID_HOME /path/to/android/sdk
```
    
`Universal` env vars are *persistent* across reboots, you can inspect them using `set -U` cmd.


## Path management

Changing the `PATH` env var is an special case. We cannot modify it directly, because it could be overwritten by the shell.

In order to overcome this situation, fish provides the `fish_user_paths` variable, which is automatically merged to `PATH`.

We could add some custom bin directory (e.g. node_modules bin dir), like this:

```
set -U fish_user_paths $fish_user_paths /path/to/node_modules/bin
```

In this way we preserve previously added paths, and the new dir is only appended to `fish_user_paths`.

The shell automatically adds the custom paths to the `PATH` var each time a session is started.

