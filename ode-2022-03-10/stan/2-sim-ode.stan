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
  real alpha;
  real beta;
  real<lower = 0> sigma;
}
transformed data {
  array[0] real x_r;
  array[0] int x_i;
}
parameters {
}
model {
}
generated quantities {
  vector[N] y;

  {
    array[N - 1] vector[1] y_true =
      ode_bdf(ode_system, [alpha]', 0.0, to_array_1d(t[2:N]), beta);

    y[1] = lognormal_rng(alpha, sigma);
    for (n in 1:(N - 1))
      y[n + 1] = lognormal_rng(y_true[n][1], sigma);
  }
}
