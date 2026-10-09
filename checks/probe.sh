#!/bin/sh
# /ping runs ping against the given address and shows its output.
curl -fsS --max-time 20 -d 'ip_address=127.0.0.1' http://web/ping | grep -q 'packets transmitted'
