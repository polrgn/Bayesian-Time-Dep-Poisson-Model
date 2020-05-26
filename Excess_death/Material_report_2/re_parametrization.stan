

data{ 
  int <lower = 0> N;
  real E[N];
  int O[N];

  real sigma_a;
  real sigma_b;
  real alpha_mu;
  real alpha_sigma;
  real beta_a;
  real beta_b;
  real sigma_time_mu;
  real sigma_time_sigma;
  
}

parameters{
  real log_theta_tilde[N];
  real log_theta_time[N];
  real <lower  = 0> sigma;
  real alpha;
  real <lower=-1, upper=1> beta;
  real<lower=0> sigma_time;
}


transformed parameters {
  real log_theta[N];
  log_theta[1] = sigma * log_theta_tilde[1];
  for (i in 2:N)
    log_theta[i] = sigma * log_theta_tilde[i];
}


model{
  O[1] ~ poisson(E[1]* exp(log_theta[1]));
    log_theta_tilde[1]~ normal(0,1);
    log_theta_time[1] ~ normal(0,1);
  for (i in 2:N){
    O[i] ~ poisson(E[i]* exp(log_theta[i] + log_theta_time[i]));
    log_theta_tilde[i]~ normal(0,1);
    log_theta_time[i] ~ normal(alpha+beta*log_theta_time[i-1], sigma_time);
  }
  sigma ~ uniform(sigma_a,sigma_b);
  
  alpha ~ normal(alpha_mu,alpha_sigma);
  beta ~ uniform(beta_a,beta_b);
  sigma_time ~ normal(sigma_time_mu,sigma_time_sigma);
}



