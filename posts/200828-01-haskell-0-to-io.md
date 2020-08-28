---
title: Haskell from 0 to IO (Maybe Hero)
author: rainbyte
published: 2020-08-28 03:56:00
tags: haskell, io, monad, typeclasses
language: en
commentsIssue: 6
---

## Introduction

This guide references some syntax and patterns used when writing programs
in the Haskell language. A text editor and the GHC compiler are required
to run the code, but online environments are also an option.

## Minimal example

Haskell expects programs have an entrypoint called `main`, which later is
explained in detail, but for now we will create a file named `Program.hs`
and write inside the following code:

```haskell
-- Comments are written like this
main = print "hola"
```

Check if code can be interpreted:

```sh
runghc Program.hs
```

Check if code can be compiled and executed:

```sh
ghc -o Program Program.hs
./Program
```

Some system also require to add the `-dynamic` option (eg. Arch Linux).

## Definitions

Haskell definitions indicate a type with `::` and their value with `=`.

Here `num` is defined with type `Int` and value `9`:

```haskell
num :: Int -- type
num = 9    -- definition

main = print num
```

The `=` symbol means equality in both ways, this means that `num` can be
replaced by `9` anywhere.

Detailed definitions are done using `let..in..`, which has a `let` section
with local values accessed by the `in` section to calculate a final value.

```haskell
num =
    let x = 5  -- define x
        y = 10 -- define y
    in x + y   -- use them

main = print num
```

## Types

Carefully designed types reject unwanted values by making them unrepresentable.

The `type` keyword indicates an alias to an existing type.

Here `String` is an alias to a list of `Char`:

```haskell
type String = [Char]
```

The `data` keyword is used to define custom types.

Booleans are represented in this way:

```haskell
data Bool = False | True
```

We can apply conditionals over booleans like this:

```haskell
b :: Bool
b = True

s :: String
s = if b then "True" else "False"

main = print s
```

The `Ordering` type is used to compare things:

```haskell
data Ordering = LT | EQ | GT
```

Handling each possible case for a type is called `pattern matching`, and
ideally all of them should be handled

```haskell
ord :: Ordering
ord = LT

s :: String
s = case ord of
    LT -> "Less Than"
    EQ -> "Equal"
    GT -> "Greater Than"

main = print s
```

The `Maybe` type is parametrized and represents the existence of something with
a generic type `t`, avoiding the use of `null` at all.

```haskell
data Maybe t = Just t | Nothing
```

`Pattern matching` also works with parametrized types:

```haskell
mInt :: Maybe Int
mInt = Just 9

num :: Int
num = case mInt of
    Just n  -> n
    Nothing -> 0

main = print num
```

The `Either` type has 2 parameters and represents the existence of a value with
type `e` or a value with type `t`.

```haskell
data Either e t = Left e | Right t
```

We can use `Either String t` to represent an error message when a result of
type `t` cannot be obtained.

```haskell
err :: Either String Int
err = Left "Could not obtain the number"
```

## Functions

When we see an arrow `->` in a type, we know it is a function.

Every function receives an `a` and gives a `b` as result.

```haskell
f :: a -> b
```

Functions indicate their body with `=`.

```haskell
f :: Int -> Int
f x = x + 3

main = print (f 5)
```

The same function can be implemented inline as a lambda

```haskell
f :: Int -> Int
f = \x -> x + 3

main = print (f 5)
```

We can "combine" functions using the `.` operator, called `composition`, so
that if we have `g . f` then `f` will produce an intermediate result to be
taken by `g` to produce a final result:

```haskell
f :: Int -> Int
f x = x + 3

g :: Int -> Int
g x = x * 5

h :: Int -> Int
h = g . f -- be careful with the order

main = print (h 2)
```

A function can give a function as result and we can use this mechanism
to make new definitions:

```haskell
f :: Int -> (Int -> Int)
f x = \y -> x + y

add5 = f 5

main = print (add5 6)
```

Parenthesis in that type signature can be omitted, and we can also evaluate
the `f` function with all the parameters at once:

```haskell
f :: Int -> Int -> Int
f x = \y -> x + y

main = print (f 5 6)
```

We can also move the `y` parameter to the left side, just to make it easier
to read:

```haskell
f :: Int -> Int -> Int
f x y = x + y

main = print (f 5 6)
```

A function can receive a function as parameter, but then those parenthesis
are required to maintain precedence. We don't know what the `h` function
does, but we know it can be used over an `Int` like `3`.

```haskell
g :: (Int -> Int) -> Int
g h = h 3

f x = x + 2

main = print (g f) -- g consumes f function
```

`Pattern matching` can also be used to define a function piece-by-piece

```haskell
fib 0 = 0
fib 1 = 1
fib x = fib (x - 1) + fib (x - 2)

main = print (fib 10)
```

Definitions can be shared across function pieces using a `where` section

```haskell
g 0 = 1 + y + z
g x = x + y + z
  where
    y = 5
    z = 10

main = print (g 2)
```

## Typeclasses

When types are generic, function body can only use known operations.

