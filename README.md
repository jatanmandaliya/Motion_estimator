# Motion Estimator RTL and Testbench

## Overview

This repository implements a hardware motion estimation engine in SystemVerilog, with a complete verification environment. The design uses a 16-PE (processing element) systolic structure to search a 16x16 reference block inside a 32x32 search window and computes the best motion vector by minimizing SAD-like distortion.

Key components:
- `top.v`: top-level RTL with control, PE array, comparator, and memory interfaces
- `top_tb.v`: randomized testbench (generates random search/target data, checks results)
- `top_tb_direct.v`: deterministic testbench using `ref.txt` and `search.txt` via `$readmemh`
- `Makefile`: compile and run flow for Synopsys VCS

## Functional Description

### Core behavior
- Input: reference block (R) and search block (S1/S2) streaming through ROMs
- `control`: orchestrates scanning of offsets, addresses, and PE control signals
- `PE` and `PEend`: compute cumulative absolute differences for each candidate
- `PEtotal`: chain 16 PEs in pipeline
- `Comparator`: tracks minimum accumulated difference and outputs best `motionX`, `motionY`, `BestDist`
- Completed when the full search range is scanned (4112 cycles)

### Motion vector region
- Search window: 32x32
- Reference block: 16x16
- Candidate offsets: [-8..7] for x, y (16x16 vectors)

## File Layout

- `top.v`: RTL modules
- `top_tb.v`, `top_tb_direct.v`: testbench modules
- `ref.txt`, `search.txt`: reference & search memory vectors used by `top_tb_direct.v`
- `Makefile`: workflows: `test`, `compile`, `run`, `debug`, `dve`, `clean`, etc.
- `files/`: synthesis & physical reports and extra data from CAD flows

## Requirements

- Verilog simulator, e.g., Synopsys VCS (project Makefile is VCS-specific)
- Unix-like shell (Makefile commands are POSIX/macros compatible)

## Build and simulation

From `Motion_estimator`:

- `make` or `make test`: runs `compile` then `run`.
- `make compile`: `vcs -l vcs.log -sverilog -debug_all -full64 top_tb.v top.v`
- `make run`: `./simv -l simv.log +ntb_random_seed=$(SEED)`
- `make debug`: interactive wave GUI
- `make dve`: post-process visualization with `dve`
- `make clean`: remove simulation artifacts

Use `make test SEED=42` to control random seed reproducible behavior.

## Verification checks

- `top_tb.v` randomizes `Smem`, selects a random `Expected_motionX`, `Expected_motionY`, and builds `Rmem` accordingly
- Compares DUT outputs with expected motion vector after scan
- Reports match/non-match and reference found conditions

## Reference data

- `ref.txt`, `search.txt` are example static memory contents for reproducing deterministic results.
- `ref_hex.txt`/`search_hex.txt` and `ref_binary.txt`/`search_binary.txt` are additional format variants.

## Extend or customize

- Modify `top.v` to experiment with alternative distortion metrics (e.g., squared error)
- Add coverage assertions in testbench to capture motion-plane and best-distance properties
- Add a script to dump results into CSV or integrate with CI

## Notes

- The design saturates accumulation at `8'hFF` on overflow.
- Motion output is 4-bit unsigned; testbench converts to signed range [-8..7].
