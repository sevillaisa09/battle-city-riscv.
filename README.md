# Battle City — RISC-V Assembly

A recreation of **Battle City** (Namco, NES 1985) written entirely in **RISC-V assembly** for the RARS simulator. No high-level language, no engine: rendering, collision detection, enemy AI and input handling are implemented directly against a memory-mapped bitmap display and MMIO keyboard.

![RISC-V](https://img.shields.io/badge/RISC--V-283272?style=flat-square&logo=riscv&logoColor=white)
![Assembly](https://img.shields.io/badge/Assembly-6E4C13?style=flat-square)
![RARS](https://img.shields.io/badge/RARS-simulator-blue?style=flat-square)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black)

**~9,500 lines · 96 routines · 889 function calls**

---

## Overview

Three levels of the original game, rebuilt at the instruction level. Every pixel written to the display is a store to a mapped memory address; every key press is polled from an MMIO status register. There is no standard library, no dynamic allocation and no abstraction between the code and the machine.

---

## Features

- Title screen with course and author information, advancing on key press
- Three levels reproducing the original layouts, block types and difficulty progression
- Player movement on both axes with full collision handling against brick, steel and terrain
- Four concurrent enemy tanks, each with independent state: position, direction, active flag, bullet state, fire timer, movement timer and respawn countdown
- Enemy respawn cycle with spawn animation
- Destructible terrain — brick blocks are removed on impact while steel resists
- Helmet power-up granting temporary invulnerability, on a countdown timer
- Shovel power-up reinforcing the base walls, reverting when the timer expires
- Life and kill counters, game over handling and return to the title screen
- Pause functionality

---

## Technical highlights

- **Bitmap display rendering.** The framebuffer is addressed through `gp`; drawing routines compute pixel offsets arithmetically and write colour words directly to memory.
- **MMIO keyboard input.** Key state is polled from `0xFFFF0000` and the character read from `0xFFFF0004`, with explicit status clearing to avoid repeat reads.
- **RISC-V calling convention.** Routines follow the standard register convention, with prologues and epilogues saving `ra` and callee-saved registers to the stack across 889 call sites.
- **Structured memory layout.** Game state lives in `.data` as named words; constants are defined with `.eqv` rather than magic numbers; the stack is used exclusively for call frames and locals.
- **Hardware randomness via syscalls.** The RNG is seeded from the system clock (`a7=40`, `a7=41`) so enemy behaviour varies between runs.
- **Timer-driven mechanics.** Power-up durations, fire rate, movement cadence and respawn delays are all driven by decrementing counters in the main loop.

---

## Running the project

**Requirements:** Linux, Java, and the [RARS simulator](https://github.com/TheThirdOne/rars).

1. Open `battle_city.asm` in RARS.
2. Assemble the program: **Run → Assemble** (F3).
3. Open **Tools → Bitmap Display** and set:

   | Setting | Value |
   |---------|-------|
   | Unit Width | 8 |
   | Unit Height | 8 |
   | Display Width | 512 |
   | Display Height | 512 |
   | Base Address | `gp` |

   Then press **Connect to Program**.
4. Open **Tools → Keyboard and Display MMIO Simulator** and press **Connect to Program**.
5. Run the program: **Run → Go** (F5).
6. Click inside the lower window of the Keyboard simulator to send input.

> Input only registers while the Keyboard simulator window has focus.

---

## Controls

| Key | Action |
|-----|--------|
| `1` | Start game from the title screen |
| `W` `A` `S` `D` | Move |
| `Space` | Fire |
| `P` | Pause |

---

## What I learned

Assembly removes every safety net. There are no types, no bounds checking and no variables — only registers, addresses and the discipline to keep track of what each one holds. The hardest constraint was register pressure: with a limited set of registers and deep call chains, deciding what to keep live and what to spill to the stack shaped the design of every routine.

Coordinating four independent enemies without objects or structs meant laying out parallel state in `.data` and addressing it by offset, which made the memory layout itself part of the program's design. Working this close to the machine also made the cost of every instruction visible in a way that no high-level language exposes.

---

## Credits

Developed by **Isabel Sevilla** and **Steven Fonseca** for **EL-3310 Digital Systems Design** at the Costa Rica Institute of Technology (TEC).

Built on base code by **Prof. Ernesto Rivera Alvarado**, used with permission under his stated terms. The original copyright notice is preserved in the source file header.

---

## Author

**Isabel Sevilla** — [LinkedIn](https://www.linkedin.com/in/isabel-sevilla-816823367/) · [sevillaisa09@gmail.com](mailto:sevillaisa09@gmail.com)
