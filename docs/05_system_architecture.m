                SAFE-LINK

             ┌─────────────┐
             │ Emergency   │
             │ Input       │
             └──────┬──────┘
                    ↓
             ┌─────────────┐
             │ Packet      │
             │ Generator   │
             └──────┬──────┘
                    ↓
             ┌─────────────┐
             │ CRC         │
             └──────┬──────┘
                    ↓
             ┌─────────────┐
             │ LoRa TX     │
             │ Baseband    │
             └──────┬──────┘
                    ↓
              RF Transceiver
                    ↓
                 ANTENNA
                    ))))
                 WIRELESS
                    ((((
                 ANTENNA
                    ↓
              RF Transceiver
                    ↓
             ┌─────────────┐
             │ LoRa RX     │
             │ Baseband    │
             └──────┬──────┘
                    ↓
             ┌─────────────┐
             │ CRC Check   │
             └──────┬──────┘
                    ↓
             ┌─────────────┐
             │ Emergency   │
             │ Alert       │
             └─────────────┘
