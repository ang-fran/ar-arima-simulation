# AR and ARIMA Simulation in R

This repository demonstrates simulation, estimation, and diagnostic analysis of
autoregressive (AR) and autoregressive integrated moving average (ARIMA) models
using R. The focus is on understanding stationarity, model order identification,
integration, and residual diagnostics.

---

## Topics Covered

- AR(1) and AR(2) simulations (stationary and non-stationary)
- Root conditions and stationarity checks
- ACF and PACF for order identification
- ARIMA simulation and differencing for 4 cases with different orders
- Fitting ARMA models to differenced series

---

## AR Simulations

AR processes are simulated under different parameter settings:

- **Stationary AR(1/2):** mean-reverting, ACF decays geometrically
- **Non-stationary AR(1/2):** explosive or near-unit-root behavior
- **Initial values:** set randomly to illustrate typical dynamics

Stationarity for AR(2) is verified using characteristic roots.

---

## ARIMA Simulations

- ARIMA is simulated to demonstrate the effect of differencing
- Residual diagnostics assess model adequacy (ACF)

---

## How to Use

1. Run `simulate_ar.R` to generate AR(1) and AR(2) sample paths
2. Run `simulate_arima.R` to simulate ARIMA cases

---

## Key Learnings

- Stationarity is crucial for valid inference
- ACF and PACF are diagnostic tools for AR order selection
- Integration transforms nonstationary series to stationary ARMA processes
- Residual analysis ensures model adequacy

---

## Tools & Methods

- **Programming:** R (base, stats)
- **Models:** AR(p), ARIMA(p,d,q), ARMA(p,q)
- **Techniques:** Simulation, order identification, residual diagnostics
- **Analysis:** ACF/PACF, model selection (AIC)
