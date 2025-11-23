library(plumber)

# -----------------------
# Load Model
# -----------------------
best_model <- readRDS("best_model.rds")

# -----------------------
# Input validation helper
# -----------------------
validate_input <- function(value, name, min_val, max_val) {
  if (is.null(value)) stop(paste("Missing:", name))
  if (!is.numeric(value)) stop(paste(name, "must be numeric"))
  if (value < min_val || value > max_val) {
    stop(paste(name, "must be between", min_val, "and", max_val))
  }
  return(value)
}

# -----------------------
# Prediction Function
# -----------------------
predict_qoe <- function(throughput, delay, jitter, loss) {
  t <- validate_input(throughput, "throughput", 0, 1000)
  d <- validate_input(delay, "delay", 0, 5000)
  j <- validate_input(jitter, "jitter", 0, 1000)
  l <- validate_input(loss, "loss", 0, 100)
  
  newdata <- data.frame(
    Throughput_Mbps = t,
    Delay_ms = d,
    Jitter_ms = j,
    Packet_Loss_Pct = l
  )
  
  pred <- predict(best_model, newdata = newdata)
  
  list(
    input = as.list(newdata),
    prediction = as.character(pred)
  )
}
