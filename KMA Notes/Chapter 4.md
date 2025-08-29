# Chapter 4 - Techniques in Computability Theory

**Goal:** Determine the computational status of a partial function.

The Enumeration Theorem permits the use of an interpreter macro $X:=\Phi(Y,Z)$, which has the following interpretation:
    Let $x, y, \text{ and } z$ be the values of the variables above respectively, prior to execution. If $\phi_y(z)$ is defined then $\Phi$ will terminate leaving the value in $X$. If $\phi_y(z)$ is undefined then $\Phi$ will never terminate.

## Parametrization

Suppose $\theta: \mathbb{N}^2 \rightarrow \mathbb{N}$ is some computable partial function in $x$ and $y$. Fix $x=c$. Then the function $\theta'(c,y)$ is also a computable partial function.

**Q:** What is the index $e$ for $\theta'(c,y)$?

**A:** We can effectively obtain such a thing from the $s$-$m$-$n$ theorem.

**Example:** Define the function

$$
    \psi_1(x,y) = \begin{cases}
        y &\text{ if } \phi_x(x) \text{ is defined.} \\
        \text{undefined} &\text{ otherwise}
    \end{cases}
$$

This function is effectively computable as $\phi_x(x)$ is either defined or it isn't. That is the halting problem is *semi-decidable*. Here is a While-program to compute the function above:

```pascal
    begin
        X1:= x
        X2:= y
        X1:= $\Phi(x,x)$
        X1:= X2
    end
```

**Example:** Define the function

$$
    \psi_2(x,y) = \begin{cases}
        y &\text{ if } \phi_2(x) \text{ is defined} \\
        0 &\text{ otherwise}
    \end{cases}
$$

If this function were effectively computable then the halting problem would be decidable which we've seen that it's not. There's a seeming contradiction here just as we saw with the confuse program. If $\phi_x(x)$ is undefined then $\phi_2(x,y)=0$.

**Q:** How is this possible? $\psi_2$ halts but $\phi_x$ goes into an infinite loop on input $x$.

**Example:** Let $\sigma: \mathbb{N} \rightarrow \mathbb{N}$ and $\mu:\mathbb{N} \rightarrow \mathbb{N}$ be two computable functions such that $\sigma \leq \mu$. This means that $\sigma(y)$ is defined then $\mu(y)$ is also defined. Here we have that $\sigma(y) = \mu(y)$ as $\sigma$ is a subset of $\mu$ as ordered. pairs.

We define a new function

$$
    \psi_3(x,y) = \begin{cases}
        \mu(y) &\text{ if } \phi_x(x) \text{ is defined} \\
        \sigma(y) &\text{ otherwise}
    \end{cases}
$$

**Q:** What seems to be happening here?

**A:** We're asking for $\sigma(y)$ to be output with $\phi_x$ in an infinite loop on input $x$.

However $\sigma \leq \mu$ if $\sigma(y)$ is defined then its equal to $\mu(y)$. We compute $\phi_3$ is the following manner:

* State the computation of $\sigma(y)$ and $P_x$ on input $x$ in parallel.
* If there is a result for $\sigma(y)$ halt. For $\sigma(y) = \mu(y)$ in either case.
* If $P_x$ halts on input $x$ before $\sigma(y)$ finishes, then stop computing $\sigma(y)$ and start computing $\mu(y)$. If and when $\mu(y)$ halts output the result.
* By Church's thesis, there exists an index $e$ such that $\phi_3(x,y) = \phi_e^{(2)}(x,y)$.

**Example:** Define $T(x,y,z)$ by the following:

$$
    T(x,y,z) = \begin{cases}
        1 &\text{ if } P_x \text{ on input } y \text{ halts within } z \text{ steps } \\
        0 &\text{ otherwise}
    \end{cases}
$$

This function is easily seen to be effectively computable. One should run $P_x$ on input $y$ for a maximum of $z$ steps. If it halts output 1. If not output zero. Note that $\phi_x$ is defined on $y$ if and only if $T(x,y,z) = 1$ for some $z$. Notice that $T:\mathbb{N}^2 \rightarrow \{0,1\}$ is a total function.

* Step counting is an important measure of complexity. We now embark on an algorithm to convert a program $P_x$ to a program $P_w$ that computes

$$
    \theta(y,z) = \begin{cases}
        1 &\text{ if } P_x \text{ halts on input } y \text{ within } x \text{ steps.} \\
        0 &\text{ otherwise}
    \end{cases}
$$

a. Setup a counter $C$ initially set to 0.
b. Has $C$ reached the value $z$?
    i. Yes - Output the value 0
    ii. No - increment $C$ by 1
