

# 2,  Solved Problems

## 2.1,  Run MATLAB in Terminal, Mac

Save the following expressions in `.zshrc` or `.bash_profile` file (open terminal, in home directory `~`, execute `open .zshrc`). Note that you may need to change the version of the MATLAB.

```
# Load MATLAB
alias matlab="/Applications/MATLAB_R2019a.app/bin/matlab -nodesktop"
```

Besides, you have to write the following code to avoid the popping up of the figure window.

```matlab
fig = figure("Visible", "off");
fig = plot(vecX, vecY);
saveas(fig, [pwd '/images/fig.png']);
```

## 2.2,  Set Working Directory of MATLAB

```
cd Documents/GitHub/StochasticSim
addpath("/Users/fengguangjie/Documents/GitHub/StochasticSim")
```
