// All variables listed so the same data can be used for all the models
data {
  int<lower=0> n;
  vector[n] wt;
  vector[n] disp;
  vector[n] am;
  vector[n] mpg;
}

parameters {
  real alpha;
  real beta_disp;
  real beta_am;
  real<lower=0> sigma;
}

transformed parameters{
  vector[N] mu;
  mu = alpha + beta_disp*disp + beta_am*am;
}

model {
  mpg ~ normal(mu, sigma);
}

generated quantities {
  vector[N] log_lik;
  for (i in 1:N)
    log_lik[i] = normal_lpdf(mpg[i] |mu[i] , sigma);
}