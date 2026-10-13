# REA demo: find a hidden license key

A small lesson in how REA works. We take a program **without its source
code** and find out how it checks a license key.

- `keycheck.c` is the "answer key". The analysis never reads it.
- `keycheck` is the compiled program. It is **stripped**, so all function
  names are removed, like most real apps.
- `01-…05-*.json` are the real REA results from each step below.

## Setup used

```bash
export GHIDRA_INSTALL_DIR=/opt/ghidra/ghidra_12.1.4
export HOPPER_LAUNCHER_PATH=/opt/hopper/bin/Hopper
alias rea='npx -y rea-agents@6.4.0'
rea doctor        # checks that REA, Ghidra and Hopper are ready
```

## The 5 steps

| Step | Question | Command | What we learned |
|------|----------|---------|-----------------|
| 1 | What is inside? | `rea analyze keycheck --provider ghidra` | Linux x86-64 program, 26 functions, 42 text strings. |
| 2 | Where is the license logic? | `rea trace keycheck "License" --provider ghidra` | The 3 license messages are all used by one function at `0x101169`. |
| 3 | What does that code do? | `rea decompile keycheck 0x101169 --provider ghidra` | Key must be 8 characters. Each character XOR `0x5A` must equal a hidden table at `0x102050`. |
| 4 | What is in the hidden table? | `rea read-bytes keycheck 0x102050 --length 8 --provider ghidra` | `0e 08 0f 09 0e 16 1b 14` |
| 5 | Check with a second engine | `rea trace keycheck "License OK" --provider hopper`, then `rea decompile keycheck 0x1169 --provider hopper` | Hopper shows the same logic. Hopper uses a different base address (`0x1169` instead of `0x101169`). |

Undo the XOR:

```bash
python3 -c 'print(bytes(b ^ 0x5A for b in bytes.fromhex("0e080f090e161b14")).decode())'
# TRUSTLAN
./keycheck TRUSTLAN   # License OK. Welcome!
```

## The general method

1. **Overview**: what kind of file is it, and what is inside?
2. **Find a clue**: a text message, button label or error you can see.
3. **Trace**: which code uses that clue?
4. **Decompile**: read that code as C-like code.
5. **Read data**: look at the tables or values that the code uses.
6. **Confirm**: check with a second engine, or run the program.

Every REA result has an `evidence_id`, so each claim can be traced back to
the exact result that proves it.

## What REA works on

- Native programs: Linux ELF, Windows EXE/DLL, macOS Mach-O (Ghidra, Hopper)
- Android APKs, .NET assemblies, Electron/JavaScript apps
- Firmware images and archives (ZIP, IPA, DMG …)
- Web pages you open yourself, and saved network captures (HAR)

REA needs **a file or app you have**. It cannot see code that runs on
someone else's server.
