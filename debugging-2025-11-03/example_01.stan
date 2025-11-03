transformed data {
  int N = 10;
  vector[N] y;
}
parameters {
  real mu;
  real sigma;
}
model {
  for (n in 1:N) {
    y ~ normal(mu, sigma);
  }
}
