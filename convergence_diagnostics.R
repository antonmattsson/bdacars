library(rstan)
library(loo)
library(ggplot2)
library(gridExtra)
YOUR_WD_HERE <- "C:/"
setwd(YOUR_WD_HERE)
# Load data
data(mtcars)

# Data to be fed to Stan
stan_dada = list(n = nrow(mtcars),
                 wt = mtcars$wt,
                 disp = mtcars$disp,
                 am = mtcars$am,
                 mpg = mtcars$mpg)

# Modeling based on model selection
best_model <- stan("wt_disp.stan", data=stan_dada, model_name="wt_disp", iter=11000)

# View n_eff and R_hat values
print(best_model)

# Check divergence
divergence <- get_sampler_params(best_model, inc_warmup=FALSE)[[1]][,'divergent__']
sum(divergence)

# Percentage
sum(divergence) / length(divergence)

# Nothing to see here