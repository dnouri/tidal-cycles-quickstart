# TidalCycles Quick Reference

## Overview

TidalCycles (Tidal) is a domain-specific language embedded in Haskell for algorithmic pattern generation and live coding of music. It operates on a cyclical time model where patterns repeat in cycles measured in Cycles Per Second (CPS) rather than traditional linear time.

**Core Concepts:**
- **Cycles**: Time unit where one cycle = one second by default (CPS = 0.5625)
- **Patterns**: Functions from time to events, lazily evaluated
- **Mini-notation**: String-based DSL parsed into pattern structures
- **Functional composition**: Heavy use of Haskell's `.` and `$` operators

## Language Structure

### Basic Pattern Syntax

```haskell
-- Pattern application with $ operator
d1 $ sound "bd sd"

-- Function composition with .
d1 $ rev . fast 2 $ sound "bd sd"

-- Pattern combination with #
d1 $ sound "bd sd" # gain "0.8 0.5"
```

### Pattern Combination Operators

| Operator | Description | Example |
|----------|------------|---------|
| `$` | Function application | `d1 $ sound "bd"` |
| `#` | Combines patterns (shorthand for `|>`) | `sound "bd" # gain 0.8` |
| `|>` | Structure from left pattern | `sound "bd sd" |> gain "0.8 0.5"` |
| `<|` | Structure from right pattern | `sound "bd sd" <| gain "0.8 0.5 0.9"` |
| `|+|` | Structure from both patterns | `sound "bd sd" |+| gain "0.8 0.5"` |
| `|+`, `|-`, `|*`, `|/` | Mathematical pattern combinations | `n "0 2" |+ 7` |

## Mini-Notation Reference

Mini-notation is TidalCycles' embedded DSL within quoted strings for creating rhythmic patterns.

### Structural Elements

| Symbol | Function | Example | Result |
|--------|----------|---------|--------|
| `[ ]` | Subdivision | `"bd [sd cp]"` | bd takes 1/2, sd and cp share 1/2 |
| `{ }` | Polymetric | `"{bd cp, hh hh hh}"` | Different cycle lengths |
| `( )` | Euclidean | `"bd(3,8)"` | 3 beats distributed over 8 steps |
| `< >` | Alternation | `"bd <sd cp hh>"` | Cycles through options |
| `\|` | Random choice | `"[bd\|cp\|hh]"` | Random selection each time |
| `,` | Layering | `"[bd, hh*4]"` | Simultaneous patterns |

### Timing Modifiers

| Symbol | Function | Example | Result |
|--------|----------|---------|--------|
| `*` | Repetition | `"bd*4"` | Repeat 4 times in space |
| `/` | Slowdown | `"bd/2"` | Play every 2 cycles |
| `_` or `@` | Elongation | `"bd _ _ hh"` | Extend duration |
| `!` | Replication | `"bd!3 sd"` | Duplicate pattern |
| `?` | Probability | `"bd?"` | 50% chance of playing |
| `?0.7` | Custom probability | `"bd?0.7"` | 70% chance |

### Special Elements

| Symbol | Function | Example |
|--------|----------|---------|
| `~` | Rest/silence | `"bd ~ sd ~"` |
| `:` | Sample index | `"bd:3"` |
| `%` | Modulo | `"6%4"` |
| `.` | Decimal | `"0.5 0.75"` |

## Core Functions

### Pattern Generation

```haskell
-- Continuous patterns (0-1 range)
sine    -- Sine wave
saw     -- Sawtooth wave
tri     -- Triangle wave
square  -- Square wave
rand    -- Random values
irand n -- Random integers 0 to n-1

-- List patterns
run n        -- "0 1 2 ... n-1"
scan n       -- Accumulative "0 0 1 0 1 2..."
listToPat [1,2,3]  -- Convert list to pattern
```

### Time Transformations

```haskell
-- Speed control
fast n      -- Speed up by factor n
slow n      -- Slow down by factor n
hurry n     -- Speed up pattern and samples

-- Time manipulation
compress (start, end)  -- Squeeze into time range
zoom (start, end)      -- Play portion of pattern
within (start, end) f  -- Apply function to time range

-- Offset and swing
off time f             -- Layer with offset
swingBy amount subdiv  -- Add swing feel
```

### Pattern Transformations

```haskell
-- Structural
rev         -- Reverse pattern
palindrome  -- Forward then backward
iter n      -- Rotate pattern each cycle
rot n       -- Rotate by n events
ply n       -- Repeat each event n times

-- Degradation
degrade         -- Remove 50% randomly
degradeBy n     -- Remove n% randomly
shuffle n       -- Randomly permute n parts
scramble n      -- Randomly select from n parts

-- Layering
stack [p1, p2]    -- Play simultaneously
cat [p1, p2]      -- Play sequentially
fastcat [p1, p2]  -- Squeeze into one cycle
append p1 p2      -- Alternate each cycle
```

