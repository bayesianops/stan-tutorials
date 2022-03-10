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
  real<lower = 0> alpha;
  real beta;
  real<lower = 0> sigma;
}
parameters {
}
model {
}
generated quantities {
  vector[N] y;
  vector[N] y_true;

  {
    array[N - 1] vector[1] y_array_true =
      ode_bdf(ode_system, [alpha]', 0.0, to_array_1d(t[2:N]), beta);

    y_true[1] = alpha;
    for (n in 1:(N - 1)) {
      y_true[n + 1] = y_array_true[n][1];
    }

    for (n in 1:N) {
      y[n] = lognormal_rng(log(y_true[n]), sigma);
    }
  }
}
