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


# Modeling
model_names <- c("wt_disp", "wt_am", "disp_am", "wt_disp_am")
models <- list()
for(mname in model_names){
  fit <- stan(paste0(mname,".stan"), data=stan_dada, model_name = mname)
  models[[mname]] <- fit
}

# Model comparison
psisloos <- c()
p_effs <- c()
kvals <- c()
for(model in models){
  loglik <- extract_log_lik(model, merge_chains = FALSE)
  r_eff <- relative_eff(exp(loglik))
  loocv <- loo(loglik, r_eff = r_eff)
  
  # PSIS-LOO value
  psisloo <- loocv$estimates[1]
  
  # Effective parameters
  p_eff <- loocv$estimates[2]
  
  # k-values
  kval <- loocv$diagnostics$pareto_k
  
  # Save
  psisloos <- c(psisloos, psisloo)
  p_effs <- c(p_effs, p_eff)
  kvals <- c(kvals, kval)
}

# Visualisation
ks1 <- as.data.frame(kvals[1:32])
p1 <- ggplot(data=ks1, aes(x=seq(1, 32, 1), y=kvals[1:(1+31)])) +
  geom_point(color = 'red') +
  geom_hline(yintercept=0.5, color = 'blue') +
  ggtitle("wt_disp") +
  xlab("") +
  ylab("k-value")

ks2 <- as.data.frame(kvals[33:64])
p2 <- ggplot(data=ks2, aes(x=seq(1, 32, 1), y=kvals[33:64])) +
  geom_point(color = 'red') +
  geom_hline(yintercept=0.5, color = 'blue') +
  ggtitle("wt_am") +
  xlab("") +
  ylab("k-value")

ks3 <- as.data.frame(kvals[65:96])
p3 <- ggplot(data=ks3, aes(x=seq(1, 32, 1), y=kvals[65:96])) +
  geom_point(color = 'red') +
  geom_hline(yintercept=0.5, color = 'blue') +
  ggtitle("disp_am") +
  xlab("") +
  ylab("k-value")

ks4 <- as.data.frame(kvals[97:128])
p4 <- ggplot(data=ks4, aes(x=seq(1, 32, 1), y=kvals[97:128])) +
  geom_point(color = 'red') +
  geom_hline(yintercept=0.5, color = 'blue') +
  ggtitle("wt_disp_am") +
  xlab("") +
  ylab("k-value")

grid.arrange(p1, p2, p3, p4, nrow=4, ncol=1)

# PSIS-barplot
psisloosdf <- data.frame(psisloos)
psisbar <- ggplot(data=psisloosdf, aes(x=model_names, y=psisloos)) + geom_bar(stat="identity", width=0.5) +
  geom_hline(yintercept=max(psisloos), color = 'blue')

psisbar