### Conditional Application

```haskell
-- Cycle-based
every n f         -- Apply f every n cycles
every' n offset f -- With offset
whenmod x y f     -- When cycle mod x >= y

-- Probabilistic
sometimes f    -- 50% chance
often f        -- 75% chance
rarely f       -- 25% chance
almostNever f  -- 10% chance
almostAlways f -- 90% chance

-- Pattern-based
when test f       -- Apply when test passes
fix f pattern     -- Apply to matching events
```

### Euclidean Rhythms

```haskell
-- Function syntax
euclid beats steps pattern
euclidInv beats steps pattern
euclidFull beats steps p1 p2

-- Mini-notation
"bd(3,8)"        -- 3 beats in 8 steps
"bd(5,8,2)"      -- With rotation offset
```

**Common Euclidean Patterns:**
- `(2,5)` - Khafif-e-ramal
- `(3,8)` - Cuban tresillo
- `(5,8)` - Cuban cinquillo
- `(7,12)` - West African bell

## Sound and Synthesis

### Sample Playback

```haskell
-- Basic playback
s "bd"           -- Play sample
sound "bd"       -- Synonym for s
n "0 1 2"        -- Sample index
"bd:3"           -- Index notation

-- Sample manipulation
begin 0.25       -- Start position (0-1)
end 0.75         -- End position (0-1)
speed 1.5        -- Playback speed
legato 0.5       -- Note duration
```

### SuperDirt Synths

**Categories:**
- **Additive**: supergong
- **Subtractive**: supersquare, supersaw, superpwm
- **Physical**: superpiano, supermandolin, superfork
- **FM**: superfm (6-operator)
- **Drums**: superkick, super808, superhat

**Common Parameters:**
```haskell
freq 440         -- Frequency in Hz
note "c4 e4 g4"  -- Musical notation
octave 4         -- Octave selection
sustain 0.5      -- Note duration
pan 0.5          -- Stereo position (0-1)
gain 0.8         -- Volume (exponential)
amp 1.0          -- Volume (linear)
```

## Effects

### Filters

```haskell
-- Low-pass
lpf 1000         -- Cutoff frequency
lpq 0.1          -- Resonance

-- High-pass
hpf 500          -- Cutoff frequency
hresonance 0.2   -- Resonance

-- Band-pass
bandf 1000       -- Center frequency
bandq 0.5        -- Q factor

-- Special
djf 0.5          -- DJ filter
vowel "a"        -- Formant filter
```

### Time-Based Effects

```haskell
-- Delay
delay 0.5        -- Wet/dry mix
delaytime 0.125  -- Delay time
delayfeedback 0.7 -- Feedback

-- Reverb
room 0.5         -- Room size
size 0.8         -- Decay time
dry 0.5          -- Dry signal level
```

### Distortion

```haskell
shape 0.5        -- Waveshaping
crush 8          -- Bit reduction
distort 0.3      -- General distortion
squiz 4          -- Granular distortion
triode 0.5       -- Tube simulation
```

### Modulation

```haskell
tremolo          -- Amplitude modulation
phaser           -- Phase shifting
leslie           -- Rotating speaker
ringmod          -- Ring modulation
```

## MIDI Integration

```haskell
-- Control Change
ccn 30 # ccv 64  -- CC number and value

-- Standard controls
modwheel 0.5     -- CC 1
expression 0.8   -- Expression pedal
sustainpedal 1   -- CC 64

-- Program change
progNum 5        -- Program change

-- Pitch
midibend 0.5     -- Pitch bend
```

## Pattern Recipes

### Basic Rhythms

```haskell
-- Four-on-floor
d1 $ s "bd*4"

-- Breakbeat
d1 $ s "bd ~ ~ bd ~ ~ bd ~"
d2 $ s "~ ~ sd ~ ~ ~ sd ~"

-- Swing
d1 $ swingBy (1/3) 4 $ s "hh*8"
```

### Polyrhythmic Patterns

```haskell
-- 3 against 4
d1 $ stack [
  s "bd*3",
  s "cp*4"
]

-- Complex polymetric
d1 $ s "{bd*3, sd*5, hh*7}"
```

### Melodic Patterns

