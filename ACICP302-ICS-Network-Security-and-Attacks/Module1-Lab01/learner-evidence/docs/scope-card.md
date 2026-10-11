# Activity 04 — Scope Card (approved observation boundary)

| Field | Value |
|---|---|
| Assigned VM | Claude isolated Ubuntu 24.04 LTS sandbox (instructor-approved substitute for VirtualBox/VMware guest) |
| Authorized target | 127.0.0.1 only (loopback) |
| Loopback services in scope | plant :5020, guard :5021, dashboards :8080/:8081 |
| Permitted method | source inspection + guide-approved read-only checks + supplied demo scripts with unchanged params |
| Time window | single lab session, 2026-10-11 ~18:39–18:52 WAT |
| Expected state | values in safe range, alarm clear, both dashboards "Live" |
| Stop condition | any non-loopback target/bind, VM instability, unexpected result |
| Recovery action | stop demo, let plant self-heal / restart services to baseline, confirm safe range |

## Local service inventory (source-confirmed, loopback only)
| Endpoint | Component | Protocol | Process significance | Consequence if misused |
|---|---|---|---|---|
| 127.0.0.1:5020 | plant.py | Modbus/TCP | authoritative process + direct control path | unvalidated writes → unsafe process state |
| 127.0.0.1:5021 | guard.py | Modbus/TCP | validated control path | only partial protection (see guard limitations) |
| 127.0.0.1:8080 | dashboard.py | HTTP | direct monitoring view | shows true (possibly attacked) state |
| 127.0.0.1:8081 | dashboard_guarded.py | HTTP | guarded view + event log | may show stale-but-safe mirror during a direct attack |

No non-loopback endpoint was found (grep for 192.168.2.139 / 0.0.0.0 returned none; 13 occurrences of 127.0.0.1).
