# Extract convergence diagnostics
# fit = stan fit object
# model name = string, e.g. "wt_am"
# Returns: a data frame of convergence diagnostics
convergence_diagnostics <- function(fit, model_name){
  # parameter names (split the model name by "_", add beta_ prefix + alpha, sigma)
  params <- c("alpha", paste0("beta_", unlist(strsplit(model_name, split="_"))), "sigma")
  # Get summary table
  smry <- summary(fit, pars=params)
  # Extract only the most relevant columns
  smry <- as.data.frame(smry$summary)[c("mean", "se_mean", "sd", "n_eff", "Rhat")]
  smry
}
