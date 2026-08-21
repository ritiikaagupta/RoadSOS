"""RoadSOS prototype PC bridge + dashboard.

Architecture during the no-LoRa-module phase:
TX FPGA --UART--> PC --UART--> RX FPGA --UART/status--> PC dashboard

Install: python -m pip install pyserial
Run example on Windows:
    python pc_bridge_dashboard.py --tx COM7 --rx COM8

The program forwards the raw 8-byte SAFE-Link frame and also displays the
latest decoded event. The RX FPGA remains the authority for CRC validation.
"""
import argparse
import queue
import threading
import time
import tkinter as tk
from tkinter import ttk
import serial

SOF = 0xA5
EOF_MARK = 0x5A
NEWLINE = 0x0A
EVENT_NAMES = {1: "Sudden braking", 2: "Accident", 3: "Vehicle breakdown", 4: "Road hazard"}

def crc16_ccitt(data: bytes) -> int:
    crc = 0xFFFF
    for b in data:
        crc ^= b << 8
        for _ in range(8):
            crc = ((crc << 1) ^ 0x1021) & 0xFFFF if (crc & 0x8000) else (crc << 1) & 0xFFFF
    return crc

def parse_frame(frame: bytes):
    if len(frame) != 8 or frame[0] != SOF or frame[6] != EOF_MARK:
        return None
    payload = frame[:4]
    rx_crc = (frame[4] << 8) | frame[5]
    calc = crc16_ccitt(payload)
    if rx_crc != calc:
        return {"valid": False, "raw": frame.hex(" ").upper(), "crc": f"0x{rx_crc:04X}", "calc": f"0x{calc:04X}"}
    return {"valid": True, "raw": frame.hex(" ").upper(), "event": frame[1], "vehicle": (frame[2] << 8) | frame[3], "crc": f"0x{rx_crc:04X}"}

class Bridge:
    def __init__(self, tx_port, rx_port, baud, outq):
        self.tx_port, self.rx_port, self.baud, self.outq = tx_port, rx_port, baud, outq
        self.stop = threading.Event()
        self.tx = None
        self.rx = None
    def start(self):
        self.tx = serial.Serial(self.tx_port, self.baud, timeout=0.1)
        self.rx = serial.Serial(self.rx_port, self.baud, timeout=0.1)
        threading.Thread(target=self.worker, daemon=True).start()
        self.outq.put(("status", f"Bridge running: {self.tx_port} -> {self.rx_port}"))
    def worker(self):
        buf = bytearray()
        while not self.stop.is_set():
            b = self.tx.read(1)
            if not b:
                continue
            buf += b
            # Fixed-length prototype frame. Resync if A5 is found later in the buffer.
            while buf and buf[0] != SOF:
                del buf[0]
            if len(buf) >= 8:
                frame = bytes(buf[:8])
                del buf[:8]
                self.rx.write(frame)
                self.outq.put(("frame", parse_frame(frame)))
    def close(self):
        self.stop.set()
        for s in (self.tx, self.rx):
            if s:
                try: s.close()
                except serial.SerialException: pass

class Dashboard(tk.Tk):
    def __init__(self, bridge, outq):
        super().__init__()
        self.bridge, self.outq = bridge, outq
        self.title("RoadSOS — SAFE-Link Prototype")
        self.geometry("720x430")
        self.protocol("WM_DELETE_WINDOW", self.close_all)
        self.status = tk.StringVar(value="Waiting for TX FPGA...")
        self.event = tk.StringVar(value="—")
        self.vehicle = tk.StringVar(value="—")
        self.crc = tk.StringVar(value="—")
        self.raw = tk.StringVar(value="—")
        self.build()
        self.after(100, self.poll)
    def build(self):
        ttk.Label(self, text="RoadSOS", font=("Segoe UI", 24, "bold")).pack(pady=(18,2))
        ttk.Label(self, text="SAFE-Link FPGA → PC → FPGA prototype", font=("Segoe UI", 11)).pack()
        box = ttk.Frame(self, padding=18); box.pack(fill="x")
        for r,(label,var) in enumerate((("Event",self.event),("Vehicle ID",self.vehicle),("CRC",self.crc),("Raw frame",self.raw))):
            ttk.Label(box,text=label+":",font=("Segoe UI",11,"bold")).grid(row=r,column=0,sticky="w",padx=8,pady=7)
            ttk.Label(box,textvariable=var,font=("Consolas",11)).grid(row=r,column=1,sticky="w",padx=8,pady=7)
        self.alert = ttk.Label(self,textvariable=self.status,font=("Segoe UI",15,"bold")); self.alert.pack(pady=22)
        ttk.Label(self,text="Prototype path: no RF/LoRa module is used in this demonstration.").pack(pady=4)
    def poll(self):
        try:
            while True:
                kind,data=self.outq.get_nowait()
                if kind=="status": self.status.set(data)
                elif kind=="frame":
                    if data and data.get("valid"):
                        self.event.set(f"0x{data['event']:02X} — {EVENT_NAMES.get(data['event'],'Unknown event')}")
                        self.vehicle.set(f"0x{data['vehicle']:04X} ({data['vehicle']})")
                        self.crc.set(data['crc']+" PASS")
                        self.raw.set(data['raw'])
                        self.status.set("EMERGENCY PACKET RECEIVED — CRC PASS")
                    else:
                        self.crc.set(f"received {data.get('crc')} / calculated {data.get('calc')}")
                        self.raw.set(data.get('raw','—'))
                        self.status.set("FRAME RECEIVED — CRC FAIL")
        except queue.Empty: pass
        self.after(100,self.poll)
    def close_all(self):
        self.bridge.close(); self.destroy()

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--tx",required=True,help="COM port connected to TX FPGA")
    ap.add_argument("--rx",required=True,help="COM port connected to RX FPGA")
    ap.add_argument("--baud",type=int,default=115200)
    a=ap.parse_args()
    q=queue.Queue(); bridge=Bridge(a.tx,a.rx,a.baud,q); bridge.start(); Dashboard(bridge,q).mainloop()

if __name__ == "__main__":
    main()
