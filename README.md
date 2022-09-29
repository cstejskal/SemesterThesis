There are three scripts which contain all examples presented in the Numerical Simulation and Results section of the paper.

```Script
MAIN1_convergence_examples.m -->
```
Executes the three example problems in Section 5.1 Convergence to the Target Measure. 
This script requires a working CVX installation in order to execute.

```Script
MAIN2_W_vs_neighbors.m -->
```
Executes the survey of eta in Section 5.2 Optimality-Efficiency Tradeoff with N = 20. 

```Script
MAIN3_W_vs_Q_and_R.m -->
```
Executes the survey of Q,R in Section 5.3 Algorithmic Complexity and Other Observations.

Note that the results of each of these examples can also be generated immediately.
Load the corresponding `.mat` file in `setup_files`, followed by executing `plotResult.m`
