# Chapter 2 - While Programs

The following are some notes about while programs as presented in the book. As usual, I give some thoughts about accomplishing these kinds of things in Haskell. The book mentions that there is a translation from While programs into programs that operate on languages. The authors mention the operations ```car```, ```cdr```, ```cons```, and assigning ```nil``` or an atom to a list in Lisp in another section. Such a translation gives some intuitive justification for the idea that the theory is independent of a particular programming language or paradigm for representing information. 

The authors also make a bit of a deal out of not allowing recursion. This allows for a certain kind of finiteness in unwinding a while loop. That as some subroutine is called, that subroutine can be assumed to stop on a "good" computation and it won't continue due to calling itself. While I understand the reasoning behind this, as noted before while loops certainly yield to infinite loops in certain circumstances which can be quite useful. The author's have their method of iteration via the while loop and there is no reason to confuse anything further by introducing recursion and having to ensure that it halts.

## Setup for While Loop Programs

The functions that one gets for "free" are as follows:
a. The constant function $zero(n) \equiv 0$.
b. Successor and predecessor functions defined as:

$$
    \text{succ} \, (x) = \begin{cases}
        0 &\text{ if } x < 0 \\
        x+1 &\text{ if } x \geq 0 
    \end{cases}
$$

and

$$
    \text{pred} \, (x) = \begin{cases}
        0 &\text{ if } x \leq 0 \\
        x-1 &\text{ if } x > 0
    \end{cases}
$$

Here are the things that we are allowed to do and use:

    a. Variable names - a finite string of upper case letters and numbers which starts with an upper case letter.

    b. A relation symbol $\neq$ which compares the values of pairs of variables.

    c. Program symbols - begin, end, while, do along with:
        i. assignment symbol ($:=$)
        ii. semicolon

    d. The functions that are given to us for free. For instance, we can assign 0 to the variable $X$ by $X:= 0$.

The authors talk about how if we can only start with a value $X:=0$ then something like $X:=n$ is a *macro statement*. That is it's an assignment of the natural number $n$ to $X$ that needs to be justified by a While loop program. However, this is easy enough to accomplish. Start with the assignment $X:=0$ and take its successor until you get to $X:=n$. I will spend no more time on this and accept that we can do such a thing without difficulty.

## Macro Statements

We define a macro statement to be a representation of a While loop program in a condensed form. For instance, we do not want to write out the While loop program for $X:=n$ every time we want to do variable assignment. Before we list some of these macros statements, many of which are easily justified, we define the *monus* operator:

$$
    x \dot{-} y = \begin{cases}
        x - y &\text{ if } x \geq y \\
        0 &\text{ otherwise } 
    \end{cases}
$$ 

The authors then make the following proposition:

**Prop.** The following are macro statements in the language of While programs:

    a. $Y:=X$
    b. $X:=n$
    c. $Z:=X+Y$
    d. $Z:=X\dot{-}Y$
    e. $Z:=X \cdot Y$
    f. $Z:=X \text{ div } Y$
    g. $Z:=X ** Y$ (exponentiation)

### An Example

**Goal:** Write a program that sums the value of two variables. The output should be put into a variable $Z$.

**Algorithm:**

* **Input:** Nonnegative values for $X$ and $Y$
* **Output:** $X + Y$ in the variable $Z$.

    1. Assign $X$ to the variable $Z$.
    2. Add the value of $Y$ to $Z$.

We've already discussed that step 1 is possible and is in our list of macro statements above. Step 2 might look something like this:

```pascal
    begin
        U:=0;
        while U not Y do
            begin
                Z:=succ(Z)
                U:=succ(U)
            end
    end
```

We can then summarize the whole macro statement to sum two variables as $Z:=X+Y$.

**Q:** How would we accomplish such a thing in Haskell?

**A:** Somewhat differently. I think that one of the interesting things in making a translation is that variables in Haskell are treated as constant functions and do not change. We pass things along to make sure that the base case is reached by using composition of functions. Perhaps something like this would be the way to do it:

```haskell
    pred :: Int -> Int -> Int
    pred x 
        |x <= 0 = 0
        |otherwise = x - 1
    
    succ :: Int -> Int -> Int
    succ x
        | x < 0 = 0
        | otherwise = x + 1
        
    sum :: Int -> Int -> Int
    sum x y
        |y==0 = x
        |y/=0 = sum(succ(x), pred(y))
```

## Computable Functions

We begin with defining a state of computation. A $k$-variable statement $S$ is a statement that takes $k$ values, though they may not all be used.

A *state of computation* for a $k$-variable While-program is a $k$-dimensional vector over the natural numbers. This will also be referred to as a *state vector*.

### Example

Consider the following example:

```pascal
    begin
        X1:=0
        while not X1 == X2
            X1 := succ(X1)
    end
```

| Description | Instruction | State |
| ----------- | ----------- | ----- |
| Initial State |           | $(4,2)$ |
| Set Variable | $X1 := 0$ | $(0,2)$ |
| Test | $X1 \neq X2$ ? | $(0,2)$ |
| Set Variable | $X1:= \text{succ } X!$ | $(1,2)$|
| Test | $X1 \neq X2$ ? | $(1,2)$ |
| Set Variable | $X1:= \text{succ } X1$ | $(2,2)$|
| Test | $X1 \neq X2$ ? | $(2,2)$|

