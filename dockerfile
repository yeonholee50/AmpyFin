FROM alpine:latest
WORKDIR /app
COPY . .

# Install system packages
RUN apk update && apk add --no-cache python3-dev py3-pip wget gcc make g++ zlib-dev

# Build and install ta-lib dependency:
RUN wget https://github.com/ta-lib/ta-lib/releases/download/v0.6.4/ta-lib-0.6.4-src.tar.gz
RUN tar -xzf ta-lib-0.6.4-src.tar.gz
WORKDIR /app/ta-lib-0.6.4
RUN ./configure --prefix=/usr
RUN make
RUN make install
WORKDIR /app

# Install AmpyFin dependencies
RUN pip install --break-system-packages --no-cache-dir -r requirements.txt 

# Cleanup
RUN apk del python3-dev && apk add --no-cache python3
RUN rm ta-lib-0.6.4-src.tar.gz && rm -rf ta-lib-0.6.4 && rm -rf /var/cache/apk/* && rm -rf /.cache/pip

# Initial command
ENTRYPOINT ["python3"]
CMD ["setup.py"]