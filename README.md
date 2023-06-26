# HBM_HEATING
A hardware design purpose built for heating up an HBM chip

Based on the project found [here](https://github.com/Capstone2022Team17/drgbl)  

## Background

High Bandwidth Memory (HBM) has an operating range of 0-45 degreese celcius. If these chips are to be used in a hard environment, such as on a spacecraft, the must somehow be heated.  

This project aims to create hardware designs that can heat up HBM chips without any external heaters.  

To accomplish this, this project was built using the Xilinx Alveo u280 board. This board contains a Xilinx ultrascale+ FPGA and two HBM chips. Each HBM chip has a capacity of four gigabytes for a total of eight gigabytes. To interact with these chips Xilinx provides the [AXI HBM Controller IP](https://docs.xilinx.com/r/en-US/pg276-axi-hbm)  

## Basic Overview
For this project I've designed an AXI traffic generator. Thus far this traffic generator supports sequential reads, writes, queued reads, and queued writes. The traffic generator has 32 axi controllers to interact with all 32 axi ports on the HBM controller IP. The traffic generator is controlled by a UART which is connected to an external user interface program.

![](https://github.com/Collin-Lambert/HBM_HEATING/blob/main/IMAGES/Original_System_Design.png)

## Full Implementation / Getting Started
See the [wiki](https://github.com/Collin-Lambert/HBM_HEATING/wiki)
