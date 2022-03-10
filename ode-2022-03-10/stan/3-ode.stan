functions {

  vector ode_system(real t, vector y, real beta) {
    vector[1] dy_dt;
    dy_dt[1] = beta * y[1];

    return dy_dt;
  }
  
}
data {
  int<lower = 0> N;
  vector[N] t;
  vector[N] y;
}
parameters {
  real<lower = 0> alpha;
  real beta;
  real<lower = 0> sigma;
}
transformed parameters {
  vector[N] y_hat;

  {
    array[N - 1] vector[1] y_hat_array =
      ode_bdf(ode_system, [alpha]', 0.0, to_array_1d(t[2:N]), beta);

    y_hat[1] = alpha;
    for (n in 1:(N - 1))
      y_hat[n + 1] = y_hat_array[n][1];
  }
}
model {
  alpha ~ normal(0, 1);
  beta ~ normal(0, 1);
  sigma ~ normal(0, 1);
  
  y ~ lognormal(y_hat, sigma);
}
generated quantities {
  vector[N] y_rep;
  for (n in 1:N) {
    y_rep[n] = lognormal(log(y_hat[n]), sigma);
  }
}
