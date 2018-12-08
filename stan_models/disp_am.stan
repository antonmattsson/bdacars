// All variables listed so the same data can be used for all the models
data {
  int<lower=0> n;
  vector[n] wt;
  vector[n] disp;
  vector[n] am;
  vector[n] lp100km;
}

parameters {
  real alpha;
  real beta_disp;
  real beta_am;
  real<lower=0> sigma;
}

transformed parameters{
  vector[n] mu;
  mu = alpha + beta_disp*disp + beta_am*am;
}

model {
  // Priors
  alpha ~ cauchy(0,10);
  beta_disp ~ student_t(3,0,2);
  beta_am ~ student_t(3,0,2);
  sigma ~ normal(0, 10);
  // The linear model
  lp100km ~ normal(mu, sigma);
}

generated quantities {
  vector[n] log_lik;
  for (i in 1:n)
    log_lik[i] = normal_lpdf(lp100km[i] |mu[i] , sigma);
}