* The state $(4,2)$ is the inital state or the start state for the computation.
* Each state gives us a "snapshot" of the computation at each step.
* We will use a sequence of states followed by instructions to describe a computation.

Let $P$ be a $k$-variable While-program. A computation by $P$ is a sequence, possibly infinite, of the form

$$
    a_0 A_1 a_1 A_2 a_3 \cdots a_i A_{i+1}a_{i+1} \cdots 
$$

where
* The $a_i$'s are $k$-dimensional state vectors
* The $A_i$'s are instructions appearing in $P$.
* If the computation sequence is finite, then it has the form 

$$
    a_0 A_1 a_1 A_2 a_3 \cdots a_i A_{i+1}a_{i+1} \cdots a_{n-1}A_na_{n}
$$

where $a_n$ is the last state of the computation and $n$ is the *length* of the computation.

We need some consistency conditions for these sequences of states and instructions. Each of these conditions ensures that the sequence for the computation is well-formed.


a. $A_1$ is the first instruction in $P$ and the sequence of instructions $A_1, A_2, \cdots, A_i, \cdots$ appears along a flow path. If the sequence is finite, we want the sequence to terminate with $A_n$ be a "good" halt; that $A_n$ is the last instruction encountered in the path before exit.

b. If $A_i$ is a test instruction then $a_{i-1}$ and $a_i$ are the same. If $A_i$ is of the form $X_u := g(X_v)$ then

$$
    a_i = (a_1, \ldots, a_{u-1}, g(a_v), \ldots, a_{k-1}, a_k)
$$

where $g$ is either ```pred```, ```succ``` or ```zero```.

c. If $A_i$ is an assignment instruction, then $A_i+1$ is the next instruction in $P$ otherwise the sequence is finite and $A_i$ is the last instruction. If $A_i$ is a test instruction of the form $X_u \neq X_v$ ?, where $1 \leq u,v \leq b$ and $a_{i-1} = (a_1, \ldots, a_k) \in \mathbb{N}^k$ and $a_u \neq a_v$, then $A_{i+1}$ is the first instruction of in the body of the While loop. If $a_u = a_i$ then $A_{i+1}$ is the first instruction after the body of the while loop or the last instruction.

**Prop.** Let $P$ be a $k$-variable While-program and $a_0$ an arbitrary $k$-tuple of natural numbers. Then there is exactly one computation by $P$ that has $a_0$ as its initial state vector.

*Remark:* A computation done via one of these programs is *deterministic*; that is you get exactly the same output every time you put a specific $a_0$ in to start the program. If this were not the case, programming would be a lot less useful for solving programs. If I could get more than one answer from some initial state, how would we differentiate the outputs to be the one we wanted?

We now define a couple of terms that will give us language to talk about a computation:

* If the computation by $P$, which starts with $a_0$ is infinite, we say that $P$ *diverges* on input $a_0$ and its output is undefined.
* If on the other hand, the sequence is finite of length $n$ we say that $P$ *converges* on input $a_0$ and has output $a_n$.

We are now in a position to interpret a While-program $P$ as a function on the natural numbers.

**Goal:** Given a $k$-variable program $P$, we wish to interpret $P$ as a way of computing a function $\phi_P: \mathbb{N}^j \rightarrow \mathbb{N}$.

We define the function for a $k$-variable program $P$ to be $\phi_P: \mathbb{N}^j \rightarrow \mathbb{N}$ in the following way:

**Output:** If $P$ halts and $b$ is the final state vector in the computation, we set the value of $\phi_P$ on the inital state vector $a_0$ to be $b$.

**Case 1:** $k \geq j$

We calculate $\phi_P(a_1, \ldots, a_j)$ by applying $P$to the initial vector $(a_1, \ldots, a_j, 0, \ldots, 0)$ where there are $k-j$ zeros at the end of this vector.

**Case 2:** 

We apply $P$ to the first $k$ arguments ignoring the last $j-k$ arguments.

We now get to the crux of our goal:

We say that a function $\psi: \mathbb{N}^j \rightarrow \mathbb{N}$ is *effectively computable* if $\psi = \phi_P$ for some While-program $P$. If we want to emphasize the number of input variables we write $\phi_P^{(j)}$

* The use of the term *effectively computable* versus *computable* can cause some issues when reading other resources. It is not unusaul for the adjective effective to get dropped. It also is equally common for computable to mean that the program has a finite sequence of computation for every input vector.
* One often sees the phrase "partial function" or "recursive partial function". In each case, it is possible that the function is defined on a subset of $\mathbb{N}^j$.
* To say that a function is *total*, we mean that the function is defined on the entirety of $\mathbb{N}^j$.

We end with a restatement of Chruch's Thesis:

Any partial function $\mathbb{N}^j \rightarrow \mathbb{N}$ that can be algorithmically defined can be computed by some While-program.