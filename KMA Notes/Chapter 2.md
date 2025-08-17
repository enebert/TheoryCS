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
        |y\=0 = sum(succ(x), pred(y))
```