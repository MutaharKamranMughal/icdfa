# ACICP302ICS — Module 1 Practical: Learner Evidence Repository

**Course:** ACICP302ICS — Network Security & Attacks
**Activity:** Analyze, Test & Defend the Supplied Modbus/TCP OT Simulation (Activities 00–08)
**Learner:** Mutahar Kamran Mughal — C11/26/ACIS/17375
**Course source:** https://github.com/icdfa/ACICP302ICS-Network-Security-and-Attacks
**Course source commit used:** 2a66f9bcf253eb3fe31c68ad52794cd535421da8
**Date:** 2026-10-11 (WAT)
**Evidence repository:** https://github.com/MutaharKamranMughal/icdfa (private), branch `main`, folder `ACICP302-ICS-Network-Security-and-Attacks/Module1-Lab01/learner-evidence/`

This repository contains the learner's own analysis, captures, logs, screenshots and report for the source-code-guided OT practical. The course simulation source is used under instructor authorization and attributed; it is **not** claimed as learner-authored code. All work was performed on loopback (127.0.0.1) only, inside an instructor-approved isolated Ubuntu sandbox.

## Layout
- `docs/` — topology/data-flow, register map, guard decision table, scope card, risk register, test plan
- `evidence/screenshots/` — topology, baselines, packet decode, scenario dashboards
- `evidence/captures/` — learner PCAPs (loopback Modbus/TCP)
- `evidence/logs/` — scenario outputs, packet decodes, guard event log, source hashes, service logs
- `evidence-log.md` — chronological evidence log + safety declaration
- `report/` — final report + evidence index

## Environment note (honesty)
A nested VirtualBox/VMware guest could not run inside the sandbox, so the sandbox itself served as the assigned isolated Ubuntu VM with instructor approval. Differences from the guide are labelled in the report §2: no VM snapshot (clean state = fresh clone + source hashes); no network adapter to disconnect (sandbox has only a filtered package proxy, all lab services bound to 127.0.0.1); Wireshark captures performed with tcpdump/tshark (Wireshark CLI).
