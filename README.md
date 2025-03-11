# SPI Slave with Single Port RAM

This project implements an SPI slave module that communicates with a single-port RAM. The SPI slave receives data from a master device, storing and retrieving data to and from the RAM.

## Project Overview

The SPI slave module is designed to handle data transfer between a master and a slave device using the SPI protocol. The single-port RAM module is used for data storage and retrieval. The project integrates both modules to enable SPI communication with a memory block.

### Features

- **SPI Slave Module**: Manages SPI protocol and data transfer.
- **Single Port RAM**: Handles data storage and retrieval.
- **Wrapper Module**: Integrates the SPI Slave and RAM modules for seamless communication.

### Modules

1. **SPI Slave Module**:
   - **Inputs**: MOSI, SS_n, clk, rst_n
   - **Outputs**: MISO, rx_data, rx_valid, tx_data, tx_valid

2. **Single Port RAM Module**:
   - **Inputs**: din, clk, rst_n, rx_valid
   - **Outputs**: dout, tx_valid

3. **Wrapper Module**:
   - Integrates the SPI Slave and RAM modules.
   - Manages data transfer between the master device and the RAM.

### Ports and Signals

#### SPI Slave Ports

| Port Name | Type   | Size    | Description                     |
|-----------|--------|---------|---------------------------------|
| MOSI      | Input  | 1 bit   | Master Out Slave In (Data from master) |
| MISO      | Output | 1 bit   | Master In Slave Out (Data to master)   |
| SS_n      | Input  | 1 bit   | Slave Select (Active Low)              |
| clk       | Input  | 1 bit   | Clock signal                          |
| rst_n     | Input  | 1 bit   | Active Low Reset signal               |
| rx_data   | Output | 10 bit  | Received data from master             |
| rx_valid  | Output | 1 bit   | Indicates valid received data         |
| tx_data   | Input  | 10 bit  | Data to be transmitted to master      |
| tx_valid  | Input  | 1 bit   | Indicates valid data to transmit      |

#### RAM Ports

| Port Name | Type   | Size    | Description                     |
|-----------|--------|---------|---------------------------------|
| din       | Input  | 10 bit  | Data input                      |
| clk       | Input  | 1 bit   | Clock signal                    |
| rst_n     | Input  | 1 bit   | Active Low Reset signal         |
| rx_valid  | Input  | 1 bit   | Indicates valid data input      |
| dout      | Output | 8 bit   | Data output                     |
| tx_valid  | Output | 1 bit   | Indicates valid data output     |

### Operation

The SPI slave module receives data from the master device and processes it based on the SPI protocol. The most significant bits of the input data (`din[9:8]`) determine the operation to be performed:

- **00**: Write - Holds `din[7:0]` as a write address.
- **01**: Write - Writes `din[7:0]` to the memory at the held write address.
- **10**: Read - Holds `din[7:0]` as a read address.
- **11**: Read - Reads data from the memory at the held read address and outputs it on `dout`.

### RTL Code Snippets

#### SPI Slave Module

```verilog
module SPI_Slave (MOSI, MISO, SS_n, clk, rst_n, rx_data, rx_valid, tx_data, tx_valid);
    // Port declarations
    input MOSI, SS_n, clk, rst_n;
    input [9:0] tx_data;
    input tx_valid;
    output [9:0] rx_data;
    output rx_valid, MISO;

    // Internal signals and state machine logic
    // ...
endmodule

## Some Snippets :
- Elaborated Design Schematic : 
![Screenshot 2024-08-04 144522](https://github.com/user-attachments/assets/0c718c8e-4e32-4d76-b55e-8bcee2bd10a6)
- Synthesis Schematic : 
![Screenshot 2024-08-04 151058](https://github.com/user-attachments/assets/14c49ae4-e254-4f27-a2b3-5a6e5202a27f)

### Device After Implementation on FPGA Artex7 - Basys 3
- ![Screenshot 2024-08-04 154803](https://github.com/user-attachments/assets/eb3574d8-77dd-4279-8838-15c725a914b8)
- ![Screenshot 2024-08-04 154853](https://github.com/user-attachments/assets/14729c9f-c0b5-4f6c-9514-44b12c1d1b68)
