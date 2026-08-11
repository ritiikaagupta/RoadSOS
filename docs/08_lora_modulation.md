# LoRa Modulation

## 1. Objective

The objective of this stage is to generate and analyze
a LoRa baseband upchirp using Python.

## 2. Temporary Configuration

- Spreading Factor: SF7
- Bandwidth: 125 kHz
- Sample Rate: 1 MHz

These parameters are temporary and are used for
reference-model development.

## 3. Symbol Duration

The LoRa symbol duration is:

T_sym = 2^SF / BW

For SF7 and BW = 125 kHz:

T_sym = 1.024 ms

## 4. Chirp

An upchirp is a signal whose instantaneous frequency
increases with time.

## 5. Python Reference Model

The Python model generates a complex baseband chirp
consisting of I and Q components.

## 6. Verification

The generated waveform is plotted and its instantaneous
frequency is analyzed to verify the expected frequency
sweep.
## 7. Downchirp

A downchirp is a chirp whose instantaneous frequency
decreases with time.

The downchirp is important for the receiver because
it can be used as a reference waveform during
dechirping.

The Python reference model generates a complex
baseband downchirp using the same temporary LoRa
configuration as the upchirp.

### Verification

The instantaneous frequency of the generated
downchirp was plotted and verified to decrease
with time.

Output:

- `simulation/python_reference/downchirp_frequency.png`
