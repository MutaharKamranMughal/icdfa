# Controlled Validation Test Plan — Supplied Simulation (loopback only)

Learner: Mutahar Kamran Mughal (C11/26/ACIS/17375). Course source commit 2a66f9b. Target: 127.0.0.1 only.
All scripts run with supplied parameters unchanged, one at a time, direct path :5020 then guarded path :5021. Recovery verified after each. dos_attack.py NOT run (requires explicit instructor approval; availability demo out of approved scope).

Each scenario carries a real-world parallel for context only; the lab result is the loopback evidence, kept separate from the parallel.

| ID | Script (unchanged) | Relevant guard check | Expected (direct / guarded) | Real-world parallel |
|---|---|---|---|---|
| SV-01 | recon_scan.py {5020,5021} | none (reads) | both: full register read, no block | ICS recon (Havex/Dragonfly OPC mapping; PIPEDREAM Modbus module) |
| SV-02 | attack_hold.py {5020,5021} | range + step + drift | direct: 95 bar reaches plant / guarded: blocked | FrostyGoop 2024 — plain Modbus writes to heating controllers, Lviv |
| SV-03 | false_data_attack.py {5020,5021} | range + step + drift, all 3 regs | direct: 110°C/55bar/200 reach plant / guarded: blocked | Stuxnet-style false process values / grid false-data injection |
| SV-04 | slow_drift_attack.py {5020,5021} | rolling-baseline drift | direct: ramp reaches ceiling / guarded: drift should catch | Low-and-slow setpoint manipulation (Stuxnet subtle changes) |
| SV-05 | replay_attack.py {5020,5021} | (none effective) | both: replayed valid write | Replay of captured valid command (no Modbus auth/seq) |

## Expected-versus-observed comparison

| ID | Path | Observed result | Guard events | Recovery |
|---|---|---|---|---|
| SV-01 | :5020 | regs 0-49 read; HR0-2 live, HR4-49 = 0 | 0 | state unchanged |
| SV-01 | :5021 | identical read through guard | 0 | state unchanged |
| SV-02 | :5020 | 79 writes, peak 95.0 bar, 100% unsafe — "UNSAFE VALUE REACHED THE PLANT"; HMI alarm | 0 | self-healed to safe range, alarm cleared |
| SV-02 | :5021 | peak 40.0 bar, 0% unsafe — "attack fully contained" | 79 (range+step+drift) | contained; plant self-healed |
| SV-03 | :5020 | 110.0°C / 55.0 bar / 200.0 Nm³/h, 6/6 unsafe each — reached plant | 0 | self-healed, alarm cleared |
| SV-03 | :5021 | 0/6 unsafe on all three — "attack fully contained" | 18 (6 batches × 3 regs) | contained |
| SV-04 | :5020 | ramp accepted, pressure driven to range ceiling (~40 bar), alarm | 0 | self-healed |
| SV-04 | :5021 | FROM CLEAN 32.9 bar: steps 1–7 (≤39.9 bar) ACCEPTED; blocking began step 8 (40.9 bar) by range; drift appeared only as secondary reason | 5 | contained at ceiling, but slow in-range climb NOT detected — see limitation #3 |
| SV-05 | :5020 | replayed +0.5 bar ×3, accepted | 0 | returned to normal |
| SV-05 | :5021 | replayed write ×3 accepted — guard cannot distinguish replay from valid write | 0 | returned to normal |

## Stop condition / recovery
Stop immediately if any target/bind ≠ 127.0.0.1 or the VM behaves unexpectedly. Recovery after each scenario = confirm services healthy and process values return to the safe range (plant self-heals via its clamped random walk); between scenarios services were restarted to the initial baseline (snapshot-restore substitute — see Scope & Safety).
