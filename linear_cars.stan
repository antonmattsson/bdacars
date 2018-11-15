data {
	int<lower=0> n;
	vector[n] x;
	vector[n] y;
}

parameters {
	real alpha;
	real beta;
	real<lower=0> sigma;
}

model {
	y ~ normal(alpha + beta*x, sigma);
}
