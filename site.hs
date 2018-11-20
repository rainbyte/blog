{-# LANGUAGE OverloadedStrings #-}

import           Control.Monad.State.Class
import           Data.List (intercalate)
import           Data.Monoid ((<>))
import           Hakyll
import           Text.Pandoc.Definition
import           Text.Pandoc.Walk
import           Text.Parsec


main :: IO ()
main = hakyllWith customSiteConfig $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.md", "cheatsheet.md"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    -- Build tags
    tags <- buildTags "posts/*" (fromCapture "tags/*.html")

    -- Render posts
    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompilerWithTransform 
                    defaultHakyllReaderOptions
                    defaultHakyllWriterOptions
                    transformCustomMarkdownRuby
            >>= loadAndApplyTemplate "templates/post.html"
                    (postCtx tags <> defaultContext)
            >>= saveSnapshot "content"
            >>= finish (postCtx tags <> defaultContext)

    -- Render posts archive
    create ["posts.html"] $ do
        route idRoute
        compile $ postPage tags "All posts" "posts/*"

    -- Create pages for tags
    tagsRules tags $ \tag pattern -> do
        let title = "Tag: " ++ tag
        route idRoute
        compile $ postPage tags title pattern

    -- Render feed
    create ["atom.xml"] $ do
        route idRoute
        compile $ do
            let feedCtx = postCtx tags <> bodyField "description"
            posts <- fmap (take 10) . recentFirst =<<
                loadAllSnapshots "posts/*" "content"
            renderAtom customFeedConfig feedCtx posts

    -- Home page
    create ["index.html"] $ do
        route idRoute
        compile $ do
            list <- postList tags "posts/*" $ fmap (take 5) . recentFirst
            makeItem ""
                >>= loadAndApplyTemplate "templates/index.html"
                        (constField "posts" list <> defaultContext)
                >>= finish (titleCtx "Home")

    -- Read templates
    match "templates/*" $ compile templateCompiler


-- Context Functions

postCtx :: Tags -> Context String
postCtx tags = mconcat
    [ dateField "date" "%B %e, %Y"
    , tagsField "tags" tags
    , defaultContext
    ]

titleCtx :: String -> Context String
titleCtx title = constField "title" title


-- Auxiliary functions

postList :: Tags -> Pattern -> ([Item String] -> Compiler [Item String])
         -> Compiler String
postList tags pattern preprocess' = do
    postItemTpl <- loadBody "templates/postitem.html"
    posts' <- loadAll pattern
    posts <- preprocess' posts'
    applyTemplateList postItemTpl (postCtx tags) posts

-- Make a page from a list of posts
postPage :: Tags -> String -> Pattern -> Compiler (Item String)
postPage tags title pattern = do
    list <- postList tags pattern recentFirst
    makeItem ""
        >>= loadAndApplyTemplate "templates/posts.html"
                (constField "posts" list <> constField "title" title <>
                    defaultContext)
        >>= finish (titleCtx title)

finish :: Context String -> Item String -> Compiler (Item String)
finish context item =
    loadAndApplyTemplate "templates/default.html"
        (context <> defaultContext) item
    >>= relativizeUrls


-- Custom config

customSiteConfig :: Configuration
customSiteConfig = defaultConfiguration
    { destinationDirectory = "_site"
    }

customFeedConfig :: FeedConfiguration
customFeedConfig = FeedConfiguration
    { feedTitle       = "(λblog.rainbyte)"
    , feedDescription = "A site about things I enjoy and would like to share"
    , feedAuthorName  = "rainbyte"
    , feedAuthorEmail = "rainbyte@tuta.io"
    , feedRoot        = "http://rainbyte.github.io"
    }


-- Pandoc filters

transformCustomMarkdownRuby :: Pandoc -> Pandoc
transformCustomMarkdownRuby = walk handleInline
  where
    handleInline :: Inline -> Inline
    handleInline (Str s) = case (parse markdownRuby "" s) of
        (Left _)     -> Str s
        (Right rubies) -> RawInline (Format "html") (rubiesToHtml rubies)
    handleInline x       = x
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