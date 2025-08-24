FROM rocker/r-ver:4.3.1

# Speed up: avoid suggests
RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' >> /usr/local/lib/R/etc/Rprofile.site

# Install needed system libs (curl, ssl, xml are common)
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev libssl-dev libxml2-dev && \
    rm -rf /var/lib/apt/lists/*

# Install required R packages
RUN R -e "install.packages(c('plumber','randomForest','jsonlite'))"

# Copy API code and model
WORKDIR /app
COPY . /app

# Expose port that the API will listen on
EXPOSE 8000

# Start the API (Render will respect PORT if set)
CMD ["R", "-e", "port <- as.integer(Sys.getenv('PORT', '8000')); pr <- plumber::plumb('api.R'); pr$run(host='0.0.0.0', port=port)"]
