data {
  int<lower=1> N;
  vector[N] log_sat;
  vector[N] log_pm;
}

parameters {
  real beta0;
  real beta1;
  real<lower=0> sigma;
}

model {
  target += normal_lpdf(log_pm | beta0 + beta1 * log_sat, alpha)
  target += normal_lpdf(sigma | 0, 1) + normal_lpdf(beta | 0, 1) + normal_lpdf(beta1 | 1, 1)
}

generated quantities {
  vector[N] log_lik;
  vector[N] log_pm_rep;
  
  for (n in 1:N) {
    real log_pm_hat_n = beta0 + beta1 * log_sat[n];
    log_lik[n] = normal_lpdf(log_pm[n] | log_pm_hat_n, sigma);
    log_pm_rep[n] = normal_rng(log_pm_hat_n, sigma);
  }
}