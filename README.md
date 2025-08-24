# TidalCycles Starter Kit for Debian 12

Live coding music with TidalCycles, SuperCollider, and SuperDirt.

## Installation

### 1. System Packages
```bash
sudo apt install supercollider sc3-plugins libghc-tidal-dev qjackctl
```

### 2. SuperCollider Extensions (Quarks)
```bash
sclang install_quarks.scd
```
This installs SuperDirt, Vowel, and Dirt-Samples.

### 3. Configure Emacs
Create `/usr/share/tidal/BootTidal.hs`:
```bash
sudo mkdir -p /usr/share/tidal
sudo cp BootTidal.hs /usr/share/tidal/
```

## Usage

### 1. Configure Audio (QjackCtl)
- Open QjackCtl
- Setup → Settings:
  - Sample Rate: **48000**
  - Frames/Period: 512
  - Interface: hw:0 or default
- Click Start

### 2. Start SuperDirt
```bash
sclang startup.scd
```

### 3. Start TidalCycles

Open a `.tidal` file in Emacs:
```bash
emacs filename.tidal
```

**Key Commands:**
- `C-c C-s` - Start Tidal (do this first!)
- `C-c C-c` - Evaluate single line
- `C-Return` - Evaluate block/paragraph
- `C-c C-e` - Evaluate multiple lines (region)
- Type `hush` and evaluate - Stop all sound

## Files

- `BootTidal.hs` - TidalCycles configuration
- `startup.scd` - SuperDirt startup (with increased buffers)
- `install_quarks.scd` - Quark installer
- `tidalcycles.md` - Quick reference guide

## Troubleshooting

- **No sound**: Check QjackCtl connections (SuperCollider → system playback)
- **Wrong sample rate**: Set QjackCtl to 48000 Hz
- **Buffer overflow**: Already fixed in startup.scd (64K buffers)
- **Port 57120 in use**: Kill existing sclang/ghci processes
