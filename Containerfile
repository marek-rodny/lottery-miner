# Lottery Mining Container
# Standalone container for running solo/lottery mining without installing dependencies
# Build with: podman build -t lottery-miner .
# Run with: podman run -it --name lottery-miner lottery-miner

FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Labels
LABEL maintainer="Lottery Miner Project"
LABEL description="Solo/Lottery cryptocurrency mining container"
LABEL version="1.0.0"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    git \
    build-essential \
    libcurl4-openssl-dev \
    libjansson-dev \
    automake \
    libtool \
    pkg-config \
    python3 \
    python3-pip \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip3 install --no-cache-dir psutil

# Create application directory
WORKDIR /app

# Copy application files
COPY src/solo_lottery_final.py /app/
COPY scripts/install_solo_miners.sh /app/

# Make scripts executable
RUN chmod +x /app/solo_lottery_final.py /app/install_solo_miners.sh

# Install mining software (CPUMiner for Bitcoin)
# Note: CCMiner requires NVIDIA GPU and CUDA, which isn't available in standard containers
# For GPU mining, use --device nvidia.com/gpu=all with Podman and nvidia-container-toolkit
RUN cd /tmp && \
    git clone https://github.com/pooler/cpuminer.git && \
    cd cpuminer && \
    ./autogen.sh && \
    ./configure CFLAGS="-O3 -march=native" && \
    make -j$(nproc) && \
    cp minerd /app/cpuminer && \
    cd /app && \
    rm -rf /tmp/cpuminer && \
    chmod +x /app/cpuminer

# Create data directory for logs and stats
RUN mkdir -p /root/solo-lottery-mining/logs

# Set Python to unbuffered mode for better logging
ENV PYTHONUNBUFFERED=1

# Create entry point script
RUN echo '#!/bin/bash\n\
echo "==============================================="\n\
echo "  Solo/Lottery Mining Container"\n\
echo "==============================================="\n\
echo ""\n\
echo "Available commands:"\n\
echo "  info   - Show coin information"\n\
echo "  start  - Start mining"\n\
echo "  stop   - Stop mining"\n\
echo "  status - Show status"\n\
echo "  bash   - Open shell"\n\
echo ""\n\
echo "IMPORTANT: Before mining, you must:"\n\
echo "  1. Edit /app/solo_lottery_final.py"\n\
echo "  2. Set your wallet addresses in Config.WALLETS"\n\
echo "  3. Choose your coin in Config.ACTIVE_COIN"\n\
echo ""\n\
echo "Quick start (for testing):"\n\
echo "  python3 /app/solo_lottery_final.py info"\n\
echo ""\n\
if [ "$#" -eq 0 ]; then\n\
    exec /bin/bash\n\
elif [ "$1" = "bash" ]; then\n\
    exec /bin/bash\n\
else\n\
    exec python3 /app/solo_lottery_final.py "$@"\n\
fi' > /app/entrypoint.sh && chmod +x /app/entrypoint.sh

# Expose any ports (none needed for mining, but good practice)
# EXPOSE 3333

# Set the entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]

# Default command shows info
CMD ["info"]
