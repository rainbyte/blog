---
title: Pandoc filter for custom ruby notation
author: rainbyte
published: 2018-11-22 03:12:00
tags: blog, haskell, pandoc, markdown, chinese, japanese
commentsIssue: 2
---

## The motivation

Chinese and Japanese languages use ideograms in their written forms, but sometimes it is useful to show the reader how those ideograms should be pronounced. To do that, phonetic systems like **{汉语|hànyǔ}{拼音|pīnyīn}** and **{振り仮名|fu|ri|ga|na}** are used.

In html documents we can use `ruby` elements to show phonetic representation above the ideograms, like in the following example:

|Code|Expected Result|
|----|---------------|
|`我喜欢<ruby>汉<rt>hàn</rt>字<rt>zì</rt></ruby>`|中国<ruby>汉<rt>hàn</rt>字<rt>zì</rt></ruby>|

The problem is that writing text using `ruby` elements it is tedious and error prone. We prefer writing something like the following examples:

|Code|Expected Result|
|----|---------------|
|`我喜欢{汉字|hàn|zì}`|我喜欢<ruby>汉<rt>hàn</rt>字<rt>zì</rt></ruby>|
|`我喜欢{汉字|hànzì}`|我喜欢<ruby>汉字<rt>hànzì</rt></ruby>|
|`我喜欢{汉字|}`|我喜欢<ruby>汉<rt></rt>字<rt></rt></ruby>|
|`我喜欢{汉字|hà|n|zì}`|我喜欢<ruby>汉字<rt>hà|n|zì</rt></ruby>|
|`我喜欢{汉字}`|我喜欢{汉字}|
|`我喜欢{|hànzì}`|我喜欢<ruby><rt>hànzì</rt></ruby>|
|`我喜欢{|}`|我喜欢|

The rest of the post explains how to handle those custom markdown expressions to produce the `ruby` elements without writing them by hand. I implemented this code in **Haskell** language as a **Pandoc** filter, because this blog uses **Hakyll** static generator which uses the **Pandoc** library.

## Document representation

Pandoc uses a custom datatype to represent in an uniform way the multiple types of contents it can handle. That type is called `Pandoc` and basically contains a tree-like structure formed by different nodes. We are interested in processing only nodes which are specific instances of the `Inline` type, because they contain the pieces of text we want to modify.

We have a piece of code which process the provided Pandoc data structure.

```haskell
transformCustomMarkdownRuby :: Pandoc -> Pandoc
transformCustomMarkdownRuby = walk handleInline
  where
    handleInline :: Inline -> Inline
    handleInline (Str s) = case (parse markdownRuby "" s) of
        (Left _)     -> Str s
        (Right rubies) -> RawInline (Format "html") (rubiesToHtml rubies)
    handleInline x       = x
```

The key point in this code is the pattern matching over the `Inline` type, specifically over the `Str` instances. We use the `walk` function to process all the matched nodes recursively, leaving the other ones untouched. A `RawInline` instance is generated when ruby tags are found, otherwise the original `Str` instance is preserved.

## Text processing

When we have a candidate to be modified, it is necessary to verify if it follows the correct syntax, so we can parse it to extract the data and render it the way we want.

Now, here we have the code which does main work:

```haskell
markdownRuby :: Parsec String () [(String,[(String,String)],String)]
markdownRuby = many $ choice [try ruby, fallback]
  where
    ruby :: Parsec String () (String,[(String,String)],String)
    ruby = (,,) -- (openingText,rubyPairs,closingText)
        <$> (many $ noneOf "{")
        <*> between (char '{') (char '}') markdownRubyPairs
        <*> (many $ noneOf "{")
    fallback :: Parsec String () (String,[(String,String)],String)
    fallback = (,,) -- (openingText,rubyPairs,closingText)
        <$> (many1 $ anyChar)
        <*> pure []
        <*> pure ""
markdownRubyPairs :: Parsec String () [(String,String)]
markdownRubyPairs = do
    elems <- taggedElems
    tags  <- many1 rubyTag
    let sameLen = length elems == length tags
        matchingPairs = zip elems tags
        singlePair = [(mconcat elems,intercalate "|" tags)]
    pure $ if sameLen then matchingPairs else singlePair
  where
    taggedElems :: Parsec String () [String]
    taggedElems = fmap (fmap pure) (many (noneOf "|}"))
    rubyTag = char '|' *> (many $ noneOf "|}")
rubyToHtml :: (String,[(String,String)],String) -> String
rubyToHtml (prev,pairs,next) = prev <> pairsToHtml pairs <> next 
  where
    pairsToHtml [] = ""
    pairsToHtml ps = (wrap . mconcat . fmap pairToHtml) ps
    pairToHtml ("","") = ""
    pairToHtml (elem,tag) = elem <> "<rt>" <> tag <> "</rt>"
    wrap x = "<ruby>" <> x <> "</ruby>"
rubiesToHtml :: [(String,[(String,String)],String)] -> String
rubiesToHtml = mconcat . fmap rubyToHtml
```

We are using a library called `Parsec`, which provides us tools to easily handle the parsing. This code uses them to separate the text in 3 parts: the text before our target, the target itself, the text after our target. Because our target should be between braces, we use te `between` combinator to find it.

When the target is found, its contents are separated into base elements and their respective ruby tags, so they can be grouped into pairs. It is assumed that the number of elements and tags is equal, otherwise we have to merge them into a single pair to preserve this property.

Finally, when we have the independent pieces, we can take and arrange them to render the view in the format we like. Pandoc support many formats, but in this case we are using Html.

## Some caveats

The current code doesn't handle some cases well. I'm still working on it to make it work with markdown tables, formatting inside the tags, and other missing bits.