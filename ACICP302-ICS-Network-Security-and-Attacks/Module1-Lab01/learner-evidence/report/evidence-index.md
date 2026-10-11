# Evidence Index

Course source: https://github.com/icdfa/ACICP302ICS-Network-Security-and-Attacks · commit 2a66f9bcf253eb3fe31c68ad52794cd535421da8

| Ref | File | Supports |
|---|---|---|
| E00a | evidence/logs/00_source_hashes.txt | source integrity / clean state (Act 00) |
| E00b | evidence/screenshots/00_topology_dataflow.png | annotated topology (Act 01) |
| E01a | evidence/screenshots/01_baseline_direct_8080.png | direct baseline (Act 01) |
| E01b | evidence/screenshots/01_baseline_guarded_8081.png | guarded baseline (Act 01) |
| E03a | evidence/captures/03_normal_modbus_5020.pcap | learner PCAP, lo:5020 (Act 03) |
| E03b | evidence/screenshots/03_packet_reqresp_decode.png | annotated request/response (Act 03) |
| E03c | evidence/logs/03_reqresp_decode.txt, 03_packet_analysis.txt | raw tshark decode (Act 03) |
| E06-1 | evidence/logs/SV-01_recon_scan_{5020,5021}.out.txt | recon, both paths (Act 06) |
| E06-2 | evidence/logs/SV-02_attack_hold_{5020,5021}.out.txt | attack_hold (Act 06) |
| E06-2i | evidence/screenshots/SV-02_direct_alarm_midattack.png | direct HMI in alarm (Act 06) |
| E06-2ii | evidence/screenshots/SV-02_guarded_blocked_log.png | guard detection log (Act 05/06) |
| E06-3 | evidence/logs/SV-03_false_data_attack_{5020,5021}.out.txt | false data (Act 06) |
| E06-4 | evidence/logs/SV-04_slow_drift_attack_{5020,5021}.out.txt | slow drift (Act 06) |
| E06-4i | evidence/screenshots/SV-04_guarded_driftlog.png | guarded drift events (Act 06) |
| E06-5 | evidence/logs/SV-05_replay_attack_{5020,5021}.out.txt | replay (Act 06) |
| E05 | evidence/logs/events_full.jsonl | 114 guard events (Act 05) |
| E-svc | evidence/logs/svc_*.log | service console logs |