Here type `a` could be any type, so `x` can only be returned as-is.

```haskell
id' :: a -> a
id' x = x

main = print (id' 5)
```

We can define a set of operations, then types could implement them,
that is called `typeclass`.

As example a type which fulfils the `Eq` typeclass will have all its
functions available.

```haskell
class Eq a where
    (==) :: a -> a -> Bool
    (/=) :: a -> a -> Bool
    (/=) x y = not (x == y)
```

We can see that `Ord` needs `b` to implement `Eq`, because it needs
operations from that set.

```haskell
class Eq b => Ord b where
    compare              :: a -> a -> Ordering
    (<), (<=), (>=), (>) :: a -> a -> Bool
    max, min             :: a -> a -> a
```

Typeclass implementation is done via instances for each type.

Here we define `Eq` for the `Bool` type.

Remember that `(/=)` is already defined based on `(==)`.

```haskell
instance Eq Bool where
    (==) True  True  = True
    (==) False False = True
    (==) _     _     = False
```

The type `t` implements `Ord` and `Num` typeclasses, so inside `isPositive`
we can use number and comparison operations over `x` value.

```haskell
isPositive :: (Ord t, Num t) => t -> Bool
isPositive x = compare 0 x
```

## Input/Output

Now we are ready to inspect the type of the `main` function we wrote at the
beginning.

```haskell
main :: IO ()
main = print "hola"
```

The `IO a` type represents a set of instructions that will be executed
by the runtime of Haskell, with something of type `a` as result.

In the case of main `a` is `()`, which is called **unit**, and its only
possible value is `()`.

This means that the `main` function produces a set of instructions to be
executed by the runtime when the program is launched.

We know that `print "hola"` type is also `IO ()` because it should have
the same type that `main` has to be valid code, and we also know that
`"hola"` is a `String`. 

We could think that `print :: String -> IO ()`, but we have been using
`print` with things of other types too, so its type should be something
like `C a => a -> IO ()` with some unknown constraint C.

That constraint is the `Show` typeclass we can see here:

```haskell
class Show a where
    show :: a -> String
    -- plus other definitions
```

Given that `show` function takes something an produces a `String`, then
that function is the missing piece.

Then we can infer that `print` type is `Show a => a -> IO ()`, so `a`
is converted to an `String` which is printed.

This is the definition of the `print` function:

```haskell
print :: Show a => a -> IO ()
print x = putStrLn (show x)
```

As we can see, it uses `show` to obtain an `String`, which will be consumed
by the `putStrLn`, and that is one that has the `String -> IO ()` type we
thought before.

We will see soon how to write bigger programs using `IO a` type, but first
we should talk a bit more about typeclasses.

## Typeclass Laws

Some typeclasses define a set of associated laws which cannot be checked
by the compiler, but the code must follow them to preserve the logic.

Haskell relies on developers to check that their code adheres to the laws,
which could be done via mathematical proofs, but there are also tools to
generate informal tests to check properties (eg. QuickCheck).

We can take as example the `Eq` typeclass we saw before:

```haskell
class Eq a where
    (==) :: a -> a -> Bool
    (/=) :: a -> a -> Bool
```

A valid `Eq` implementation should follow these laws:

- Reflexivity: `x == x = True`
- Symmetry: `x == y = y == x`
- Transitivity: if `x == y && y == z = True`, then `x == z = True`
- Substitution: if `x == y = True`, then `f x == f y = True`
- Negation: `x /= y = not (x == y)`

We can see that our previous `Eq Bool` instance follows *reflexivity* law,
because by definition agrees with `x == x` form:

```haskell
(==) True  True  = True
(==) False False = True
```

Given that our implementation is valid, we can always replace `x == x`
with `True` when we see it, which is useful to simplify our code.

Typeclass laws help us to refactor the code and make it better using known
properties.

## Typeclass Examples