```haskell
-- Scale-based melody
d1 $ n (scale "minor" $ run 8) # s "superpiano"

-- Arpeggiation
d1 $ arp "up" $ n "c'maj7'4" # s "superpiano"

-- Chord progressions
d1 $ n "<c'maj e'min f'maj g'maj>" # s "superpiano"
```

### Genre Templates

```haskell
-- Techno (130 BPM)
setcps (130/60/4)
d1 $ s "bd*4" # gain 1.2
d2 $ s "~ hh ~ hh" # speed (range 0.8 1.2 $ slow 8 sine)

-- House (125 BPM)
setcps (125/60/4)
d1 $ s "bd ~ ~ ~" # gain 1.1
d2 $ swingBy 0.08 4 $ s "hh*4" # gain 0.7

-- Ambient
d1 $ slow 8 $ n "c2 eb2 g2 bb2" 
  # s "pad" 
  # attack 2 # release 4
  # lpf (range 200 800 $ slow 16 sine)
```

## Advanced Techniques

### Transitions

```haskell
xfadeIn 1 8      -- Crossfade over 8 cycles
anticipateIn 1 4 -- Queue with anticipation
jumpIn 1 4       -- Jump after 4 cycles
clutchIn 1 8     -- Degrade and introduce
interpolateIn 1 4 -- Morph parameters
```

### Pattern Variables

```haskell
let bassline = n "c2 eb2 g2 c3" # s "bass"
    drums = s "bd(3,8) sd(5,8)"
in d1 $ stack [bassline, drums]
```

### Generative Techniques

```haskell
-- Random selection
d1 $ s (choose ["bd", "sd", "cp"]) # gain rand

-- Weighted random
d1 $ s (wchoose [("bd",0.7), ("sd",0.3)])

-- Markov chains (via lindenmayer)
d1 $ lindenmayer 5 "0:1 1:0" $ s "bd sd"
```

### Performance Control

```haskell
-- Pattern groups
d1 $ s "bd*4" # orbit 0
d2 $ s "hh*8" # orbit 1

-- Solo/mute
solo 1           -- Solo orbit 1
unsolo 1         -- Unsolo
mute 2           -- Mute orbit 2
unmute 2         -- Unmute

-- Global control
hush             -- Stop all patterns
panic            -- Emergency stop
```

## Strudel (Web Implementation)

Strudel is a JavaScript port of TidalCycles that runs in browsers:

```javascript
// JavaScript syntax
note("c3 eb3 g3 c4")
  .s('sawtooth')
  .cutoff(800)
  .room(0.3)

// Supports full mini-notation
s("bd(3,8), hh*8")
  .speed("1 1.5")
```

Key differences:
- JavaScript syntax instead of Haskell
- Method chaining instead of `#` operator
- No installation required
- Works offline after initial load

## Integration Points

### DAW Integration
- **Ableton Live**: Via Max4Live devices
- **Bitwig/Reaper**: Via MIDI/OSC
- **Logic/Pro Tools**: External instrument routing

### Network Collaboration
- **Estuary**: Web-based collaborative platform
- **Troop**: Real-time collaborative editing
- **Flok**: Modern web-based collaboration

### Visual Integration
- **Hydra**: Live coding visuals
- **Processing**: Via OSC
- **TouchDesigner**: Via OSC/MIDI

## Tips

1. **Start Simple**: Begin with basic patterns, add complexity incrementally
2. **Use Variables**: Store reusable patterns in variables
3. **Chain Functions**: Combine transformations with `.` operator
4. **Prefer Mini-notation**: More concise than verbose function calls
5. **Stack Patterns**: Use `stack` for layering instead of multiple `d` channels
6. **Parameterize**: Use continuous patterns (`sine`, `saw`) for smooth changes
7. **Comment Sparingly**: Code should be self-documenting through clear naming

## Common Pitfalls

1. **Forgetting `$`**: Always use `$` or parentheses for function application
2. **Pattern Structure**: Remember patterns combine based on their structure
3. **Sample Names**: Sample names must match folder names exactly
4. **Timing**: Cycles are not beats - adjust tempo with `setcps`
5. **Effect Order**: Effects are processed in SuperDirt, not Tidal

## Essential Commands

```haskell
-- Playback control
d1, d2, ..., d16  -- Pattern channels
hush              -- Stop all
solo n            -- Solo channel n
mute n            -- Mute channel n

-- Tempo
setcps (bpm/60/4) -- Set tempo from BPM
getcps            -- Get current CPS

-- Pattern inspection
drawLine pattern  -- Visualize pattern
```

This reference provides comprehensive coverage of TidalCycles for LLM understanding, focusing on syntax, patterns, and practical implementation details necessary for generating functional TidalCycles code.
