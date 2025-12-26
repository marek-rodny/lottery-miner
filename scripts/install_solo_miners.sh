#!/bin/bash
#
# Solo/Lottery Mining - Installation Script
# Installs all required mining software and dependencies
#
# Usage: ./install_solo_miners.sh
#

set -e  # Exit on error

# ============================================================================
# CONFIGURATION
# ============================================================================

WORK_DIR="$HOME/solo-lottery-mining"
CCMINER_URL="https://github.com/tpruvot/ccminer/releases/download/2.3.1-tpruvot/ccminer-2.3.1-cuda11-linux-x64.tar.gz"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

print_header() {
    echo ""
    echo "============================================"
    echo "  $1"
    echo "============================================"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# ============================================================================
# MAIN INSTALLATION
# ============================================================================

print_header "Solo/Lottery Mining - Installation"

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please don't run this script as root"
    echo "Run as regular user: ./install_solo_miners.sh"
    exit 1
fi

# Create working directory
echo "Creating working directory..."
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"
print_success "Working directory: $WORK_DIR"

# ============================================================================
# INSTALL SYSTEM DEPENDENCIES
# ============================================================================

print_header "Installing System Dependencies"

echo "Updating package list..."
sudo apt update

echo "Installing build tools and libraries..."
sudo apt install -y \
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
    curl

print_success "System dependencies installed"

# ============================================================================
# INSTALL PYTHON DEPENDENCIES
# ============================================================================

print_header "Installing Python Dependencies"

pip3 install --user psutil

print_success "Python dependencies installed"

# ============================================================================
# INSTALL CCMINER (for Vertcoin)
# ============================================================================

print_header "Installing CCMiner (Vertcoin)"

if [ -f "ccminer" ]; then
    print_warning "CCMiner already exists, skipping..."
else
    echo "Downloading CCMiner..."

    # Try to download pre-built binary
    if wget -q "$CCMINER_URL"; then
        echo "Extracting..."
        tar -xf ccminer-2.3.1-cuda11-linux-x64.tar.gz

        if [ -f "ccminer-x64" ]; then
            mv ccminer-x64 ccminer
        elif [ -f "ccminer" ]; then
            # Already named correctly
            :
        else
            print_error "Could not find ccminer executable in archive"
            print_warning "You may need to compile from source"
        fi

        rm -f ccminer-2.3.1-cuda11-linux-x64.tar.gz
        chmod +x ccminer 2>/dev/null || true

        if [ -f "ccminer" ]; then
            print_success "CCMiner installed"
        else
            print_warning "CCMiner installation incomplete"
            echo "You may need to:"
            echo "  1. Install NVIDIA CUDA toolkit"
            echo "  2. Compile from source: https://github.com/tpruvot/ccminer"
        fi
    else
        print_error "Could not download CCMiner"
        print_warning "You'll need to install it manually"
        echo "Options:"
        echo "  1. Download from: https://github.com/tpruvot/ccminer/releases"
        echo "  2. Or compile from source if you have CUDA toolkit"
    fi
fi

# ============================================================================
# INSTALL CPUMINER (for Bitcoin)
# ============================================================================

print_header "Installing CPUMiner (Bitcoin)"

if [ -f "cpuminer" ]; then
    print_warning "CPUMiner already exists, skipping..."
else
    echo "Downloading and compiling CPUMiner..."
    echo "This may take a few minutes..."

    # Clone repository
    if [ -d "cpuminer-src" ]; then
        rm -rf cpuminer-src
    fi

    git clone https://github.com/pooler/cpuminer.git cpuminer-src
    cd cpuminer-src

    # Build
    ./autogen.sh
    ./configure CFLAGS="-O3 -march=native"
    make -j$(nproc)

    # Copy binary
    cp minerd ../cpuminer
    cd ..

    # Cleanup
    rm -rf cpuminer-src

    chmod +x cpuminer
    print_success "CPUMiner installed"
fi

# ============================================================================
# VERIFY INSTALLATIONS
# ============================================================================

print_header "Verifying Installations"

all_good=true

# Check CCMiner
if [ -f "ccminer" ] && [ -x "ccminer" ]; then
    print_success "CCMiner: OK"
else
    print_warning "CCMiner: NOT FOUND or not executable"
    all_good=false
fi

# Check CPUMiner
if [ -f "cpuminer" ] && [ -x "cpuminer" ]; then
    print_success "CPUMiner: OK"
else
    print_error "CPUMiner: NOT FOUND or not executable"
    all_good=false
fi

# Check Python
if command -v python3 &> /dev/null; then
    python_version=$(python3 --version)
    print_success "Python3: $python_version"
else
    print_error "Python3: NOT FOUND"
    all_good=false
fi

# Check psutil
if python3 -c "import psutil" 2>/dev/null; then
    print_success "Python psutil: OK"
else
    print_error "Python psutil: NOT FOUND"
    all_good=false
fi

# ============================================================================
# FINAL SUMMARY
# ============================================================================

print_header "Installation Complete"

if $all_good; then
    print_success "All components installed successfully!"
else
    print_warning "Some components have issues"
    echo "Check the messages above for details"
fi

echo ""
echo "Installed miners:"
echo "  • CCMiner (Vertcoin):  ./ccminer"
echo "  • CPUMiner (Bitcoin):  ./cpuminer"
echo ""
echo "Next steps:"
echo ""
echo "1. Create cryptocurrency wallets"
echo "   • Bitcoin: Use Electrum (electrum.org)"
echo "   • Vertcoin: Use Vertcoin Core (vertcoin.org)"
echo ""
echo "2. Copy the Python script to this directory"
echo "   • Save 'solo_lottery_final.py' here"
echo "   • Make it executable: chmod +x solo_lottery_final.py"
echo ""
echo "3. Edit configuration"
echo "   • nano solo_lottery_final.py"
echo "   • Set your wallet addresses in Config.WALLETS"
echo "   • Choose active coin in Config.ACTIVE_COIN"
echo ""
echo "4. Run"
echo "   • ./solo_lottery_final.py info    (show coin info)"
echo "   • ./solo_lottery_final.py start   (start mining)"
echo "   • ./solo_lottery_final.py status  (check status)"
echo "   • ./solo_lottery_final.py stop    (stop mining)"
echo ""
echo "⚠️  IMPORTANT REMINDERS:"
echo "   • This is LOTTERY mining (jackpot or nothing)"
echo "   • Bitcoin: Use for connectivity testing only"
echo "   • Vertcoin: Need verified solo setup"
echo "   • Expected cost: ~€0.72/day electricity"
echo "   • Treat as entertainment, not investment"
echo ""
