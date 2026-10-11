#!/bin/bash
# Runs ONE supplied script, unchanged, against ONE port; records output, events delta, dashboard state.
# Usage: run_scenario.sh <SVID> <script> <port> <label>
SVID=$1; SCRIPT=$2; PORT=$3; LABEL=$4
SRC=/home/claude/icdfa/acicp302ics-network-security-and-attacks/labs/ot-security/student-lab-source
EV=/home/claude/learner-evidence/evidence
LOG=$EV/logs; CAP=$EV/captures
cd "$SRC"; source .venv/bin/activate >/dev/null 2>&1; cd plant_sim
OUT="$LOG/${SVID}_${SCRIPT%.py}_${PORT}.out.txt"
EVENTS=plant_sim_events_marker
BEFORE=$((test -f events.jsonl && wc -l < events.jsonl) || echo 0)
echo "### $SVID  $SCRIPT $PORT  ($LABEL)  path=$([ $PORT = 5020 ] && echo DIRECT || echo GUARDED)" > "$OUT"
echo "### $(TZ=Africa/Lagos date '+%Y-%m-%d %H:%M:%S WAT')" >> "$OUT"
echo "--- state BEFORE: $(curl -s http://127.0.0.1:8080/api/state)" >> "$OUT"
# packet capture for this run on the target port
nohup tcpdump -i lo -w "$CAP/${SVID}_${SCRIPT%.py}_${PORT}.pcap" "tcp port $PORT" >/dev/null 2>&1 &
TD=$!; sleep 1
echo "--- SCRIPT OUTPUT (supplied, unchanged: python3 $SCRIPT $PORT) ---" >> "$OUT"
python3 "$SCRIPT" "$PORT" >> "$OUT" 2>&1
sleep 1; kill $TD 2>/dev/null
echo "--- state AFTER (immediately): direct=$(curl -s http://127.0.0.1:8080/api/state) guarded=$(curl -s http://127.0.0.1:8081/api/state)" >> "$OUT"
sleep 3
echo "--- state +3s (recovery): direct=$(curl -s http://127.0.0.1:8080/api/state) guarded=$(curl -s http://127.0.0.1:8081/api/state)" >> "$OUT"
AFTER=$((test -f events.jsonl && wc -l < events.jsonl) || echo 0)
NEW=$((AFTER-BEFORE))
echo "--- guard events appended by this run: $NEW" >> "$OUT"
if [ "$NEW" -gt 0 ]; then tail -n "$NEW" events.jsonl >> "$OUT"; fi
cat "$OUT"
