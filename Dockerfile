FROM rocker/r-ver:4.3.1

# Set CRAN mirror
RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' >> /usr/local/lib/R/etc/Rprofile.site

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libz-dev \
    libsodium-dev \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c('plumber','randomForest','jsonlite'))"

# Copy API code and model
WORKDIR /app
COPY . /app

# Expose port
EXPOSE 8000

# Run the API
CMD ["R", "-e", "port <- as.integer(Sys.getenv('PORT', '8000')); pr <- plumber::plumb('api.R'); pr$run(host='0.0.0.0', port=port)"]
