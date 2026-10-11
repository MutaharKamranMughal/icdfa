# ACICP302ICS Evidence Log

**Learner/Team:** Mutahar Kamran Mughal
**Registration number(s):** C11/26/ACIS/17375
**Activity:** 00–08 (integrated source-code-guided practical)
**Date and WAT time:** 2026-10-11, 18:39–18:52 WAT
**Assigned Ubuntu VM / snapshot:** Claude isolated Ubuntu 24.04.5 LTS sandbox (instructor-approved VM substitute); clean state = fresh clone + recorded source SHA-256 hashes (00_source_hashes.txt)
**Canonical source path:** `labs/ot-security/student-lab-source/`
**Course source commit:** 2a66f9bcf253eb3fe31c68ad52794cd535421da8
**Authorized loopback scope:** 127.0.0.1 only

| Time (WAT) | Starting state | Authorized action / supplied script | Observation/result | Evidence reference | Analysis/conclusion | Stop/recovery |
|---|---|---|---|---|---|---|
| 18:39 | fresh clone | git rev-parse HEAD; loopback greps | commit recorded; no 192.168.2.139/0.0.0.0; 127.0.0.1 present | 00_source_hashes.txt; preflight | safe source confirmed | n/a |
| 18:40 | services down | start plant,guard,dashboards (guide order) | 4 loopback listeners; baseline 67.7°C/33.2bar/91.0 | 01_baseline_direct_8080.png, 01_baseline_guarded_8081.png | normal baseline established | n/a |
| 18:41 | normal | one authorized read HR0-3 + lo capture :5020 | TID1 FC3 addr0 qty4 → [674,326,880,0] | 03_normal_modbus_5020.pcap, 03_packet_reqresp_decode.png | packet ↔ register map ↔ dashboard | capture stopped |
| 18:43 | normal | SV-01 recon_scan 5020 then 5021 | identical reads, no block | SV-01_*_out.txt | guard does not filter reads | state unchanged |
| 18:43 | normal | SV-02 attack_hold 5020 then 5021 | direct: 95 bar reached plant; guarded: contained, 79 blocks | SV-02_*_out.txt, SV-02_direct_alarm_midattack.png, SV-02_guarded_blocked_log.png | guard blocks range+step+drift; direct bypass unsafe | self-heal, alarm cleared |
| 18:46 | baseline | SV-03 false_data 5020 then 5021 | direct: 110°C/55bar/200 reached; guarded: 18 blocks | SV-03_*_out.txt | all 3 registers validated by guard | self-heal |
| 18:47-18:49 | baseline 32.9bar | SV-04 slow_drift 5020 then 5021 | direct: ramp to ceiling; guarded: steps 1-7 accepted, blocked at 40.9 bar by range | SV-04_*_out.txt, SV-04_guarded_driftlog.png | slow in-range drift evades drift check | self-heal |
| 18:51 | baseline | SV-05 replay 5020 then 5021 | accepted both paths, 0 events | SV-05_*_out.txt | no anti-replay/auth | returned normal |
| 18:52 | services up | stop all; port check | 5020/5021/8080/8081 all closed; no procs | cleanup output; events_full.jsonl (114) | clean recovery verified | complete |

## Safety declaration

I confirm that this evidence was gathered only in the assigned ICDFA isolated Ubuntu simulation using the canonical student source, that no real or external system was targeted (loopback 127.0.0.1 only; no bridged adapter/port-forwarding present), and that the stated stop and recovery actions were completed. The course-provided source is attributed and is not represented as learner-authored code.

**Learner signature:** ___________________________    **Date:** ______________
