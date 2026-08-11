# LoRa Fundamentals

## 1. What is LoRa?
LoRa (short for Long Range) is a low-power, long-range wireless RF communication technology developed primarily for Internet of Things (IoT) applications. It allows battery-operated devices to transmit small amounts of data over long distances without relying on cellular networks or power-intensive Wi-Fi.

## 2. What is a Chirp?
A chirp is a signal whose frequency continually changes (sweeps) over time across a specific bandwidth. Instead of transmitting on a fixed frequency, LoRa sweeps across a range of frequencies to encode data.
Upchirp & Downchirp
Upchirp: A signal sweep where the frequency starts low and continuously increases over time. Standard data symbols in LoRa are encoded using modulated upchirps.
Downchirp: A signal sweep where the frequency starts high and continuously decreases over time. These are primarily used in the frame preamble for sync and calibration.

## 3. What is a LoRa Symbol?
In LoRa technology, a LoRa symbol is the fundamental unit of digital data transmitted over the radio waves. It is represented physically by a single chirp signal (a continuous sweep across a frequency band).
Rather than sending bits one by one (like traditional binary keying), LoRa groups multiple bits together into a single symbol, and that single symbol is sent as one complete chirp.

## 4. Spreading Factor
The Spreading Factor determines how many chips (radio pulses) are used to represent a single symbol of data. LoRa typically uses values from $SF7$ to $SF12$.Mathematical Relationship: $1 \text{ Symbol} = 2^{SF} \text{ chips}$.Trade-off:Higher $SF$ (e.g., $SF12$): Sends fewer bits per second, but significantly increases range and receiver sensitivity (can penetrate deeper obstacles).Lower $SF$ (e.g., $SF7$): Sends data faster and uses less battery, but reaches shorter distances.

## 5. Bandwidth
Bandwidth is the range of frequencies over which the chirp sweeps (typically $125\text{ kHz}$, $250\text{ kHz}$, or $500\text{ kHz}$).Impact: Doubling the bandwidth doubles the data rate (faster transmission), but slightly reduces receiver sensitivity and range.

## 6. Coding Rate
LoRa uses Forward Error Correction (FEC) to recover data corrupted by interference. The Coding Rate defines the ratio of actual data bits to total transmitted bits (data + error-correction bits).Options: Represented as $4/(4 + n)$ where $n \in \{1, 2, 3, 4\}$ (written as $4/5, 4/6, 4/7, 4/8$).Trade-off: A $CR$ of $4/8$ doubles the overhead (adds 4 redundant bits for every 4 data bits), making the transmission much more robust against noise at the expense of airtime.

## 7. Preamble
A sequence of identical, unmodulated upchirps transmitted at the very beginning of a packet. It allows the receiver to detect an incoming transmission, lock onto the frequency, and synchronize its internal clock with the sender.

## 8. Payload
The actual application data being sent (e.g., sensor readings, battery level, GPS coordinates), encoded with error correction bits specified by the Coding Rate.

## 9. CRC
A $2\text{-byte}$ checksum appended at the end of the packet. The receiver recalculates this checksum upon arrival; if it doesn't match, the receiver knows the packet was corrupted during transmission and discards it.

## 10. Modulation
Modulation is the process of modifying one or more properties (such as amplitude, frequency, or phase) of a high-frequency carrier signal in accordance with an information-bearing baseband signal (data or message).

## 11. Demodulation
Demodulation is the inverse process of modulation. It is performed at the receiver to extract the original baseband message signal from the incoming modulated carrier wave.

## 12. Synchronization
Synchronization is the process of aligning the receiver's internal clocks, carrier frequency, and frame timing precisely with those of the transmitter so that the incoming data can be accurately sampled and decoded.
