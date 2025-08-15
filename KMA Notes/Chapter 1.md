# Chapter 1

## Motivating Computability

The first chapter runs through a number of basic concepts and attempts to provide motivation via the Halting problem. They start by giving a notion of a computable function. A computable function is one whose output can be obtained by an algorithm. The authors give the example:

$$
    f(x) = \begin{cases}
        1 & \text{ if FLT is true} \\
        0 & \text{ if FLT is false}
    \end{cases}
$$

where FLT is Fermat's Last Theorem. At the time of the writing, FLT was unsolved. This function is computable by the classical theory even though an answer to it was unknown for quite some time. A different function that makes the same point is the following:

$$
    g(x) = \begin{cases}
        1 & \text{ if Continuum Hypothesis is True} \\
        0 & \text{ if Continuum Hypothesis is False}
    \end{cases}
$$

We know that CH is either true or false, but we'll more than likely never know which. However, the function $g(x)$ is computable in the classical sense. 

It's also a total function. Given a natural number $x$, we can get an output. One says that a function $t:\mathbb{N} \rightarrow \mathbb{N}$ is a *total function* if the domain of $t$ is $\mathbb{N}$. 

**Q:** What if the domain is just some subset of $\mathbb{N}$?

**A:** We say that $\theta: \mathbb{N}^k \rightarrow \mathbb{N}$ is a partial function if $\text{Dom } \theta$ is some proper subset of $\mathbb{N}^k$. We allow for the possiblility that $\text{Dom } \theta = \varnothing.$ This is referred to as the empty function.

As with Enderton, the authors use the word *relation* to mean a subset of $\mathbb{N}^k$, the $k$-fold Cartesian product of the natural numbers.

In computability theory, the empty function is one that is not defined for any $x$. One way to look at this is to say that the function will not terminate for any $x$. We could do the following in Haskell:

```haskell
    empty x = empty x
```
While this function will never terminate, it certainly is not safe in code. We can use the ```Void``` type from ```Data.Void``` to do the following:
```haskell
    empty:: Void -> Int
    empty x = case of {}
```
We can't ever produce something of ```Void``` type. As the documentation states, "```Void``` values don't logically exist". Documentation is [here](https://hackage.haskell.org/package/base-4.21.0.0/docs/Data-Void.html) if the reader is interested.

We'll use ```empty``` to indicate that we are calling the function with empty domain. This causes problems in real-life as we can't actually call a function with ```Void``` type, and in the other case the function simply runs in an infinite loop. However, this non-halting behavior is exactly the perspective taken in computability theory.

There is a short discussion that there are various models of computation. The models that one might run into are:
1. Turing Machines
2. While Loop programs
3. Register Machines
4. $\lambda$-Calculus
5. The theory of generally recursive partial functions.

Church's Thesis is stated in the following manner:

**Church's Thesis:** The Turing, Kleene, and program specifications of algorithms are each complete.

This isn't a theorem in the sense that it can be proved. It is a statement that comes out of the fact that all of the descriptions of computability that have been presented, have been shown to be equivalent. The Church-Turing thesis is presented in various forms depending on the context of the text. Manin's book on Mathematial logic presents it in terms of computable functions and recursive functions. Sipser in his *Theory of Computation* doesn't really give a formal statement but has a figure stating that the intuitive notion of being algorithmic is equivalent to any model of a Turing Machine that we can come up with. 

In the second section, their is a discussion of while programs and the Halting Problem. Suppose that $P_1, P_2, \ldots, P_k, \ldots$ is an enumeration of the possible programs. There is a short discussion of encodings and why such a thing should be possible. There are some details such as if a natural number does not represent the encoding of some $P_k$ we take it to be the program that computes the function with empty domain. The position of the program $P_j$ in the master list is said to have *index* $j$. This is of course reminicsent of the index of a Turing Machine for those that have seen such things.

The following total function is defined: $f: \mathbb{N} \rightarrow \mathbb{N}$

$$
    f(x) = \begin{cases}
     1 &\text{ if } P_k \text{ halts on input } x \\
     0 &\text{ if } P_k \text{ fails to halt on input } x
    \end{cases}
$$

If such a *characteristic function* were computable then the *Halting Problem* would be deemed *decidable*. The following set

$$
    K = \\{(k,x) \mid P_k \text{ halts on } x \\}
$$

is not recursive and is a restatement of the above. The idea to showing this is that we can create a contradiction by *diagonalization*.

The way the author's do this is by discussing a program called "Confuse". I like this approach as it is descriptive regarding what's being accomplished.

Define the following *semicharacteristic function*:

$$
    \psi(x) = \begin{cases} 
        1 &\text{ if } f(x) = 0 \\
        \text{ undefiend } &\text{ otherwise}
    \end{cases}
$$

Suppose we have a function that decides the Halting problem and call it ```halt(n)```. Now consider the following program:
```haskell
    confuse x 
        | halt e == 0 = 1
        | otherwise = empty x
```
Now, let's take a look at what's occurring here. The program itself has some index, call it $e$ and $P_e$ the program above. Let $e$ be the input and ask: What does program $P_e$ do on input $e$?

* Suppose ```confuse e``` results in 1. That is the program ```confuse``` halted on input ```e```. This means that ```halt``` did not terminate on input ```e``` as ```halt e == 0```. If ```halt``` failed to stop how did ```confuse``` halt?
* Now suppose that ```confuse e``` is undefined. This means that ```halt``` stopped on input ```e``` and output a 1. However, ```confuse``` did not halt.

In either case, ```halt``` failed to output the proper result for ```confuse``` the program with index ```e```. 

**Conclusion:** The Halting Problem is undecidable. 

Let's make another note not discussed in the book. Notice that the Halting Set is *semidecidable* (*recursively enumerable*, *Turing Recognizable*). Define the following semicharacteristic function: $\chi: \mathbb{N}^2 \rightarrow \mathbb{N}$

$$
    \chi(k, x) = \begin{cases}
        1 &\text{ if program } P_k \text{ halts on input } x \\ 
        \text{undefined} & \text{otherwise}
    \end{cases}
$$

The function $\chi$ is effectively computable as we can create an algorithm that will ignore the output of $P_k$ and output 1 instead.


**Q:** Why is this referred to as a diagonalization argument?

**A:** Consider the Cartesian product $\mathbb{N} \times \mathbb{N}$. The diagonal is the set

$$
    \Delta = \\{(x,x) \mid x \in \mathbb{N} \\}
$$  

In our above argument, we considered the program $P_e$ on input $e$. In terms of the Halting set above this is $(e,e)$ for every index $e$.

### In the Exercises

In the exercises, there is mention of Hilbert's 10th the problem that is stated as follows:

**Hilbert's 10th Problem:** Given a polynomial $p(x)$ with integral coefficents, does there exist an algorithm to decide if $p(x)$ has integer solutions?

It was shown, via the work of Davis, Matiyasevich, Putnam and Robinson, that no such algorithm exists. It sometimes goes by the name "MRDP Theorem".

However, the decision problem for a Diophantine equation is easy.

**Input:** $p(x,y) \in \mathbb{Z}[x,y]$ and $(a,b)$ a proposed solution to $p(x)

**Output:** *Yes* if $p(a,b) = 0$ and *No* if $p(a,b) \neq 0$.

That is we can *verify* solutions to a diophantine problem in a reasonable amount of time. The above can be modified to any number of variables that one wants.

Of course, just because there is no algorithm to decide the problem in general, does not mean that we can't efficiently decide some problems. For instance, we all learned the quadratic formula in Algebra class to solve equations of the form $ax^2 + bx + c = 0$.
