import pandas as pd
import numpy as np

def validate_crash_data(file_path):
    # 1. Load Data
    df = pd.read_csv(file_path)
    
    # 2. BRUTE FORCE CLEANING (The Fix)
    # This removes all spaces and forces lowercase
    df.columns = [str(col).strip().lower() for col in df.columns]
    
    # Let's see what it found (Check your terminal for this list!)
    print(f"Cleaned Columns found: {df.columns.tolist()}")

    # 3. Convert all columns to numeric, removing rows with text
    df = df.apply(pd.to_numeric, errors='coerce').dropna()

    print(f"--- Dataset Validation Report ---")

    # 4. Check for acceleration columns using the cleaned names
    required = ['accx', 'accy', 'accz']
    if all(col in df.columns for col in required):
        # Math for Impact Force
        df['smv'] = np.sqrt(df['accx']**2 + df['accy']**2 + df['accz']**2)
        max_acc = df['smv'].max()
        z_mean = df['accz'].abs().mean()

        # Identify Scale
        unit = "m/s²" if z_mean > 5 else "G-force"
        print(f"[UNITS] Scale: {unit} (Mean Z: {z_mean:.2f})")
        print(f"[DETECTION] Max Impact: {max_acc:.2f} {unit}")

        # Golden Hour Trigger Logic
        threshold = 25 if unit == "m/s²" else 2.5
        if max_acc > threshold:
            print(f"⚠️ SUCCESS: Crash signature detected in dataset!")
        else:
            print("✅ Normal driving data processed.")
    else:
        print(f"❌ ERROR: Still missing columns. I only see: {df.columns.tolist()}")

    print("-" * 40)

validate_crash_data('road_accident_imu_dataset_8000.csv')