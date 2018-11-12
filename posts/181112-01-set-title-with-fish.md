---
title: Set terminal tab title using fish shell
author: rainbyte
published: 2018-11-12 07:28:00
tags: fish, shell
---

## Approach #1: setting the title by hand

When there are many terminal tabs opened, it is really useful to give them meaninful names.

Fish shell allows setting the current tab's title creating a `fish_title` function.

If we want to name our tab `FOO`, we could just write this in the terminal:

```sh
function fish_title
    echo "FOO"
end
```

After entering the code, the function will be exported and the new title will be used.

The problem with this way is that writing the function each time is tedious.

There is an easy way to overcome this problem.

## Approach #2: using a helper function

We could write a helper which export the `fish_title` function for us.

I call this helper `set_title`, but other name could be used as well.

First we need to write the helper function:

```sh
function set_title
    set -l title $argv[1]
    function fish_title --inherit-variable title
        echo "$title"
    end
end
```

Now we can test it, eg. to name our tab `BAR` we could call it this way: `set_title BAR`

Finally, to save the function persistently, we execute this: `funcsave set_title`

## How does it work?

Each time we execute `set_title`, it will re-export the `fish_title` function.

We need to make the *title* variable available inside `fish_title` scope.

The trick is using the `--inherit-variable` option, which will solve this for us.