c. If we get to the end of the program without using our alloted $z$ steps we output 1.

**Setup:**

```pascal
    C:= 0
    T:= X2 \leftarrow z
    X2:= 0
    $\tilde{P}_x$
```

where $\tilde{P}_x$ is the program $P_x$ is modified so that no more than $z$ steps are taken. The While-loop program is as follows:

```pascal
    begin
        C:= 0
        T:= X2
        X2:= 0
        $\tilde{P}_x$
        exit:
            if C <= T then X1:=1
            else X1:= 0
    end
```

The transformation takes $P_x$ to $\tilde{P}_x$ is defined inductively as follows:

* If $S$ is an assignment statement, then 

```pascal
    begin S
        C:= succ(C)
        if C > T then goto exit
    end
```

If $S$ is a compound statement of the form 

```pascal
    begin
        S1; S2; \cdots ; S_n
    end
```

Then $\tilde{S}$ is 

```pascal
    begin
        $\tilde{S1}, \tilde{S2}, \ldots , \tilde{S_n}$
    end
```

For a while statement of the form ```while``` $Xi \neq Xj$ ```do``` $S1$. We must increment the counter every time we test $Xi \neq Xj$. In this case our modified statement is:

```pascal
    begin
        while not (Xi = Xj) do
            begin
                C:=succ(C)
                if C > T then goto exit
                $\tilde{S1}$
            end
        C:=succ(C)
        if C > T then goto exit
    end
```

## The $s$-$m$-$n$ Theorem

**Goal:** To understand functions that essentially rewrite programs syntactically.

Let's consider the function 

$$
    \phi_i^{(m+n)}(y_1, \ldots, y_m, z_1, \ldots, z_n)
$$

There is a program $P_i$ that computes this function. For the sake of argument, let's say that it is a $k$-variable program. The variables $X1, \ldots, Xk$ are loaded with the first $k$ values. Recall that

a. extra variables are set to zero
b. extra inputs are ignored

Then $P_i$ is executed and if this computation halts the value of $\phi_i^{(m+n)}(y_1, \ldots, y_m, z_1, \ldots, z_n)$ is the value in the variable $X1$.

### A First attempt

Consider the program that follows applied to the input $(z_1, \ldots, z_n)$.

```pascal
    begin
        Xm+1 := X1
        ...
        Xm+n := Xn
        X1 := y1
        ...
        Xm := ym
    end
```
This is meant to transform the state of variables $X1, \ldots, Xm, Xm+1, \ldots, Xm+n$ from $(x_1, \ldots, x_n, 0, \ldots, 0)$ to $y_1, \ldots, y_m, z_1, \ldots, z_n)$.

Unfortunately, the program fragment has a problem. Once $m_1 \leq n$ because $Xm+1 := X1$ as the old $Xm+1$ has been overwritten before it can be put in its new position.

### Second Try

We make an adjustment as follows: (call it program $Q$)

```pascal
    begin
        Xm+n+1 := X1
        ...
        Xm+n+n := Xn
        X1 := y1
        ...
        Xm := ym
        Xm+1 := Xm+n+1
        ...
        Xm+n := Xm+n+n
        Xm+n+1 := 0
        ...
        Xm+n+n := 0
    end
```

We then let program $P_j$ be

```pascal
    begin
        Q
        P_i
    end
```

Once we know the values of $y_1, \ldots, y_m$ and $i$ we can compute the index of the program. Call it $e$. Thus we can write $e = s_n^m (i, y_1, \ldots, y_m)$ where the function $s_n^m:\mathbb{N}^{n+1} \rightarrow \mathbb{N}$ is total and computable.

**Remark:** That $s_n^m$ is total does not imply that $P_i$ or $P_e$ are total as functions. This function simply modifies the program $P_i$ by inserting a number of assignment statements in a symmetric way. Hence.

$$
    \phi^{(n)}_{s^m_n(y_1, \ldots, y_m)}(z_1, \ldots, z_n) = \phi_i^{(m+n)}(y_1, \ldots, y_m, z_1, \ldots z_n)
$$

**Theorem:** (Parametrization Theorem)

There exists a total computable function $s^m_n:\mathbb{N}^{n+1} \rightarrow \mathbb{N}$ such that

$$
    \phi^{(n)}_{s^m_n(y_1, \ldots, y_m)}(z_1, \ldots, z_n) = \phi_i^{(m+n)}(y_1, \ldots, y_m, z_1, \ldots z_n)
$$

The parametrization theorem is more commonly known as the $s$-$m$-$n$ theorem for the letters involved. We are able to "pull down" $m$ variables into the parameter list.

