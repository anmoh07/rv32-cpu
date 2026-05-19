# RV32I-CPU
Single-cycle RV32I core implemented in SystemVerilog and simulated using QuestaSim.

## Features

- Single-cycle datapath
- RV32I instruction subset
- Combinational instruction/data memory reads
- Synchronous register and memory writes
- Modular datapath design

## Toolchain

- SystemVerilog
- QuestaSim
- RISC-V GNU Toolchain

## Implemented Instructions

### Arithmetic / Logic
- ADD
- SUB
- XOR
- OR
- AND
- SLL
- SRL
- SRA
- SLT
- SLTU

### Immediate Arithmetic
- ADDI
- XORI
- ORI
- ANDI
- SLLI
- SRLI
- SRAI
- SLTI
- SLTIU

### Branches
- BEQ
- BNE
- BLT
- BGE
- BLTU
- BGEU

### Jumps
- JAL
- JALR

### Memory
- LW
- SW

## Datapath Overview

The processor uses a fully single-cycle datapath:
- instruction fetch
- decode
- execute
- memory access
- writeback

all occur within one clock cycle.

## Architectural Notes

- x0 is hardwired to zero
- JALR clears bit 0 of the target address per RV32I specification
- Instruction memory is modeled as combinational ROM
- Data memory uses asynchronous reads and synchronous writes

## Project Structure

rtl/
    pc.sv
    rom.sv
    decoder.sv
    control_unit.sv
    regfile.sv
    alu.sv
    branch_unit.sv
    data_mem.sv
    cpu_top.sv

## Future Work

- Pipelined implementation
- Hazard handling
- FPGA deployment
- Asynchronous prototyping
