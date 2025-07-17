# Changelog

All notable changes to the MopBop Hunter DPS Optimizer will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-19

### Added
- **Complete Hunter DPS Optimization System**
  - Intelligent spell priority calculation based on damage, cooldowns, and focus
  - Real-time analysis of all available hunter spells
  - Support for all three hunter specializations (Marksmanship, Survival, Beast Mastery)

- **Comprehensive Spell Database**
  - Core abilities: Steady Shot, Arcane Shot, Kill Shot
  - Marksmanship: Aimed Shot, Chimera Shot, Multi-Shot
  - Survival: Explosive Shot, Black Arrow
  - Beast Mastery: Kill Command, Bestial Wrath
  - Utility: Rapid Fire, Readiness

- **Smart Resource Management**
  - Real-time focus tracking and management
  - Cooldown monitoring for all spells
  - Pet status tracking for pet-dependent abilities
  - Target health monitoring for execute phase

- **Talent Integration System**
  - Support for talent bonuses (damage multipliers, cooldown reductions)
  - Extensible talent system for future additions
  - Automatic damage calculation adjustments

- **User Interface**
  - Spell icon display showing next 3 optimal spells horizontally
  - Color-coded borders for spell availability (green/orange/gray)
  - Cooldown overlays on spell icons
  - Tooltips for spell details on hover
  - Draggable frame with customizable position
  - Status bar showing focus, target health, specialization, and pet status
  - Configuration window with spec selection dropdown

- **Slash Commands**
  - `/mopbop` and `/hunterdps` for help
  - `/mopbop hide/show` for visibility control
  - `/mopbop config` for configuration window
  - `/mopbop reset` for position reset

- **Event System**
  - Combat event tracking for spell casts
  - Target health monitoring
  - Focus and power updates
  - Pet status changes

- **Configuration System**
  - Persistent settings storage
  - Hunter specialization selection with dropdown
  - Customizable display options
  - Color scheme preferences
  - Frame positioning and sizing

### Technical Features
- **Performance Optimized**: Minimal impact on game performance
- **Memory Efficient**: Low memory usage with efficient event handling
- **Error Handling**: Graceful handling of missing spells and abilities
- **Extensible Architecture**: Easy to add new spells and talents

### Documentation
- Comprehensive README with installation and usage instructions
- Detailed spell database documentation
- Troubleshooting guide
- Contributing guidelines

---

## [0.1.0] - 2024-12-19

### Added
- Initial addon structure
- Basic UI framework
- Event handling system
- Configuration management

### Changed
- Converted from generic addon template to specialized hunter DPS optimizer

---

**Note**: This is the initial release of the Hunter DPS Optimizer. Future versions will include additional features, bug fixes, and improvements based on community feedback. 