data {
  int<lower = 1> N;
  vector[N] y;
}
parameters {
  real a;
  real b;
  real<lower = 0> sigma;
}
model {
  y ~ normal(a + b, sigma);
}
