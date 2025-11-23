library(plumber)
source("API.R")

# -----------------------
# Health Check Endpoint
# -----------------------
#* @get /health
function() {
  list(status = "API is running")
}

# -----------------------
# Prediction Endpoint
# -----------------------
#* @param throughput numeric
#* @param delay numeric
#* @param jitter numeric
#* @param loss numeric
#* @get /predict
function(throughput, delay, jitter, loss) {
  throughput <- as.numeric(throughput)
  delay <- as.numeric(delay)
  jitter <- as.numeric(jitter)
  loss <- as.numeric(loss)
  
  predict_qoe(throughput, delay, jitter, loss)
}
