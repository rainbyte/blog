{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid ((<>))
import           Hakyll


main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.rst"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    -- Build tags
    tags <- buildTags "posts/*" (fromCapture "tags/*.html")

    -- Render posts
    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"
                    (postCtx tags <> defaultContext)
            >>= loadAndApplyTemplate "templates/default.html"
                    (postCtx tags <> defaultContext)
            >>= relativizeUrls

    -- Render posts archive
    create ["posts.html"] $ do
        route idRoute
        compile $ postPage tags "All posts" "posts/*"

    -- Create pages for tags
    tagsRules tags $ \tag pattern -> do
        let title = "Tag: " ++ tag
        route idRoute
        compile $ postPage tags title pattern

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
