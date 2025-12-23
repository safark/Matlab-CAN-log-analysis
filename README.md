# Sample Matlab CAN Data Scenario
## Overview
This project simulates CAN-style test data for a battery pack (voltage, current, temperature), decodes raw payload bytes into engineering units, and performs basic analysis (plots, statistics, anomaly checks).

## How to Run

generate_can_log("can_log.csv", 60, 0.1);
decode_can_log("can_log.csv","decoded_signals.csv");
analyze_can_signals("decoded_signals.csv");

## What I learned 
- How CAN IDs map to signal decoding rules
- How raw payload bytes become engineering units via scaling and endianness
- How to validate time-series test data with basic thresholds and reporting

## Photos
<img width="1679" height="1011" alt="temperature" src="https://github.com/user-attachments/assets/3c326fea-a798-4ad1-908c-fb934f2b9965" />
<img width="1679" height="1011" alt="pack_voltage" src="https://github.com/user-attachments/assets/37c006d4-0277-45c7-96ea-0764c567a0e9" />
<img width="1679" height="1011" alt="pack_current" src="https://github.com/user-attachments/assets/addc5874-f7b1-478d-b78d-10d6d65d6c18" />
