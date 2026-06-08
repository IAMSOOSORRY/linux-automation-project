#!/bin/bash

REPORT=logs/report_$(date +%F).txt

{
echo "===== SYSTEM REPORT ====="

echo "Date:"
date

echo ""

echo "CPU Load:"
uptime

echo ""

echo "Memory Usage:"
free -h

echo ""

echo "Disk Usage:"
df -h

} > $REPORT

echo "Report saved successfully in $REPORT"