There are many typeclasses defined in the Haskell libraries, the [Typeclassopedia](https://wiki.haskell.org/Typeclassopedia) is a good place to start learning more details
about the standard typeclasses, but I will mention here some of the most common
ones and their laws, just as reference, there is no need to memorize them now
because they will become familiar as time passes.

1. **Semigroup Typeclass**

    Types which fulfil `Semigroup` api should implement `(<>)` function, also
    called `append`.

    ```haskell
    class Semigroup a where
        (<>) :: a -> a -> a
        -- other definitions...
    ```

    The following property, called **associativity**, should be true for
    any valid `Semigroup` instance:

    - `(x <> y) <> z = x <> (y <> z)`

    We can use `(<>)` function to take to things of the same type and produce
    a combined result also of the same type.

    ```haskell
    s1 = "hola"
    s2 = "mundo"

    main = print (s1 <> s2)
    ```

    Each `Semigroup` instance defines how those things are combined, in this
    case `String` concatenation occurs.

2. **Functor Typeclass**

    Types which fulfil `Functor` api implement `fmap` function.

    ```haskell
    class Functor t where
        fmap :: (a -> b) -> t a -> t b
        -- other definitions...
    ```

    The following properties should be true for any valid `Functor` instance:

    - `fmap id  ==  id`
    - `fmap (f . g)  ==  fmap f . fmap g`

    We can use `fmap` over a parametrized type `t a` to apply a function
    `a -> b` which takes things of type `a` to produce things of type `b`.

    Here `fmap` is applied over a parametrized `List Int` to apply `f` function
    which will add 3 to each integer inside the list, obtaining a new list with
    the same shape but new values.

    ```haskell
    xs :: [Int]
    xs = [1, 2, 3]

    f :: Int -> Int
    f x = x + 3

    main = print (fmap f xs)
    ```

    Remember, `fmap` behavior depends on the specific parametrized type we are
    working with, eg. in the case of data structures usually allows us to apply
    a function over each element preserving the structure shape.

3. **Applicative Typeclass**

    Types which fulfil `Applicative` api should implement the required functions
    (ie. `pure`, `(<*>)`, etc) and must have a `Functor` instance as well, so
    the `fmap` function will be available as well.

    ```haskell
    class Functor t => Applicative t where
        pure :: a -> t a
        (<*>) :: t (a -> b) -> t a -> t b
        -- other definitions...
    ```

    The following properties should be true for any `Applicative` instance:

    - `pure id <*> v = v`
    - `pure (.) <*> u <*> v <*> w = u <*> (v <*> w)`
    - `pure f <*> pure x = pure (f x)`
    - `u <*> pure y = pure ($ y) <*> u`

    The `pure` function is really useful when working with a parametrized type
    `t a` (eg. `IO a`, `Maybe a`, etc) because it allows us to take something
    of type `a` and generate a value of type `t a` in a predefined way.

    ```haskell
    main = pure ()
    ```

    This example shows a program which does nothing, but it is interesting
    anyway because we can see how `pure` obtains a `IO a` from an `a`, which
    in this case is the unit type.

4. **Monad Typeclass**

    Any type which implements `Monad` will have a `(>>=)` operation, called
    `bind`, it should also implement `Applicative` and `Functor` api as well,
    so we also have the `pure` and `fmap` functions available for `Monad`
    instances.

    ```haskell
    class Applicative m => Monad m where
        (>>=) :: forall a b. m a -> (a -> m b) -> m b
        -- other definitions...
    ```

    When we see `mf >>= k` we know `k` consumes something of type `a` obtained
    from `mf` (because `mf :: m a` and `k :: (a -> m b)`), so we can say `k` is
    a **continuation**, because it could be the next piece to be executed.

    Keep in mind that the following properties are required for any valid
    `Monad` instance:

    - `pure a >>= k  =  k a`
    - `mf >>= pure = mf`
    - `mf >>= (\x -> k x >>= h)  =  (mf >>= k) >>= h`

    The `>>=` function is useful when we have something of a parametrized type
    `t a` and we want to process the values of type `a` with the condition that
    in the end we should produce something of type `t b`.

    ```haskell
    f :: Int -> String
    f n = "n = " <> show n

    mInt :: Maybe Int
    mInt = Nothing

    main = print (mInt >>= (pure . f))
    ```

    In the example we have `mInt` of type `Maybe Int` and we would like to
    process that `Int` with the function `f` to obtain an `String`, so we
    use the bind function `>>=` to do handle this and give `pure . f` as
    continuation, so it conforms with the expected type `Int -> Maybe String`.

    The parametrized type `Maybe a` has a bind implementation which is
    intelligent enough to note that the `a` (ie. `Int`) doesn't exist,
    because `mInt` value is `Nothing`, so bind avoids calling `pure . f`
    as the continuation expects the `Int` to be there.

    We can se that `pure . f` uses `pure` to conform with `Int -> Maybe Int`
    type, and it could have consumed an `Int` if `mInt` had it
    (eg. `mInt = Just 4`).

    As we can see, bind mechanism and meaning are related to the parametrized
    type which implements the `Monad` instance, so we need to understand that
    type very well before learning about the inner working of a certain
    typeclass instance.

## Do-notation

Finally, as promised, we can see how to write bigger programs using `IO a`
type.

First we can see a piece of code which uses `(>>=)` operator to obtain a
`String` written by the user and then prints it to the console.

```haskell
main = getLine >>= putStrLn
```

We can rewrite it using an explicit parameter named `line`, which is produced
by `getLine` subroutine and passed to the continuation (remember that when we
see something like `mf >>= k`, then `k` is the continuation).

```haskell
main = getLine >>= (\line -> putStrLn line)
```

As this gets tiring really quickly, Haskell defines a special syntax called
`do-notation`, which we can use to write equivalent code in a more familiar
style.

Like in 2nd example `getLine` result is available as `line` value.

```haskell
main = do
    line <- getLine
    putStrLn line
```

As a final example we have an imperative-style program which asks the user
for an input and then iterates over the elements of a list printing the
user input each time.

```haskell
import Control.Monad (forM_)

xs = [1..10]

main = do
    line <- getLine
    forM_ xs $ \x -> do
        putStrLn (line <> show x)
```

There are other ways to write this program, but this can feel familiar to
programmers which already know other languages.
