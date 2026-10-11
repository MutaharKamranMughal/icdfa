# Verified Modbus/TCP Data-Point Map — Supplied Simulation

Source: `labs/ot-security/student-lab-source/plant_sim/plant.py`, `guard.py`. Commit 2a66f9b.
All process values are stored as 16-bit holding registers in **tenths of the engineering unit** (integer × 10).

| Data point | Register (addr) | Type/scale | Unit | Normal range (source) | Alarm / unsafe meaning | Source reference |
|---|---|---|---|---|---|---|
| Electrolyzer temperature | HR0 | UINT16, ÷10 | °C | 60.0–75.0 (600–750) | guard rejects writes outside range; step >3.0 °C or drift >2.0 °C/3 writes | plant.py TEMP_RANGE; guard.py MAX_TEMP_STEP=30, DRIFT_THRESHOLD_TEMP=20 |
| Tank pressure | HR1 | UINT16, ÷10 | bar | 30.0–40.0 (300–400) | plant sets HR3 alarm when pressure ≥ 39.5 bar (PRESSURE_RANGE[1]−5); guard step >5.0 bar, drift >2.0 bar/3 | plant.py PRESSURE_RANGE, alarm rule line 79; guard.py MAX_PRESSURE_STEP=50, DRIFT_THRESHOLD_PRESSURE=20 |
| H2 flow rate | HR2 | UINT16, ÷10 | Nm³/h | 50.0–150.0 (500–1500) | guard step >10.0, drift >4.0/3 writes | plant.py FLOW_RANGE; guard.py MAX_FLOW_STEP=100, DRIFT_THRESHOLD_FLOW=40 |
| Alarm flag | HR3 | UINT16 | boolean | 0 (normal) | 1 = pressure at/above 39.5 bar | plant.py simulate_normal_operation line 79 |
| HR4–HR99 | 4–99 | UINT16 | — | 0 (unused) | not written by the simulation; read back as 0 | plant.py initial_values + [0]*96 |

**Scale confirmed by capture:** read of HR0–HR3 returned [674, 326, 880, 0] = 67.4 °C, 32.6 bar, 88.0 Nm³/h, alarm clear (03_reqresp_decode.txt).

**Source/display mismatch (finding):** the browser dashboards compute their own alarm thresholds that do NOT match plant/guard ranges — direct `dashboard.py` flags alarm at pres>40 or <28, temp>76 or <57, flow>156 or <44; `dashboard_guarded.py` flags on pressure only (>40 or <28). The authoritative process ranges are those in plant.py/guard.py above. The dashboards also derive their own tank-fill/colour and do not read HR3 for the alarm banner.
