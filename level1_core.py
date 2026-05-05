# RoadSoS Level 1: Primary Connectivity Logic
def detect_connection():
    # This will eventually check for 4G/5G signal
    signal_strength = 100 # Mock value for now
    if signal_strength > 50:
        return "SUCCESS: Connected to Cloud"
    else:
        return "FAIL: Moving to Level 2 (SMS)"

print(detect_connection())