data {
  int<lower = 1> N;
  vector[N] x;
  vector[N] y;
}
parameters {
  real a;
  real b;
  real sigma;
}
model {
  y ~ lognormal(exp(-a * x) + exp(-b * x), sigma);
}
