# Application

Various biological processes which exhibit multi-stationary or oscillatory behaviour are modelled via *feedback loops*. These loops constitute ubiquitous control mechanisms expressing that a change in the value of some biological variable, e.g., the concentration of an amino acid, results in a (re-)adjustment of its value. A common example is homeostasis, where the production of, e.g., an amino acid is regulated based on its current concentration. If its concentration is initially high, but decreasing, then its production is initially inhibited and later activated, once its concentration levels fall below a threshold. As a result, the concentration of the amino acid oscillates around a specified value.

We provide an implementation of the formalisation of biological feedback loops that was proposed in the work of [Srinivasan et al.](https://link.springer.com/article/10.1007/s10994-021-06038-y). Their approach models feedback loops by combining an Event Calculus dialect with the Kinetic Logic, i.e., a representation of delayed changes in biological variables through asynchronous automata. 

The task is to compute the values of all variables in a loop at each time-point. These values depend only on the initial values of the variables in the loop and the temporal length of their delayed value changes.

The code we provide supports the following three feedback loops. Refer to the work of Srinivasan for a thorough description of these loops.

![simple negative loop](figures/simple_neg.png "A simple negative loop") ![immune response](figures/immune.png "Immune system response") ![phage infection](figures/phage.png "Phage infection") 

# Directory Structure
- /src. The source code of our Prolog implementation, including the formalisations of the aforementioned loops and helper predicates for running experiments en masse and measuring their execution times.
- /results. Directory of the execution logs.
- /scripts. 
    * run\_immune\_response.sh. Reproduces our experiments with GKL-EC on the feedback loop for immune response (Figure 4, middle). 
    * run\_phage\_infection.sh. Reproduces our experiments with GKL-EC on the feedback loop for phage infection (Figure 4, right). 

