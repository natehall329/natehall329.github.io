# 2-Factor Confirmatory Factor Analysis: Stan vs lavaan vs Mplus
# Author: Example code for CFA comparison

library(rstan)
library(lavaan)
library(bayesplot)
library(ggplot2)

# Generate example data for 2-factor CFA
set.seed(123)
n <- 1000
lambda1 <- c(0.8, 0.7, 0.9)  # loadings for factor 1
lambda2 <- c(0.6, 0.8, 0.7)  # loadings for factor 2

# True factor scores
f1 <- rnorm(n)
f2 <- rnorm(n, mean = 0.3 * f1)  # correlated factors

# Observed variables
y1 <- lambda1[1] * f1 + rnorm(n, 0, sqrt(1 - lambda1[1]^2))
y2 <- lambda1[2] * f1 + rnorm(n, 0, sqrt(1 - lambda1[2]^2))
y3 <- lambda1[3] * f1 + rnorm(n, 0, sqrt(1 - lambda1[3]^2))
y4 <- lambda2[1] * f2 + rnorm(n, 0, sqrt(1 - lambda2[1]^2))
y5 <- lambda2[2] * f2 + rnorm(n, 0, sqrt(1 - lambda2[2]^2))
y6 <- lambda2[3] * f2 + rnorm(n, 0, sqrt(1 - lambda2[3]^2))

data_cfa <- data.frame(y1, y2, y3, y4, y5, y6)

# =============================================================================
# STAN MODEL
# =============================================================================

stan_model_code <- "
data {
  int<lower=0> N;          // number of observations
  int<lower=0> P;          // number of observed variables
  int<lower=0> K;          // number of factors
  matrix[N, P] Y;          // observed data matrix
  matrix[P, K] Lambda_pattern;  // pattern matrix (0s and 1s)
}

parameters {
  matrix[N, K] eta;        // factor scores
  vector<lower=0>[P] psi;  // unique variances
  vector[6] lambda_free;   // free factor loadings (6 total: 3 per factor)
  cholesky_factor_corr[K] L_Phi;  // Cholesky factor of factor correlation
}

transformed parameters {
  matrix[P, K] Lambda;
  matrix[K, K] Phi;
  
  // Construct loading matrix
  Lambda[1, 1] = lambda_free[1];  // y1 -> f1
  Lambda[2, 1] = lambda_free[2];  // y2 -> f1
  Lambda[3, 1] = lambda_free[3];  // y3 -> f1
  Lambda[4, 2] = lambda_free[4];  // y4 -> f2
  Lambda[5, 2] = lambda_free[5];  // y5 -> f2
  Lambda[6, 2] = lambda_free[6];  // y6 -> f2
  
  // Set non-loading elements to zero
  Lambda[1, 2] = 0;
  Lambda[2, 2] = 0;
  Lambda[3, 2] = 0;
  Lambda[4, 1] = 0;
  Lambda[5, 1] = 0;
  Lambda[6, 1] = 0;
  
  // Factor correlation matrix
  Phi = multiply_lower_tri_self_transpose(L_Phi);
}

model {
  // Priors
  to_vector(eta) ~ std_normal();
  psi ~ inv_gamma(2, 1);
  lambda_free ~ normal(0, 2);
  L_Phi ~ lkj_corr_cholesky(1);
  
  // Likelihood
  for (n in 1:N) {
    Y[n,]' ~ multi_normal(Lambda * eta[n,]', diag_matrix(psi));
  }
}

generated quantities {
  matrix[P, P] model_cov;
  model_cov = Lambda * Phi * Lambda' + diag_matrix(psi);
}
"

# Prepare data for Stan
Lambda_pattern <- matrix(c(
  1, 0,  # y1 loads on factor 1
  1, 0,  # y2 loads on factor 1  
  1, 0,  # y3 loads on factor 1
  0, 1,  # y4 loads on factor 2
  0, 1,  # y5 loads on factor 2
  0, 1   # y6 loads on factor 2
), nrow = 6, byrow = TRUE)

stan_data <- list(
  N = nrow(data_cfa),
  P = ncol(data_cfa),
  K = 2,
  Y = as.matrix(data_cfa),
  Lambda_pattern = Lambda_pattern
)

# Set options for Stan compilation
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

# Fit Stan model with error handling
tryCatch({
  stan_fit <- stan(model_code = stan_model_code, 
                   data = stan_data,
                   chains = 4,
                   iter = 2000,
                   cores = 4,
                   verbose = FALSE,
                   refresh = 0)
}, error = function(e) {
  cat("Stan compilation failed. Trying alternative approach...\n")
  
  # Alternative: compile model first, then sample
  compiled_model <- stan_model(model_code = stan_model_code)
  stan_fit <<- sampling(compiled_model,
                       data = stan_data,
                       chains = 4,
                       iter = 2000,
                       cores = 4,
                       verbose = FALSE,
                       refresh = 0)
})

# =============================================================================
# LAVAAN MODEL
# =============================================================================

lavaan_model <- '
  # Factor loadings
  f1 =~ y1 + y2 + y3
  f2 =~ y4 + y5 + y6
  
  # Factor correlation (default)
  f1 ~~ f2
'

lavaan_fit <- cfa(lavaan_model, data = data_cfa, 
                  estimator = "ML", std.lv = TRUE)

# =============================================================================
# MPLUS SYNTAX (for reference)
# =============================================================================

mplus_syntax <- '
TITLE: 2-Factor Confirmatory Factor Analysis
DATA: FILE IS data.dat;
VARIABLE: 
  NAMES ARE y1 y2 y3 y4 y5 y6;
  
MODEL:
  f1 BY y1 y2 y3;
  f2 BY y4 y5 y6;
  
OUTPUT: STANDARDIZED TECH1;
'

# =============================================================================
# RESULTS COMPARISON
# =============================================================================

print("=== STAN RESULTS ===")
print(stan_fit, pars = c("lambda_free", "L_Phi", "psi"))

print("\n=== LAVAAN RESULTS ===")
summary(lavaan_fit, fit.measures = TRUE, standardized = TRUE)

print("\n=== MPLUS SYNTAX ===")
cat(mplus_syntax)

# Extract and compare parameter estimates
stan_summary <- summary(stan_fit)$summary
lavaan_params <- parameterEstimates(lavaan_fit)

print("\n=== PARAMETER COMPARISON ===")
print("Factor loadings comparison:")
print("Stan lambda estimates:")
print(stan_summary[grep("lambda_free", rownames(stan_summary)), "mean"])
print("Lavaan standardized loadings:")
print(subset(lavaan_params, op == "=~")$std.all)

# Posterior predictive checks for Stan
y_rep <- extract(stan_fit, "model_cov")$model_cov
mcmc_hist(stan_fit, pars = "lambda_free")