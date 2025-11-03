data {
  int<lower = 1> N;
  vector[N] y;
}
parameters {
  real mu;
  real<lower = 0> sigma;
}
model {
  // https://mc-stan.org/cmdstanr/articles/profiling.html
  profile("likelihood") {
    for (n in 1:N) {
      y[n] ~ normal(mu, sigma);
    }
  }
}
