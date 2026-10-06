# UART Protocol – Verilog RTL

## Overview

This project implements a UART (Universal Asynchronous Receiver/Transmitter) using Verilog HDL.

The project includes both UART Transmitter (TX) and UART Receiver (RX) along with their respective testbenches and simulation waveforms.

## UART Configuration

- Data bits: 8
- Parity: None
- Stop bits: 1
- Baud rate: 9600
- Clock frequency: 100 MHz
- Data transmission: LSB first

## Project Structure

```text
uart-protocol/
│
├── README.md
│
├── uart_tx.v
├── uart_tx_tb.v
├── uart_tx_waveforms.png
│
├── uart_rx.v
├── uart_rx_tb.v
└── uart_rx_waveforms.png
