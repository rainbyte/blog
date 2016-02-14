---
title: How-to decrease gnome title-bar height
author: rainbyte
published: 2015-07-02 03:15:07
tags: gnome, snippets, css
---

I've started using [Firefox](https://www.mozilla.org/firefox) again, and after some time I noticed that Gnome window title-bars were eating a lot of screen space.

<!-- more -->

To solve the issue, I've tried installing [a plugin](https://addons.mozilla.org/en-US/firefox/addon/hide-caption-titlebar-plus-sma/), but I was not too happy with the result (even after some custom tweaks).  
Later, I gave up with the plugin, and started searching for other solution, reading various sources (like forums).

Finally, a [good hint](https://wiki.archlinux.org/index.php/GNOME#Titlebar_height) appeared inside [the ArchWiki](https://wiki.archlinux.org) (a wonderful source of reliable information).  
After tweaking the snippet a bit, I added it to `~/.config/gtk-3.0/gtk.css`, like this:

```css
.header-bar.default-decoration {
    padding-top: 1px;
    padding-bottom: 1px;
    font-size: 0.5em;
}

.header-bar.default-decoration .button.titlebutton {
    padding-top: 1px;
    padding-bottom: 1px;
    border-width: 0;
}
```

An that's all, no plugin needed and it is useful system wide (at least for apps which don't support client side decorations).







