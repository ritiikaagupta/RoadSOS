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
- ## 8. LoRa Symbol Modulation

A LoRa symbol is represented using a cyclic shift of
the reference chirp.

For the initial reference model, Symbol 0 corresponds
to the unshifted base upchirp.

For a symbol value k, the waveform is shifted according
to the symbol position within the available symbol space.

For SF7:

2^7 = 128 possible symbol values

Therefore, valid symbols range from 0 to 127.

### Initial Verification

The Python model was tested with:

- Symbol 0
- Symbol 25
- Symbol 64
- Symbol 127

The resulting waveforms were generated and compared
using the Python reference model.

Output:

- `symbol_0.png`
- `symbol_comparison.png`
## 9. LoRa Dechirping and Symbol Detection

The receiver uses a reference downchirp to dechirp
the received LoRa symbol.

The dechirped signal is then transformed into the
frequency domain using an FFT.

The location of the dominant FFT peak corresponds
to the transmitted symbol.

### Receiver Processing

Received Symbol
    ↓
Dechirping
    ↓
FFT
    ↓
Peak Detection
    ↓
Recovered Symbol

### Verification

The Python reference model was tested using multiple
symbol values.
## 10. Noise Robustness Testing

To evaluate the robustness of the LoRa symbol detector,
AWGN was introduced between the transmitter and receiver.

Different SNR values were evaluated.

The received signal was processed using:

Received Signal
    ↓
Dechirping
    ↓
FFT
    ↓
Peak Detection
    ↓
Symbol Decision

Multiple trials were performed for each SNR value.

The symbol detection accuracy was calculated as:

Accuracy =
Correctly Detected Symbols / Total Symbols × 100

The resulting accuracy-versus-SNR curve is stored as:

`simulation/python_reference/symbol_detection_accuracy.png`

For the initial tests, the transmitted symbol and
detected FFT peak were compared.

Successful detection demonstrates the basic
principle of LoRa symbol recovery.
## 11. Preamble and Synchronization

A known preamble is transmitted before the data portion
of the packet.

For the initial SAFE-Link Python reference model, the
preamble consists of:

- 4 upchirps
- 2 downchirps

The receiver searches for the known upchirp using
correlation.

### Synchronization Process

Received Samples
    ↓
Correlation with Reference Upchirp
    ↓
Correlation Peak
    ↓
Preamble Start
    ↓
Symbol Boundary
    ↓
Data Processing

The initial implementation is intended as a reference
model for understanding synchronization. More robust
timing and frequency synchronization will be considered
during later PHY refinement.
