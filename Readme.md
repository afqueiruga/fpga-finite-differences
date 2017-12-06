# Verilog Finite Difference Solver

Alejandro Queiruga c2013

A few years ago, while working with the engineering team at LBL on controls simulators, I went down the rabbit hole of trying to program simulations onto FPGAs. With some help from some of the best FPGA engineers there are, Larry Doolittle and John Jones, I managed to... get somewhere. It's a rabbit hole. It took 2 months to blink an LED.

This repo contains the most fruitful aspect of that venture. I managed to solve the heat equation in 1D on a relative small amount of points. I was limited to the precision of the multipliers on the fpga, as I recall. The file [oned.v](oned.v) contains logic that will perform one Jacobi iteration for the given stencil. The main project file is [tl_fdm1d.v](tl_fdm1d.v). I only ever ran it on my Spartan 6 board. I also recall that I didn't implement a good data transfer scheme; it was just communicating with the pins on my beaglebone.

My ultimate goal was to make a fully pipelined finite element assembler, unrolled entirely onto the fabric/multipliers. Every clock cycle would compute one local element matrix, which would be assembled on the host CPU. I gave up after realizing I was learning how to implement division...

Lessons:

1. More open source tools are needed. Having to go through Xillinx's IDE was cumbersome.
1. Complicated computations quickly require way too much fabric real estate to unroll. It's not a viable strategy. (Some of my simulations are 2MB of code for the FEM kernel calculations. That'll never fit in fabric.) Nonpipelined, custom processors running standard small-instruction set programs for the calculations is the way to go, e.g. GPUs, new RISC chips. Maybe an FPGA-based processor with customizable instruction sets.
1. I hate low-level hardware hacking now. penny wise, pound foolish.
