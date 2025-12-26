# Lottery Miner

**Solo/Lottery Cryptocurrency Mining - Educational & Experimental Project**

A comprehensive, production-ready solo/lottery mining solution with realistic expectations and full documentation. Mine Bitcoin or Vertcoin with complete transparency about odds, costs, and outcomes.

## What is Lottery Mining?

**Lottery/Solo Mining** means you mine for the full block reward with no proportional payouts:

- ✅ **Find a block** → Get FULL reward (jackpot!)
- ❌ **Don't find block** → Get nothing

This is **NOT regular mining** where you get steady small payouts. It's a lottery ticket with calculable odds.

## Features

- ✅ **Production-ready Python code** - Fully tested and debugged
- ✅ **Multi-coin support** - Bitcoin (CPU) and Vertcoin (GPU)
- ✅ **Auto-restart** - Handles crashes and connection issues
- ✅ **Detailed statistics** - Track runtime, costs, shares, and blocks
- ✅ **Realistic expectations** - Clear documentation of actual odds
- ✅ **Podman container** - Run without installing dependencies
- ✅ **Complete guide** - 10,000+ word comprehensive documentation

## Quick Start

### Option 1: Using Podman Container (Recommended)

```bash
# Build the container
podman build -t lottery-miner .

# Run with interactive shell
podman run -it lottery-miner bash

# Edit configuration (set your wallet address)
nano /app/solo_lottery_final.py

# Show coin information
python3 /app/solo_lottery_final.py info

# Start mining
python3 /app/solo_lottery_final.py start
```

### Option 2: Native Installation

```bash
# Clone the repository
git clone https://github.com/marek-rodny/lottery-miner.git
cd lottery-miner

# Run installation script
chmod +x scripts/install_solo_miners.sh
./scripts/install_solo_miners.sh

# Copy the script to your mining directory
cp src/solo_lottery_final.py ~/solo-lottery-mining/
cd ~/solo-lottery-mining

# Edit configuration (REQUIRED!)
nano solo_lottery_final.py
# Set your wallet addresses in Config.WALLETS
# Choose coin in Config.ACTIVE_COIN

# Make executable
chmod +x solo_lottery_final.py

# Show information
./solo_lottery_final.py info

# Start mining
./solo_lottery_final.py start
```

## Configuration

Before mining, you **MUST** edit the configuration in `solo_lottery_final.py`:

```python
# Choose your coin
ACTIVE_COIN = "bitcoin"  # Options: "bitcoin", "vertcoin"

# Set your wallet addresses
WALLETS = {
    "vertcoin": "Vtc1YourAddressHere",  # Replace!
    "bitcoin": "bc1YourAddressHere"      # Replace!
}
```

## Available Commands

```bash
./solo_lottery_final.py info      # Show coin information and terminology
./solo_lottery_final.py start     # Start mining
./solo_lottery_final.py stop      # Stop mining
./solo_lottery_final.py status    # Show detailed status and statistics
```

## Supported Coins

### Bitcoin (BTC)

- **Type**: CPU mining via CKPool solo service
- **Block Reward**: 3.125 BTC (~€136,500) after 2% fee
- **Purpose**: Connectivity testing and learning
- **Block Finding**: Essentially impossible with CPU
- **Expected Time**: ~415,000 years
- **Monthly Cost**: ~€22 electricity
- **Use For**: Testing setup, learning mining, entertainment

### Vertcoin (VTC)

- **Type**: GPU mining (requires verified solo pool or own node)
- **Block Reward**: 6.25 VTC (~€2.50) after halving
- **Purpose**: Actual block finding proof of concept
- **Block Finding**: 5-10 hours average (with proper setup)
- **Expected Time**: Hours to days
- **Monthly Cost**: ~€22 electricity
- **Use For**: Realistic lottery mining, learning

**⚠️ CRITICAL**: Vertcoin requires verified solo setup. See documentation for details.

## Understanding Shares vs Blocks

### What Are Shares?

When you see **"accepted shares"** in logs:

