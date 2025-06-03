# *Computable Functions* by Shen & Vereshchagin

*A function $f:A \rightarrow B$ is said to be a partial function whose domain is a subset of $A$. We allow the domain to be empty.

* A partial function $f:A \rightarrow B$ is said to be a total partial function if $\operatorname{Dom} f = A$.

* A function $f:\mathbb{N}_0 \rightarrow \mathbb{N}_0$ is said to be computable if there exists an algorithm $M$ that computes $f$. The algorithm $M$:
  
    a. halts on input $n$ and outputs $f(n)$ if $f$ is defined at $n \in \mathbb{N}$.
    
    b. the algorithm $M$ does not halt if $f$ is not defined at $n$.

* A set $X \subseteq \mathbb{N}_0$ is said to be decidable if there exists an algorithm $M$ that determines if $n \in \mathbb{N}_0$ belongs to $X$.

* A set $X \in \mathbb{N}_0$ is said to be enumerable if there exists an algorithm $M$ that outputs the element of $X$ and only those elements.
  
  * This is equivalent to:

        a. A set is enumerable if it is the domain of a computable function.

        b. A set is enumerable if it is the range of a computable function.

        c. A set $X$ is enumerable if its semicharacteristic function is computable.

        d. A set $X$ is enumerable if either:

            i. $X = \varnothing$
            ii. $X$ is in the range of a total computable function.

* We say that a function $U: \mathbb{N}_0 \times \mathbb{N}_0 \rightarrow \mathbb{N}_0$ is universal for the class of computable functions in one variable if:

    a. The sections $U_n$ are computable for each $n$ and

    b. all computable functions occur as a section of $U$ for some $n$.

* We say that a set $C$ separates two disjoint sets $X$ and $Y$ if $C$ contains one of the sets and empty intersection with the other.

* A set $X \subseteq \mathbb{N}_0 is said to be immune if it is infinite and only has a finite number of enumerable subsets.

* A set $X$ is said to be simple if its complement is immune.

* The numberings of computable functions that correspond to Godel universal functions are called Godel numberings.
