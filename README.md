# Two-Envelope Paradox Simulation

This R script simulates the classic **Two-Envelope Paradox** under varying envelope value multipliers and tracks the outcomes of sticking versus switching choices over multiple iterations.

## Features

- **Customizable number of simulations** (`--num_sim`)
- **Customizable envelope multiplier** (`--multiplier`)
- Tracks:
  - Chosen value (if you stick)
  - Switched value (if you switch)
  - Rolling means of each
  - Rolling mean benefit of switching
- Generates:
  - Console output summary of results
  - A two-panel `.jpg` plot:
    - **Top subplot**: Rolling mean if you stick vs. switch
    - **Bottom subplot**: Rolling mean benefit of switching

## Usage

```bash
./two_envelope_simulation.R -n 10000 -m 2
```

This will:
- Run the simulation with 10,000 iterations
- Use a multiplier of 2 between the two envelope amounts
- Save a plot as `plots/two_envelope_plot_m-2.jpg`

## Output Example

```
-----------------------------------------------------
Mean payoff per choice            :      80.25
Mean payoff per switched choice   :      96.40
Mean benefit on switching         :      16.15
Net amount of times when in profit:      5786
-----------------------------------------------------
Time taken for 10000 simulations  :      0.41 seconds
-----------------------------------------------------
```

## Dependencies

Make sure to install the required R libraries:

```r
install.packages(c("optparse", "ggplot2", "reshape2", "gridExtra"))
```

## Notes

- This code is intended to explore the behavior of the paradox in a probabilistic setting.
- The plot clearly illustrates the difference in long-term average payoffs between sticking and switching.

---

*Generated: 2025-05-10 09:53:12*
