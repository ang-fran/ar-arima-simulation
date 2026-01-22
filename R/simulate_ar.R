rm(list = ls())

#  ---- Function to simulate AR(p) ----
simulate_ar = function(phi, T = 500, y0 = NULL, sigma = 1) {
  p = length(phi)
  y = numeric(T)
  e = rnorm(T, 0, sigma)
  
  # Initial values
  if (is.null(y0)) {
    # y[1:p] = rnorm(p, 0, sigma)  # random starting values
  } else {
    y[1:p] = y0
  }
  
  # Generate AR process
  for (t in (p+1):T) {
    y[t] = sum(phi * rev(y[(t-p):(t-1)])) + e[t]
  }
  
  return(y)
}

# ---- Stationarity check function ----
check_stationarity_ar = function(phi) {
  # phi: numeric vector of AR coefficients (length p)
  p = length(phi)
  
  # Construct characteristic polynomial coefficients
  # polynomial: 1 - phi1 B - phi2 B^2 - ... - phip B^p
  poly_coefs = c(1, -phi)
  
  # Compute roots of characteristic polynomial
  roots = polyroot(poly_coefs)
  
  # Stationarity condition: all |roots| > 1
  stationary = all(Mod(roots) > 1)
  
  # Return list for convenience
  return(list(stationary = stationary,
              roots = roots))
}


# ---- Example simulations ----
T = 500

# AR(1) stationary
y_ar1_stat = simulate_ar(phi = 0.7, T = T)

# AR(1) non-stationary
y_ar1_nonstat = simulate_ar(phi = -1.01, T = T)

# AR(2) stationary
y_ar2_stat = simulate_ar(phi = c(-0.2,0.3), T = T)

# AR(2) non-stationary
y_ar2_nonstat = simulate_ar(phi = c(1.1,0.8), T = T)

# ---- Check stationarity ----
phi_list = list(
  AR1 = 0.7,
  AR1_ns = -1.01,
  AR2 = c(-0.2, 0.3),
  AR2_ns = c(1.1,0.8),
  AR3 = c(0.5,-0.2,0.1)
)

for(name in names(phi_list)){
  res = check_stationarity_ar(phi_list[[name]])
  cat(name, "stationary:", res$stationary, "\n")
  print(Mod(res$roots))
}

# ---- Plot and save examples ----
# Case: AR(1)
png("figures/ar1_stationary.png", width = 800, height = 600)
ts.plot(y_ar1_stat, main="AR(1) φ = 0.7 (stationary)")
dev.off()

png("figures/ar1_nonstationary.png", width = 800, height = 600)
ts.plot(y_ar1_nonstat, main="AR(1) φ = -1.01 (non-stationary)")
dev.off()

# Case: AR(2)
png("figures/ar2_stationary.png", width = 800, height = 600)
ts.plot(y_ar2_stat, main="AR(2) φ = (-0.2,0.3) (stationary)")
dev.off()

png("figures/ar2_nonstationary.png", width = 800, height = 600)
ts.plot(y_ar2_nonstat, main="AR(2) φ = (1.1,0.8) (non-stationary)")
dev.off()