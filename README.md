# SPI-Slave-Interface
### This repository contains Verilog code for an SPI (Serial Peripheral Interface) Wrapper module that integrates an SPI Slave and a RAM module to facilitate communication between a master device and a memory block. The design is optimized to operate at the highest possible frequency by choosing the best state encoding based on timing analysis.

## Project Overview
This repository contains a Verilog-based SPI Slave Interface designed to communicate with a master device and a RAM module, creating a testbench(Master) for verification, and running the design flow using Vivado and QuestaSim.
High-Frequency Operation: Optimized for performance with the best state encoding based on timing analysis.
Comprehensive Files: Includes bitstream, constraints, do files, netlist, documentation, RTL, and testbench verification

## Directory Structure
Top Module (SPI Wrapper): Contains the RTL code for the Wrapper that connects between RAM & Slave.
RAM Module: The part used in storing data coming from Slave.
Slave Module: The part used in Sending data coming from Master in a specific protocol.
RAM Testbench: Includes the testbench code for checking RAM functionality.
Slave Testbench: Includes the testbench code for checking Slave functionality.
Master: Includes the testbench code for the overall system to check the whole functionality is running well. 
Constraints File: Constraints file to connect ports to FPGA.
Do File: A scripted running file to automate questa sim flow.
Bitstream: Bitstream file generated after implementation on FPGA.
Netlist: This is a Verilog netlist of the current design or from a specific cell of the design. The output is anIEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input design files.

## Some Snippets :
### Elaborated Design Schematic : 
![Screenshot 2024-08-04 144522](https://github.com/user-attachments/assets/0c718c8e-4e32-4d76-b55e-8bcee2bd10a6)
### Synthesis Schematic : 
![Screenshot 2024-08-04 151058](https://github.com/user-attachments/assets/14c49ae4-e254-4f27-a2b3-5a6e5202a27f)

### Device After Implementation on FPGA Artex7 - Basys 3
![Screenshot 2024-08-04 154803](https://github.com/user-attachments/assets/eb3574d8-77dd-4279-8838-15c725a914b8)
![Screenshot 2024-08-04 154853](https://github.com/user-attachments/assets/14729c9f-c0b5-4f6c-9514-44b12c1d1b68)


## For the whole files on Google Drive:
https://drive.google.com/drive/u/0/folders/1eWnZ33xfN9CRzkFblkEOnctfzjJTbUqh
