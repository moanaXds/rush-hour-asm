# Rush Hour in Assembly

A classic arcade-style taxi simulation game built entirely in x86 Assembly Language (MASM32). Navigate through city traffic, pick up passengers, avoid obstacles, and race against time!

## 🎮 About

**Rush Hour** is a taxi simulation game developed as a COAL (Computer Organization and Assembly Language) project. The game challenges players to navigate through a busy city grid, pick up passengers (P), and drop them at their destinations (D) while avoiding various obstacles and competing vehicles.

Built from scratch using pure Assembly Language - no game engines, no high-level frameworks, just raw processor instructions!

## ✨ Features

- **Two Game Modes**: Career Mode and Time Attack Mode
- **Vehicle Selection**: Choose between Red Speedy (fast but fragile) or Yellow Slow (slower but durable)
- **Dynamic Difficulty**: Game speed increases as you successfully drop more passengers
- **Real-time Collision Detection**: Custom-built collision system for walls, obstacles, and other vehicles
- **Scoring System**: Earn points by picking up passengers, dropping them off, and collecting bonuses
- **Leaderboard**: Track high scores across sessions (saved to file)
- **Background Music**: Immersive gameplay with sound effects via WinMM API
- **Pause/Resume**: Pause the game anytime during gameplay
- **Randomized Elements**: Obstacles, passengers, and bonuses spawn randomly each game

<img width="433" height="221" alt="image" src="https://github.com/user-attachments/assets/16df7a5a-6caf-42fc-ab11-d5667f287639" />

<img width="426" height="223" alt="image" src="https://github.com/user-attachments/assets/865da184-532d-4889-a68e-40f6e8f4118a" />

<img width="360" height="289" alt="image" src="https://github.com/user-attachments/assets/51f6ebb6-2619-458a-adce-c8d1d7ba4373" />

<img width="417" height="215" alt="image" src="https://github.com/user-attachments/assets/c5104d73-7a3d-4cd2-ac85-0afa7d1c24b2" />
---

## 🎯 Game Modes

### 1. Career Mode
- No time limit
- Focus on achieving the highest score possible
- Game difficulty increases with each successful drop
- Perfect for practicing and mastering the game mechanics

### 2. Time Mode
- 60-second time limit
- Fast-paced action
- Race against the clock to maximize your score
- More challenging and exciting!



## 💿 Installation

### Prerequisites
- **Windows OS** (32-bit or 64-bit)
- **MASM32 SDK** - [Download here](http://www.masm32.com/)
- **Irvine32 Library** - Usually included with MASM32
- **song.wav file** - Background music file (place in same directory as executable)

**Ensure Required Files**
   - `RushHour.asm` - Main game source code
   - `Irvine32.inc` - Header file
   - `Irvine32.lib` - Library file
   - `song.wav` - Background music
   - `HIGHSCORE.txt` - Leaderboard file (auto-created if missing)

## 🕹️ How to Play

### Getting Started
1. Launch the game and select **"Play New Game"** from the main menu
2. Enter your driver name
3. Choose your preferred game mode:
   - **Career Mode** - Play without time pressure
   - **Time Mode** - 60-second challenge
4. Select your taxi:
   - **Red Speedy** - Faster movement, takes more damage
   - **Yellow Slow** - Slower movement, more resistant to collisions

### Gameplay
1. **Navigate** through the city grid using arrow keys
2. **Find passengers** marked with **'P'** on the map
3. **Pick them up** by pressing **SPACE** when adjacent to them
4. **Destination** marked with **'D'** will appear after picking up a passenger
5. **Drop off** the passenger at the destination by pressing **SPACE**
6. **Avoid obstacles** and other vehicles to prevent score penalties
7. **Collect bonuses** ($) for extra points!

### Scoring
- **+10 points** - Successfully dropping off a passenger
- **+10 points** - Collecting bonus items ($)
- **-2 to -4 points** - Collision with obstacles (depends on taxi type)
- **-2 to -3 points** - Collision with other vehicles (depends on taxi type)

---

## 🗺️ Game Elements

| Symbol | Element | Description |
|--------|---------|-------------|
| **█** (Gray) | Wall | Boundary walls - cannot pass through |
| **▒** (Brown) | Building | Obstacle - causes damage on collision |
| **♠** (Green) | Tree | Obstacle - causes damage on collision |
| **█** (Blue) | Other Cars | Moving vehicles - causes damage on collision |
| **P** (Cyan) | Passenger | Pick up to start a delivery |
| **D** (Green) | Destination | Drop off location for current passenger |
| **$** (Magenta) | Bonus | Collect for extra points |
| **█** (Red/Yellow) | Your Taxi | Player-controlled vehicle |

---

## 🔧 Technical Details

### Architecture
- **Language**: x86 Assembly (MASM32)
- **Assembler**: Microsoft Macro Assembler (MASM)
- **Libraries**: Irvine32, WinMM
- **Platform**: Windows Console Application

### Key Components

#### Game Grid System
- **20x20 tile-based grid** stored in memory
- Each tile represented by a byte value (0-5)
- Efficient memory management using direct addressing

#### Collision Detection
- Real-time collision checking using coordinate comparison
- Separate handling for walls, obstacles, vehicles, and collectibles
- Damage calculation based on vehicle type

#### AI Movement
- Three AI-controlled vehicles with independent movement patterns
- Directional movement (Up, Down, Left, Right)
- Wrapping behavior at grid boundaries

#### File I/O
- High score persistence using file operations
- Player name and score saved to `HIGHSCORE.txt`
- Read/Write operations using Windows API calls

#### Audio Integration
- Background music via `PlaySoundA` function
- Asynchronous playback using WinMM library
- Start/Stop controls integrated with game state

### Memory Layout
```
.data segment:
- Game strings and messages
- Grid array (400 bytes)
- Player data structures
- AI vehicle coordinates
- File buffers
```

## 📚 Learning Outcomes

This project provided hands-on experience with:

### Low-Level Programming
- Direct memory manipulation using registers
- Understanding CPU instruction execution
- Stack and heap management
- Pointer arithmetic

### Game Development Concepts
- Game loop architecture
- Real-time user input handling
- Collision detection algorithms
- State management
- Sprite rendering in console

### System Programming
- Windows API integration
- File I/O operations
- Sound playback using multimedia libraries
- Console manipulation and cursor control

### Problem-Solving Skills
- Debugging assembly code
- Optimizing register usage
- Managing limited resources
- Implementing complex logic with minimal abstraction

---

## Need to improve on:

- [ ] **Multiplayer Mode** - Two-player competitive gameplay
- [ ] **Difficulty Levels** - Easy, Medium, Hard presets
- [ ] **Better Graphics** - Enhanced ASCII art or bitmap graphics
- [ ] **Sound Effects** - Collision sounds, pickup sounds, etc.
- [ ] **Leaderboard** - Store Top 10 scores

