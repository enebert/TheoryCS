# Control Statements, Iteration & State

## Guards

There might be some trepidation about allowing guards when trying to translate a While-progam into Haskell. However, we have accepted doing a test for equality from the beginning. We later brought $>$ and $<$ into the fold. Let's take the following example:

```haskell
    charZero x 
        | x==0 = 1
        | otherwise = 0
```
This can easily be translated into an ```if```-```then``` kind of construct, but this is perhaps not an accurate way to interpret what's happening here. Using guards is about *pattern matching*. Does the input data have the structure that $x=0$? We can look at ```charZero``` as the characteristic function for the one-point set $\{0\}$. We should be able to get the functions for a decidable set without a lot of trouble. 

We resolve having ```if```-```then``` constructs below. It just takes a couple of extra variables to keep track of what needs to be run. 

## Control Statements

**Example:** We can use composite macro statements such as $X:=\text{succ } (Y \dot{-} Z) + \text{pred }(Z)$. This can be seen as the following sequence of instructions:

```pascal
    begin
        TEMP1 := pred(Z)
        TEMP2 := monus(Y,Z)
        TEMP2 := succ(TEMP2)
        X := TEMP2 + TEMP1
    end
```

We will progress forward
    * using composite macro statements without a lot more thought.
    * viewing a statement $S$ as a piece of data and assign it to a variable.

**Proposition:** A statement of the form ```while``` $C$ ```do``` $S$, where $C$ is a test statement and $S$ an arbitrary statement is a macro statement in the language of While-programs.

Without loss of generality we assume that the test $C$ relates variables only and no natural numbers. We can do this because we can assign any natural number $n$ to a variable and consider the constant function $X:=n$. Before we proceed we need to achieve the following:

**Goal:** Given an arbitrary test $C$, write an arithmetic expression $E_C$, in terms of the variables in $C$, such that

$$
    E_C = \begin{cases}
        1 &\text{ if } C \text{ is true} \\
        0 &\text{ if } C \text{ is false}
    \end{cases}
$$

Further, we can view $X \neq Y$ as a boolean test as it is equivalent to $(X < Y) \wedge (X > Y)$. The negation of this is $X = Y$. We take both of these to be composite tests. The atomic tests then are $>$ and $<$.

Now suppose that $C$ is atomic of the form $X < Y$. Take $E_C = (Y \dot{-} X) \dot{-} \text{pred }(Y \dot{-} X)$. Notice that if $X < Y$ then $Y \dot{-} X$ is positive so $E_C=1$. OTOH if $X > Y$ then $Y \dot{-} X$ is zero so both terms are 0. We can do something similar for $>$.

Now that we can find expressions for atomic statements we can put them together in the following manner:

* $C_1 \vee C_2$: $\text{pred } (E_{C_1} + E_{C_2})$
* $C_1 \wedge C_2$: $(E_{C_1} + E_{C_2}) \dot{-} \text{pred }(E_{C_1} + E_{C_2})$
* $\neg C_1$: $1-E_{C_1}$

We are now in a position to produce a set of instructions for the proposition:

```pascal
    begin
        U:= E_C
        V:= 0
        while not U=V do
            begin
                S
                U:=E_C
            end
    end
```

We've made the assumption that $U$ and $V$ are two variables that appear nowhere else in the program. 

We now progress to producing While-programs for the following structure statements:

a. ```if``` $C$ ```then``` $S$

b. ```if``` $C$  ```then``` $S_1$ ```else``` $S_2$

c. ```repeat``` $S$ ```until``` $C$

For (a) we introduce a variable to track if the statement has been run yet. The following program yields the basic ```if```-```then```.

```pascal
    begin
        V:=0
        while C and (V=0) do
            S
            V:=succ(V)
    end
```

For (b) we use the above and introduce another new variable. We run the else by default. If the statement is true we change the flag to not run the else. The program follows:

```pascal
    begin
        V:=0
        W:=0
        while C and (V=0) do
            S_1
            V:=succ(V)
            W:=succ(W)
        while (W=0) do
            S_2
            W:=succ(W)
    end
```

For (c) we need to make sure that it runs at least once. We introduce a variable to ensure that this happens. The program follows:

```pascal
    begin
        V:=0
        while (not C) or (V=0) do
            S
            V:=succ(V)
    end
```

## The State Monad

The ```State``` monad in Haskell allows us to pass state around. As we cannot modify variables, if we truly want to simulate ```while``` we need to pass the state of the loop into the next iteration. That is what we'll do below. Doing *bounded* iteration is perhaps the best place to start.

Documentaton for the ```State``` monad can be found [here](https://wiki.haskell.org/State_Monad)

### For Loop

The for loop is easily turned into a while loop. Here's an example that will iterate four times:

```pascal
    begin
        N:=4
        W:=0
        while not(N=W) do
            S
            W:=succ(W)
    end
```

Let's take a look at the following Haskell code:

```haskell
    for :: Int -> IO() -> StateT Int IO()
    for n f = do
        x <- get
        if x == n
            then do lift f
            else do
                put(x+1)
                lift f
                for n f  
```

There are a couple of Haskell nuances to note here. We are going to get some IO() action to be repeated $n$ times. ```State``` is a pure monad but IO() produces side effects. So, we use the ```StateT``` so that we can transform and mix monads like this.

If we want to have "Happy Birthday!" to be printed four times, we would do something like this:

```haskell
    main = do
        let f = putStrLn "Happy Birthday!"
        evalStateT (for 4 f) 1
```
We've accomplished a model for bounded search.

### Parametrized For Loop

I admittedly had to ask ChatGPT about how to thread / mix monads for the following code. I did not ask ChatGPT to write code for me. Working with state transforms is not something I've ever done before and I've not been able to find good documentation on the topic.

Let's start with a logic condition and build a while loop that will print out a message repeatedly:

```haskell
    type App = State Int IO

    lessThan :: Int -> App Bool
    lessThan num = do
        i <- get
        return (i < num)

    whileLoop :: String -> App Bool -> App ()
    whileLoop msg cond = do
        boolValue <- cond
        when boolValue $ do
            liftIO $ print msg
            modify(+1)
            whileLoop msg cond
```

This is similar to what we did above except we've abstracted out the condtion. As mentioned above, I had a hard time getting the types set up write to make this happen. The ```modify(+1)``` is what's chaging the state of the condtion so we don't end up entering an infinite loop. We can execute the whileLoop by doing something like:

```haskell
 main = do
    let stop = 5
    let startState = 0

    evalStateT(whileLoop "Happy Birthday!" (lessThan stop)) startState
```

### While Loop

Let's now take steps to abstract out the body. We reframe our loop as follows:

```haskell
    while :: App () -> App Bool -> App ()
    while body cond = do
        boolValue <- cond
        when boolVaule $ do
            body
            while body cond
```

Let's write a body for this loop that will countdown a "Liftoff":

```haskell
    countDown :: App ()
    countDown = do
        time <- get
        modify (\x -> x-1)
        liftIO $ putStrLn ("Lift Off in ... ++ show time)
```

Here's how we would get such a thing to run:

```haskell
    main = do
        let stop = 0
        let start = 5

        evalStateT(while countDown (greaterThan stop)) start
```

The ```greaterThan``` is analogous to the ```lessThan``` above. To abstract further, I would need to go further down the road of monads. Not only does this demonstrate that the imparative construct of ```while``` can be emulated in Haskell, we readily see the ease at which abstractions can happen by treating code as data. The difficulty with Haskell is getting all of the type information lined up.