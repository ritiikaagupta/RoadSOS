from lora_config import SPREADING_FACTOR, BANDWIDTH_HZ

num_symbols = 2 ** SPREADING_FACTOR

print("SAFE-Link LoRa Configuration")
print("-----------------------------")
print(f"Spreading Factor : {SPREADING_FACTOR}")
print(f"Bandwidth        : {BANDWIDTH_HZ} Hz")
print(f"Possible symbols : {num_symbols}")
