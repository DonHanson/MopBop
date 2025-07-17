# MopBop - Hunter DPS Optimizer

A comprehensive World of Warcraft Classic Mists of Pandaria addon that optimizes hunter DPS by providing continuously updating suggestions for the next 3 spells to cast, taking into account spell damage, cooldowns, focus costs, and talent interactions.

## 🎯 Features

### DPS Optimization Engine
- **Intelligent Spell Priority System**: Analyzes all available spells and ranks them by optimal DPS output
- **Real-time Calculations**: Continuously updates suggestions based on current game state
- **Talent Integration**: Considers talent bonuses and cooldown reductions
- **Situational Awareness**: Adapts to target health, pet status, and multiple targets

### Comprehensive Spell Database
- **All Hunter Specs**: Supports Marksmanship, Survival, and Beast Mastery
- **Core Abilities**: Steady Shot, Arcane Shot, Kill Shot
- **Specialization Spells**: Aimed Shot, Chimera Shot, Explosive Shot, Kill Command
- **Utility Abilities**: Rapid Fire, Readiness, Multi-Shot
- **Damage Tracking**: Real-time damage calculations with talent multipliers

### Smart Resource Management
- **Focus Tracking**: Monitors current focus and adjusts spell priorities
- **Cooldown Management**: Tracks all spell cooldowns in real-time
- **Pet Status**: Monitors pet health and availability for pet-dependent abilities
- **Target Health**: Adapts rotation for execute phase (Kill Shot below 20% HP)

### User-Friendly Interface
- **Spell Icon Display**: Shows next 3 optimal spells as icons with numbers
- **Horizontal Layout**: Icons arranged left-to-right (1st, 2nd, 3rd priority)
- **Color Coding**: 
  - 🟢 Green border: Ready to cast
  - 🟠 Orange border: On cooldown
  - ⚫ Gray border: Unavailable
- **Cooldown Overlays**: Visual cooldown indicators on spell icons
- **Tooltips**: Hover over icons for spell details
- **Status Bar**: Current focus, target health, specialization, and pet status
- **Draggable Frame**: Move anywhere on screen
- **Configuration UI**: Easy spec selection with dropdown menu

## 📦 Installation

1. **Download**: Clone or download this repository
2. **Extract**: Place the `MopBop` folder in your WoW addons directory:
   ```
   World of Warcraft/_classic_/Interface/AddOns/MopBop/
   ```
3. **Enable**: Enable the addon in WoW's addon list
4. **Load**: The addon will automatically start tracking when you log in

## 🎮 Usage

### Basic Commands
- `/mopbop` or `/hunterdps` - Show help and available commands
- `/mopbop hide` - Hide the addon interface
- `/mopbop show` - Show the addon interface
- `/mopbop config` - Open configuration window
- `/mopbop reset` - Reset position to center of screen

### Interface Controls
- **Left Click + Drag**: Move the addon frame
- **Right Click**: Toggle addon visibility
- **Real-time Updates**: Suggestions update automatically during combat

### Understanding the Display
```
Hunter DPS Optimizer
[1] [2] [3]  (Spell icons with numbers)
Focus: 85 | Target HP: 15.2% | Spec: Survival | Pet: Alive
```

The addon displays three spell icons horizontally:
- **Left icon (1)**: Next spell to cast
- **Middle icon (2)**: Second spell to cast  
- **Right icon (3)**: Third spell to cast

Icons show cooldown overlays and color-coded borders:
- 🟢 Green border: Ready to cast
- 🟠 Orange border: On cooldown
- ⚫ Gray border: Unavailable

## 🔧 Configuration

### Configuration Window
Use `/mopbop config` to open the configuration window where you can:
- **Select Hunter Specialization**: Choose between Survival, Marksmanship, and Beast Mastery
- **Default Selection**: Survival is selected by default
- **Persistence**: Your selection is saved between game sessions

### Automatic Settings
The addon automatically saves your preferences including:
- Frame position and size
- Display options (damage values, cooldowns)
- Color schemes
- Visibility settings
- Selected specialization

## 📊 Supported Spells

### Core Abilities
| Spell | Damage | Focus | Cooldown | Notes |
|-------|--------|-------|----------|-------|
| Steady Shot | 1000 | 0 | 0s | Basic filler |
| Arcane Shot | 1200 | 30 | 0s | Instant focus dump |
| Kill Shot | 2500 | 0 | 0s | Execute (below 20% HP) |

### Marksmanship
| Spell | Damage | Focus | Cooldown | Notes |
|-------|--------|-------|----------|-------|
| Aimed Shot | 2000 | 50 | 0s | High damage, long cast |
| Chimera Shot | 1800 | 35 | 9s | Strong instant shot |
| Multi-Shot | 800 | 40 | 0s | AOE ability |

### Survival
| Spell | Damage | Focus | Cooldown | Notes |
|-------|--------|-------|----------|-------|
| Explosive Shot | 1500 | 25 | 6s | DoT with cooldown |
| Black Arrow | 800 | 35 | 30s | DoT, long cooldown |

### Beast Mastery
| Spell | Damage | Focus | Cooldown | Notes |
|-------|--------|-------|----------|-------|
| Kill Command | 1200 | 0 | 60s | Pet damage ability |
| Bestial Wrath | 0 | 0 | 120s | Pet damage buff |

### Utility
| Spell | Damage | Focus | Cooldown | Notes |
|-------|--------|-------|----------|-------|
| Rapid Fire | 0 | 0 | 300s | Haste buff |
| Readiness | 0 | 0 | 180s | Reset cooldowns |

## 🎯 Talent Integration

The addon supports talent bonuses including:
- **Improved Arcane Shot**: +15% damage
- **Improved Aimed Shot**: +10% damage, -0.5s cast time
- **Careful Aim**: +20% damage
- **Improved Chimera Shot**: +10% damage
- **Improved Explosive Shot**: +15% damage
- **Improved Kill Command**: -10s cooldown

## 🔄 How It Works

1. **Data Collection**: Monitors player focus, spell cooldowns, target health, and pet status
2. **Priority Calculation**: Analyzes all available spells based on damage, cooldowns, and requirements
3. **Talent Application**: Applies relevant talent bonuses to damage and cooldown calculations
4. **Situational Adjustment**: Adjusts priorities based on current game state
5. **Display Update**: Shows the top 3 optimal spells with relevant information

## 🐛 Troubleshooting

### Common Issues
- **Addon not showing**: Use `/mopbop show` to display the interface
- **Wrong position**: Use `/mopBop reset` to center the frame
- **No suggestions**: Ensure you have a target and are in combat
- **Missing spells**: Verify you have learned the required abilities

### Performance
- The addon is optimized for minimal performance impact
- Updates occur only when necessary (combat events, focus changes)
- Memory usage is kept low through efficient event handling

## 🤝 Contributing

Contributions are welcome! Please feel free to:
- Report bugs or issues
- Suggest new features
- Submit pull requests
- Improve documentation

## 📄 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- Blizzard Entertainment for World of Warcraft
- The WoW Classic community for feedback and testing
- All contributors who help improve the addon

---

**Happy Hunting!** 🏹 