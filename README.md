# MIPS Assembly Tetris

A classic **Tetris clone** implemented in **MIPS assembly**, developed as the final project for **CSCB58 Summer 2024** at the University of Toronto Scarborough (UTSC).

## Project Info

- **Display Address**: `0x10008000`  
- **Keyboard Address**: `0xffff0000`

---

## Gameplay Instructions

- **A / D**: Move tetromino left / right  
- **W**: Rotate current tetromino  
- **S**: Soft drop  
- **Space**: Hard drop to bottom  
- **Game Over**: Occurs when new blocks collide at the top of the board

---

## ✅ Features

### Easy Features
- [x] Block movement and rotation  
- [x] Gravity and soft drop  
- [x] Full game loop with keyboard input  
- [x] Block collision detection  
- [x] Tetromino outline indicator  

### Hard Features
- [x] Full line detection and clearing  
- [x] Tetromino-specific rotation with collision checks  
- [x] Game ends gracefully when blocks reach the top  

---

## Demo Video

🔗 [Click here to view the demo](https://drive.google.com/file/d/1j9cBtMXiM_knzpv9sCD_pn8I7eqPQxtq/view?usp=sharing)

---

## Tech & Architecture

- Custom rendering using bitmap display  
- MIPS syscalls for delays and I/O  
- Stack-based handling of block positions  
- Modularized drawing logic for all 7 tetromino types  
- Real-time input handling and dynamic gravity system

---

## Notes

- This game is designed to run on **MARS or SPIM simulators** with bitmap and keyboard memory-mapped I/O connected.
- Game terminates when block stacking reaches the top row.
