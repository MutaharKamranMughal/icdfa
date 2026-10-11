# Supplied Guard (guard.py) — Decision Table and Limitations

Guard = Modbus write-through proxy on 127.0.0.1:5021 that validates each single-register write, forwards accepted writes to the plant (:5020), and drops rejected writes entirely (reject = no forward, no mirror update, not added to drift baseline). Rejections are appended to `events.jsonl`. Reads are NOT validated. Source: guard.py commit 2a66f9b.

## Checks applied to writes on HR0 (temp), HR1 (pressure), HR2 (flow)

| # | Check | Input | Condition to REJECT | Action on reject | Source |
|---|---|---|---|---|---|
| 1 | Absolute range | requested value | value < min or > max of the register's safe range | drop write, log event | guard.py _check lines 92–96 |
| 2 | Step size | requested vs current mirror value | abs(requested − current) > MAX_*_STEP (temp 3.0 °C=30, pres 5.0 bar=50, flow 10.0=100) | drop write, log event | guard.py _check lines 98–103 |
| 3 | Rolling-baseline drift | requested vs accepted value N=3 writes ago | abs(requested − history[0]) > DRIFT_THRESHOLD (temp 2.0, pres 2.0, flow 4.0) only when history is full (len==3) | drop write, log event | guard.py _check lines 105–112 |

A write is accepted only if ALL applicable checks pass; on accept it is forwarded, mirrored, and appended to that register's accepted-history deque (maxlen 3). Writes to HR3+ are passed through UNVALIDATED (guard.py lines 135–143).

## Event record
Each rejection → one JSON line `{"timestamp","reason"}` in events.jsonl. Reason concatenates every failed check. Observed in this run: 114 events total — 106 fired range+step+drift, 4 range-only, 4 range+drift.

## Demonstrated limitations (evidence-backed)
1. **Direct-path bypass.** The guard only sees traffic sent to :5021. Port :5020 reaches the plant with no validation. SV-02/03/04 direct runs drove unsafe values straight into the plant (events=0 on direct every time).
2. **Reads unprotected.** recon_scan (SV-01) returned identical register data through :5020 and :5021; the guard logs/blocks nothing on reads. No confidentiality control.
3. **Slow in-range drift evades the drift check.** From a 32.9 bar baseline, slow_drift steps 1–7 (requested up to 39.9 bar) were ACCEPTED through the guard — each 1.0 bar step is under the 5.0 bar step limit and inside the absolute range, and the drift check did not fire. The attacker raised pressure ~7 bar through the guard before the absolute-range check stopped writes at 40.9 bar (SV-04 guarded). Root cause: the `sync_safe_reads` thread appends the live plant value to the same accepted-history deque every second (guard.py lines 192–194), so the rolling baseline is never older than ~3 s and a slow ramp stays under threshold.
4. **No authentication / no anti-replay.** replay_attack (SV-05) resent a valid-looking write 3× and was ACCEPTED on both paths (events=0). Modbus/TCP has no auth, session or sequence number; the guard adds none.
5. **Single-register validation only.** Only values[0] of each write is checked (guard.py line 117); multi-register writes past the first are not validated. Checks are per-register with no correlation between temp/pressure/flow.
6. **Availability not addressed.** The guard has no rate limiting; a flood (dos_attack, not run — not approved) would not be mitigated.
