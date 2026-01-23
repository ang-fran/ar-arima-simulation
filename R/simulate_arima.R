rm(list = ls())
set.seed(0)

# ---- Function to simulate ARIMA(p,d,q) ----
simulate_arima = function(phi = NULL, theta = NULL, d = 0, T = 500, y0 = NULL, sigma = 1) {
  p = length(phi)
  q = length(theta)
  
  # Generate white noise
  e = rnorm(T, 0, sigma)
  y = numeric(T)
  
  # Initial values
  if (!is.null(y0)) {
    y[1:p] = y0
  } else if (p > 0) {
    # Default initial values are zeros
    y[1:p] = rep(0, p)
  }
  
  # Generate ARMA part
  for (t in (p+1):T) {
    ar_term = ifelse(p > 0, sum(phi * rev(y[(t-p):(t-1)])), 0)
    ma_term = ifelse(q > 0, sum(theta * rev(e[(t-q):(t-1)])), 0)
    y[t] = ar_term + ma_term + e[t]
  }
  
  # Apply differencing if d > 0
  if (d > 0) {
    y = diff(y, differences = d)
  }
  
  return(y)
}

# ---- Example simulations ----
T = 1000

# ARIMA(1,0,1) (AR(1) MA(1) with no difference)
y_arima_101 = simulate_arima(phi = 0.5, theta = 0.3, d = 0, T = T)

# ARIMA(1,0,0) (AR(1) with no difference)
y_arima_100 = simulate_arima(phi = 0.7, theta = 0, d = 0, T = T)

# ARIMA(2,1,0) (AR(2) on first difference)
y_arima_210 = simulate_arima(phi = c(0.4,-0.2), theta = NULL, d = 1, T = T)

# ARIMA(0,1,1) (MA(1) on first difference)
y_arima_011 = simulate_arima(phi = NULL, theta = 0.6, d = 1, T = T)


# ---- Fit using base R arima() to verify ----
fit_101 = arima(y_arima_101, order = c(1,0,1))
fit_100 = arima(y_arima_100, order = c(1,0,0))
fit_210 = arima(y_arima_210, order = c(2,1,0))
fit_011 = arima(y_arima_011, order = c(0,1,1))

# Print estimated coefficients
cat("ARIMA(1,0,1) estimated:\n")
print(fit_101)

cat("ARIMA(1,0,0) estimated:\n") # Same as AR(1)
print(fit_100)

cat("\nARIMA(2,1,0) estimated:\n")
print(fit_210)

cat("\nARIMA(0,1,1) estimated:\n")
print(fit_011)

# ---- Plot examples ----
png("figures/arima_101.png", width = 800, height = 600)
ts.plot(y_arima_101, main="ARIMA(1,0,1) φ = 0.5, θ = 0.3 (stationary)")
dev.off()
