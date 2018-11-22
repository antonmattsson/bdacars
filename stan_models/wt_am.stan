// All variables listed so the same data can be used for all the models
data {
  int<lower=0> n;
  vector[n] wt;
  vector[n] am;
  vector[n] mpg;
}

parameters {
  real alpha;
  real beta_wt;
  real beta_am;
  real<lower=0> sigma;
}

transformed parameters{
  vector[n] mu;
  mu = alpha + beta_wt*wt + beta_am*am;
}

model {
  mpg ~ normal(mu, sigma);
}

generated quantities {
  vector[n] log_lik;
  for (i in 1:n)
    log_lik[i] = normal_lpdf(mpg[i] |mu[i] , sigma);
}