**Remark:** This parametrization is in no way unique. As most named things in mathematics, it is so because it's useful.

**Theorem:** (Program Form)

Let $P_e$ be a program and $y_1, \ldots, y_m \in \mathbb{N}$. If we replace any $m$ occurrences of any variables in the text of $P_e$ with $y_1, \ldots, y_m$ respectively then the resulting program is $P_{f(y_1, \ldots, y_m)}$ where $f$ is a total computable function.

## Let's Talk Compositions

Let $\phi_a$ and $\phi_b$ be two computable functions in one variable. Then $\phi_a \circ \phi_b$ is also computable. There is some index $c$ such that $\phi_c = \phi_a \circ \phi_b$. Then there is some $\mu:\mathbb{N}^2 \rightarrow \mathbb{N}$ such that $\mu(a,b) = c$. Then we can write $\phi_{\mu(m,n)} = \phi_m \circ \phi_n$.

**Q:** Is $\mu$ computable? Is $\mu$ total?

**A:** The answer should be yes. The index of the program can be obtained from concatenating three blocks of code:

1. The While-program decoding of $n$ to get $P_n$.
2. A block of code setting all variable except $X1$ to zero.
3. The While-program decoding of $m$ to get $P_m$.

The function $\mu(m,n)$ is total. We don't need to run $P_n$ or $P_m$ to obtain the index $\mu(m,n)$.

Define a function $\theta(m,n,x) = \phi_m \circ \phi_n(x)$. This is a computable function. Hence, there exists an index $e$ such that

$$
    \phi_e(m,n,x) = \theta(m,n,x) = \phi_m \circ \phi_n(x) = \phi_{s(e,m,n)}(x)
$$

If we fix $e$, then we can set $h(m,n) = s(e,m,n)$ and obtain $\phi_{h(m,n)}(x) = \phi_m \circ \phi_n(x)$, where $h$ is a total computable functin.

## Undecidable Problems

**Q:** Given a natural number $n$ and a prime $p$, does $p$ divide $n$?

**Q:** Given two graphs $G$ and $H$, is $G \cong H$?

**Q:** Given a graph $G$, is $G$ connected?

Each of these questions can be answered in a yes or no response. We can craft such things into decision problems.

**Definition:** We say that a problem is decidable or solvable if there is an algorithm, or in our case a While-loop program that will yield the correct answer for any instance of the problem. If no such algorithm exists, we say that the problem is undecidable.

**Remark:** We've seen that the halting problem is unsolvable.

There are two standard techniques for showing that a problem is undecidable:

a. Diagonalization
b. Reduction

**Proposition:** There is a total function $f:\mathbb{N} \rightarrow \mathbb{N}$ which is not computable.

*Proof.* 
    Consider a countable but not necessarily effective enumeration of all computable total functions $\mathbb{N} \rightarrow \mathbb{N}$

$$  
    f_0, f_1, \ldots, f_i, \ldots \hspace*{.25in}  i \in \mathbb{N}
$$

Define $f:\mathbb{N} \rightarrow \mathbb{N}$ by $f(i) = f_i(i)+1$ which is clearly a total function. If $f$ is computable there exists an index $e$ such that $f_e = f$ which would yield $f_e(e) = f_e(e)+1$ which is a contradicition. We conclude that $f$ is not computable.

Let $\theta_0, \theta_1, \ldots, \theta_n, \ldots$ be a sequence of computable functions. We say that the sequence is an effective enumeration if there is some total computable function such that $\theta_n = \phi_{g(n)}$ for all $n \in \mathbb{N}$, where $\phi_0, \phi_1, \ldots, \phi_n, \ldots$ is our standard enumeration.

**Proposition:** Let $f_0, f_1, \ldots, f_i, \ldots$ with $i \in \mathbb{N}$ be an effective enumeration, in which every $f_i$ is a total computable function $\mathbb{N} \rightarrow \mathbb{N}$. Then there is a total computable function $f: \mathbb{N} \rightarrow \mathbb{N}$ which does not appear in this effective enumeration.

*Proof.*
    Since $f_0, f_1, \ldots, f_i, \ldots$ is an effective enumeration, there exists a total computable function $g:\mathbb{N} \rightarrow \mathbb{N}$ such that $\phi_{g(i)}=f_i$. We now define $f: \mathbb{N} \rightarrow \mathbb{N}$ by diagonalizing over the functions in the sequence so that $f(i) = f_i(i) + 1$. Notice that $f$ is a total computable function by the While-program