- ✅ Shares = Connectivity check (proves miner works)
- ✅ Shares = Work verification (shows valid work)
- ❌ Shares ≠ Payment (you don't get paid for shares!)
- ❌ Shares ≠ Progress (1000 shares doesn't mean you're "close")

### Payment Model

**Payment happens ONLY when you find a complete block.**

- You will see many accepted shares (normal!)
- Block finding shows "BLOCK FOUND" / "SOLVED" in logs
- Then full block reward arrives in your wallet

This is **TRUE LOTTERY**: Jackpot or nothing, no proportional payouts.

## Economics & Reality Check

### Bitcoin Solo Mining

| Metric | Value |
|--------|-------|
| Block Reward | €133,650 (after 2% fee) |
| Expected Value/Day | €0.00032 |
| Electricity Cost/Day | €0.72 |
| **Net Daily** | **-€0.72 LOSS** |
| Expected Time/Block | ~415,000 years |

**Conclusion**: NOT profitable. Use for testing only.

### Vertcoin Solo Mining (if verified)

| Metric | Value |
|--------|-------|
| Block Reward | ~€2.50 |
| Expected Value/Day | €7.63 |
| Electricity Cost/Day | €0.72 |
| **Net Daily** | **+€6.91** |
| Expected Time/Block | 5-10 hours |

**Conclusion**: Potentially viable if setup verified, but price volatile.

### Monthly Electricity Cost

- Power Draw: 150W continuous
- Rate: €0.20/kWh
- **Monthly Cost: €21.60**

This is your "lottery ticket" cost.

## System Requirements

### Minimum Requirements

- **OS**: Linux (Ubuntu 22.04+ or Debian 11+)
- **CPU**: Intel/AMD multi-core (for Bitcoin CPU mining)
- **RAM**: 8GB minimum
- **Storage**: 50GB free space
- **Internet**: Any broadband connection

### For GPU Mining (Vertcoin)

- **GPU**: NVIDIA GPU with CUDA support
- **VRAM**: 4GB minimum
- **Drivers**: Latest NVIDIA drivers
- **CUDA**: CUDA toolkit (for compilation)

### Tested Hardware

- HP Z240 Workstation
- Intel Xeon / Core i5/i7
- NVIDIA Quadro M2000 (768 CUDA cores, 4GB VRAM)
- Expected Performance: ~8 MH/s (Vertcoin), ~10 MH/s (Bitcoin)

## Container Usage

### Building

```bash
podman build -t lottery-miner .
```

### Running

```bash
# Interactive mode
podman run -it --name lottery-miner lottery-miner

# Run with GPU support (requires nvidia-container-toolkit)
podman run -it --device nvidia.com/gpu=all --name lottery-miner lottery-miner

# Run specific command
podman run -it lottery-miner info
podman run -it lottery-miner status

# Access shell in running container
podman exec -it lottery-miner bash
```

### Persistent Data

```bash
# Mount directory for logs and stats
podman run -it \
  -v ~/mining-data:/root/solo-lottery-mining:Z \
  --name lottery-miner \
  lottery-miner
```

## Why Do This?

### Good Reasons

- ✅ Learning about blockchain and mining
- ✅ Understanding probability and expected value
- ✅ Testing mining hardware/software
- ✅ Supporting network decentralization
- ✅ Entertainment (~€20/month lottery ticket)
- ✅ The thrill of "maybe today!"

### Bad Reasons

- ❌ Making money (negative expected value for Bitcoin)
- ❌ Replacing a job
- ❌ Investment strategy
- ❌ Get-rich-quick scheme

## Documentation

Complete documentation available in `docs/COMPLETE_GUIDE.md`:

- Complete terminology explanations
- Detailed hardware requirements
- Economic analysis
- Wallet setup guides
- Step-by-step usage instructions
- Troubleshooting guide
- Comprehensive FAQ

## Project Structure

```
lottery-miner/
├── README.md                          # This file
├── Containerfile                      # Podman/Docker container definition
├── .dockerignore                      # Files to exclude from container
├── .gitignore                         # Git ignore rules
├── src/
│   └── solo_lottery_final.py         # Main mining script
├── scripts/
│   └── install_solo_miners.sh        # Installation script
└── docs/
    └── COMPLETE_GUIDE.md              # Full 10,000+ word guide
```

## Safety & Security

### Mining Safety

- ✅ Monitor temperatures (keep GPU under 85°C)
- ✅ Use reasonable power limits
- ✅ Good cooling/airflow
- ❌ Don't run on laptops (overheating risk)
- ❌ Don't overclock for lottery mining

### Wallet Security

- 🔒 **NEVER** share seed phrases or private keys
- 💾 **ALWAYS** backup wallet seed phrase on paper
- 📝 **WRITE DOWN** seed phrase in safe location
- ✅ **TEST** wallet restore process
- ⚠️ **START** with small amounts

### Software Security

- ✅ Only download miners from official sources
- ✅ Verify checksums/signatures
- ✅ Use reputable pools
- ❌ Never download fake/modified miners
- ❌ Don't trust random mining pools

## Monitoring

### Live Status

```bash
# Monitor while running
./solo_lottery_final.py start
# Shows: [14:35:42] RUN | Uptime: 2.3h | CPU: 45% | RAM: 23% | Shares: 127 | BLOCKS: 0
```

### Detailed Statistics

```bash
./solo_lottery_final.py status
```

Shows:
- Current session info
- Historical statistics
- Economics analysis
- Expected time to block
- Proof of concept checklist

### Log Files

```bash
# Watch logs in real-time
tail -f ~/solo-lottery-mining/logs/solo_bitcoin.log

# Search for blocks
grep -i "block found" ~/solo-lottery-mining/logs/*.log
```

## Troubleshooting

### Common Issues

**"Miner not found"**
```bash
# Run installation script
./scripts/install_solo_miners.sh
```

**"Wallet not configured"**
```bash
# Edit the script and set your wallet
nano solo_lottery_final.py
# Update Config.WALLETS
```

**Miner keeps crashing**
- Check GPU temperature
- Lower power limit: `nvidia-smi -pl 50`
- Lower intensity in script
- Check logs for errors

**No accepted shares**
- Check wallet address format
- Verify internet connection
- Check firewall settings
- Review log files for errors

See `docs/COMPLETE_GUIDE.md` for comprehensive troubleshooting.

## Contributing

This is an educational project. Contributions welcome:

- Bug fixes
- Documentation improvements
- Additional coin support
- Performance optimizations

Please open issues or pull requests on GitHub.

## License

MIT License - See LICENSE file for details.

## Disclaimer

**IMPORTANT**: This is an educational and experimental project.

- ⚠️ Solo/lottery mining is NOT profitable for most coins
- ⚠️ Treat this as entertainment, not investment
- ⚠️ You will likely never find a Bitcoin block
- ⚠️ Electricity costs are real and ongoing
- ⚠️ Cryptocurrency prices are volatile
- ⚠️ No guarantees or warranties provided

**Expected outcome**: Learning experience + lottery ticket (~€20/month).

Mining cryptocurrency involves:
- Electricity costs
- Hardware wear
- Opportunity cost
- Price volatility risk

**Do not** mine if you cannot afford the electricity cost or if you expect to make money.

## Support & Resources

### Documentation
- Complete Guide: `docs/COMPLETE_GUIDE.md`
- Installation: `scripts/install_solo_miners.sh`
- Code: `src/solo_lottery_final.py`

### External Resources
- Bitcoin Solo Mining: [CKPool](https://solo.ckpool.org/)
- Bitcoin Wallet: [Electrum](https://electrum.org/)
- Vertcoin: [Official Site](https://vertcoin.org/)
- Mining Calculator: Various online calculators

### Community
- GitHub Issues: Report bugs and ask questions
- Bitcoin Forums: BitcoinTalk, Reddit r/Bitcoin
- Vertcoin Forums: Reddit r/Vertcoin

## Credits

- **CPUMiner**: [pooler/cpuminer](https://github.com/pooler/cpuminer)
- **CCMiner**: [tpruvot/ccminer](https://github.com/tpruvot/ccminer)
- **CKPool**: [solo.ckpool.org](https://solo.ckpool.org/)

## Version

**Version**: 1.0.0 FINAL
**Last Updated**: December 2025
**Status**: Production Ready

---

**Remember**: This is a lottery ticket, not an ATM. Mine for fun, learning, and the dream of finding a block. Treat it as educational entertainment with a ~€20/month cost.

Happy mining! 🎰⛏️
