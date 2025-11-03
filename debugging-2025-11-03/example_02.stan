transformed data {
  int N = 0;
  vector[N] y;
}
parameters {
  real mu;
  real sigma;
}
model {
  y ~ normal(mu, sigma);
}
