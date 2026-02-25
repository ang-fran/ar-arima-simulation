rm(list = ls())

set.seed(0)

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
  
  return(ts(y))
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

# ---- Visualization ----

# ---- Global figure settings
plot_width  = 1600
plot_height = 900
plot_res    = 150

plot_params = function() {
  par(
    mar = c(5, 4, 6, 2),  # bottom, left, top, right
    cex = 1.25,           # base scaling (ticks etc.)
    cex.main = 3,       # title scaling
    cex.lab = 1.35,       # axis label scaling
    cex.axis = 1.15       # tick label scaling
  )
}

save_png = function(filename, expr) {
  png(filename, width = plot_width, height = plot_height, res = plot_res)
  on.exit(dev.off(), add = TRUE)
  plot_params()
  expr
}

# AR(1) Stationary
save_png("figures/ar1_stationary.png", {
  ts.plot(
    y_ar1_stat,
    main = expression(AR(1)~phi==0.7~"(stationary)"),
    ylab = expression(y[t]),
    xlab = "Time"
  )
})

# AR(1) Non-stationary
save_png("figures/ar1_nonstationary.png", {
  ts.plot(
    y_ar1_nonstat,
    main = expression(AR(1)~phi==-1.01~"(non-stationary)"),
    ylab = expression(y[t]),
    xlab = "Time"
  )
})

# AR(2) Stationary
save_png("figures/ar2_stationary.png", {
  ts.plot(
    y_ar2_stat,
    main = expression(AR(2)~phi==c(-0.2,0.3)~"(stationary)"),
    ylab = expression(y[t]),
    xlab = "Time"
  )
})

# AR(2) Non-stationary
save_png("figures/ar2_nonstationary.png", {
  ts.plot(
    y_ar2_nonstat,
    main = expression(AR(2)~phi==c(1.1,0.8)~"(non-stationary)"),
    ylab = expression(y[t]),
    xlab = "Time"
  )
})

# PACF AR(1) (stationary)
save_png("figures/pacf_ar1.png", {
  pacf(
    y_ar1_stat,
    main = "PACF: AR(1) stationary",
    ylab = "Partial ACF",
    xlab = "Lag"
  )
})

# PACF AR(2) (stationary)
save_png("figures/pacf_ar2.png", {
  pacf(
    y_ar2_stat,
    main = "PACF: AR(2) stationary",
    ylab = "Partial ACF",
    xlab = "Lag"
  )
})
