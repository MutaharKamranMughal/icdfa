#!/bin/bash
# Restart plant+guard+dashboards to baseline (snapshot-restore substitute). Kills only python service PIDs, never this shell.
SRC=/home/claude/icdfa/acicp302ics-network-security-and-attacks/labs/ot-security/student-lab-source
LOG=/home/claude/learner-evidence/evidence/logs
for pid in $(pgrep -f 'python3 (plant|guard|dashboard|dashboard_guarded)\.py'); do kill "$pid" 2>/dev/null; done
sleep 2
cd "$SRC"; source .venv/bin/activate >/dev/null 2>&1; cd plant_sim
nohup python3 plant.py            >>"$LOG/svc_plant.log"     2>&1 & sleep 3
nohup python3 guard.py            >>"$LOG/svc_guard.log"     2>&1 & sleep 3
nohup python3 dashboard.py        >>"$LOG/svc_dashboard.log" 2>&1 & sleep 2
nohup python3 dashboard_guarded.py>>"$LOG/svc_guarded.log"   2>&1 & sleep 4
echo "baseline: direct=$(curl -s http://127.0.0.1:8080/api/state) guarded=$(curl -s http://127.0.0.1:8081/api/state)"
