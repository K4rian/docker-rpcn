#!/bin/ash
# RPCN P2P Match-making Server Startup Script
#
# Server Files: /home/rpcn

export LD_LIBRARY_PATH=$HOME/lib:$LD_LIBRARY_PATH

clear

RPCN_CONFFILE="$HOME/rpcn.cfg"

if [ ! -f "$RPCN_CONFFILE" ]; then
  printf "%s=%s\n%s=%s\n%s=%s\n%s=%i\n%s=%s\n%s=%s\n%s=%s\n%s=%s\n%s=%s\n%s=%s\n%s=%s\n%s=%s\n%s=%i" \
  "CreateMissing" "${RPCN_CREATEMISSING}" \
  "Verbosity" "${RPCN_LOGVERBOSITY}" \
  "Host" "${RPCN_HOST}" \
  "Port" ${RPCN_PORT} \
  "EmailValidated" "${RPCN_EMAILVALIDATION}" \
  "EmailHost" "${RPCN_EMAILHOST}" \
  "EmailLogin" "${RPCN_EMAILLOGIN}" \
  "EmailPassword" "${RPCN_EMAILPASSWORD}" \
  "SignTickets" "${RPCN_SIGNTICKETS}" \
  "SignTicketsDigest" "${RPCN_SIGNTICKETSDIGEST}" \
  "StatServer" "${RPCN_ENABLESTATSERVER}" \
  "StatServerHost" "${RPCN_STATSERVERHOST}" \
  "StatServerPort" ${RPCN_STATSERVERPORT} \
  >$RPCN_CONFFILE
fi

echo "░█▀▄░█▀█░█▀▀░█▀█"
echo "░█▀▄░█▀▀░█░░░█░█"
echo "░▀░▀░▀░░░▀▀▀░▀░▀"

$HOME/rpcn