```pascal
    begin
        X2:=g(X1)
        X1:=\Phi(X2,X1)
        X1:=succ(X1)
    end
```

However, $f$ differs from itself on its own index. We've arrived at a contradiction.

*Corollary:* 
    There can be no effective enumeration of all of the total computable functions $\mathbb{N} \rightarrow \mathbb{N}$.

**Goal:** We endeavor to show that

$$
    \left\{ \text{Total Computable} \text{ Functions }\right\} \leq_m \left\{ \text{Totality Problem}\right\}
$$

**Theorem:** There is no algorithm which, when presented with index $i$ of an arbitrary computable function $\phi_i:\mathbb{N} \rightarrow \mathbb{N}$ that can decide whether $\phi_i$ is total or not.

*Proof.*
    Define the total function $\text{total}: \mathbb{N} \rightarrow \mathbb{N}$ by

$$
    \text{total}(i) = \begin{cases}
        1 &\text{ if } \phi_i \text{ is total} \\
        0 &\text{ otherwise }
    \end{cases}
$$

Suppose that total is computable by some While-program. Then we may define a total computable function $g: \mathbb{N} \rightarrow \mathbb{N}$ by

* $g(0)=$ the smallest $i$ such that $\text{total}(i)=1$.
* $g(n+1)=$ the smallest $i$ greater than $g(n)$ such that $\text{total}(i)=1$.

The following program computes $g$:

```pascal
    begin
        X1 := n
        X2 := succ(X1)
        X1 := 0
        while not(X2 = 0) do
            while total(X1) = 0 do 
                X1 := succ(X1)
                X2 := pred(X2)
    end
```

Then $\phi_{g(0)}, \phi_{g(1)}, \ldots, \phi_{g(i)}, \ldots$ is an enumeration of all total computable functions. We've seen that this is not possible.

**Theorem:** (General Halting Problem)
    There is no algorithm which, when presented with index $i$ of an arbitrary computable function $\phi_i:\mathbb{N} \rightarrow \mathbb{N}$ and an arbitrary argument $a \in \mathbb{N}$, can decide if $\phi_i$ is defined on the input $a$.

*Proof.*
    We begin by defining the total function

$$
    h(i,j) = \begin{cases}
        1 &\text{ if } \phi_i(j) defined \\
        0 &\text{ otherwise}
    \end{cases}
$$

Notice that $h(i,i) = \text{halt}(i)$ and we know that $\text{halt}(i)$ is not effectively computable. This reduces HALT to General HALT.

**Equivalence Problem:** 

* **Input:** Two Programs $P$ and $P'$.
* **Output:** Yes / No
* **Decision:** Do $P$ and $P'$ compute the same function?

**Lemma:** Consider the family of all computable functions $\phi_i:\mathbb{N} \rightarrow \mathbb{N}$. The function

$$
    e(i) = \begin{cases}
        1 &\text{ if } \phi_i = id \\
        0 &\text{ otherwise}
    \end{cases}
$$

is not effectively computable.

*Proof.*
    We begin by defining the program $P_{g(i)}$ as follows:

```pascal
    begin
        X2:=\Phi(i,X1)
    end
```

where $g$ is a total computable function by the $s$-$m$-$n$ theorem. So

$$
    \phi_{g(i)}(j) = \begin{cases}
        j &\text{ if } \phi_i(j) \text{ is defined} \\
        \perp &\text{ otherwise}
    \end{cases}
$$

Now, observe that $\phi_{g(i)}$ is identity if and only if $\phi_i$ is toatl. Consider the composition

$$ 
    e(g(i)) = \begin{cases}
        1 &\text{ if } \phi_{g(i)} = id \\
        0 &\text{ otherwise}
    \end{cases}
$$

which is equal to

$$
 \begin{cases}
        1 &\text{ if } \phi_i \text{ is total} \\
        0 &\text{ otherwise}
    \end{cases}
$$

and this is the function $\text{total}(i)$. We know that total is not computable, we conclude that $e$ cannot be computable either.

**Theorem:** (Equivalence Problem)
    There is no algorithm, when given a pair of indices $i$ and $j$ of arbitrary computable functions, that can decide if $\phi_i = \phi_j$.

*Proof.*
    We define the total function

$$
    \text{equivalent}(i,j) = \begin{cases}
        1 &\text{ if } \phi_i = \phi_j \\
        0 &\text{ otherwise}
    \end{cases}
$$

The identity function is certainly computable. Let $j$ be an index for $id = \phi_j$. Now define $e(i) = \text{equivalent} (i,j)$ as we did before. We've seen that $e$ is not computable and therefore equivalent is not computable either.