#!/bin/bash
# RPCN P2P Match-making Server Startup Script
#
# Server Files: /home/rpcn

export LD_LIBRARY_PATH=$HOME/lib:$LD_LIBRARY_PATH

clear

trim_str() {
  local s="$1"
  s=${s##+([[:space:]])}
  s=${s%%+([[:space:]])}
  echo "$s"
}

set_config_value() {
  local config_file="$1"
  local key="$2"
  local new_val="$3"

  while IFS='=' read -r c_key c_value || [ -n "$c_key" ]; do
    c_key=$(trim_str "$c_key")

    if [ -z "$c_key" ] || [ "${c_key:0:1}" = "#" ]; then
      continue
    fi

    if [ "$c_key" = "$key" ]; then
      sed -i.bak "s/^$c_key=.*/$c_key=$new_val/" "$config_file"
      echo "Updated config: '$key'."
      return 0
    fi
    done < "$config_file"
    return 1
}

update_config_file() {
  local c_file="$HOME/rpcn.cfg"

  if [ ! -f "$c_file" ]; then
    echo "ERROR: Configuration file '$c_file' not found!"
    exit 1
  fi

  declare -A c_data

  while IFS='=' read -r c_key c_val || [ -n "$c_key" ]; do
    c_key=$(trim_str "$c_key")

    if [ -z "$c_key" ] || [ "${c_key:0:1}" = "#" ]; then
      continue 
    fi
    c_data["$c_key"]="$c_val"
  done < "$c_file"

  declare -A e_data=( \
    ["CreateMissing"]="${RPCN_CREATEMISSING}" \
    ["Verbosity"]="${RPCN_LOGVERBOSITY}" \
    ["Host"]="${RPCN_HOST}" \
    ["Port"]=${RPCN_PORT} \
    ["HostIPv6"]="${RPCN_HOSTV6}" \
    ["EmailValidated"]="${RPCN_EMAILVALIDATION}" \
    ["EmailHost"]="${RPCN_EMAILHOST}" \
    ["EmailLogin"]="${RPCN_EMAILLOGIN}" \
    ["EmailPassword"]="${RPCN_EMAILPASSWORD}" \
    ["SignTickets"]="${RPCN_SIGNTICKETS}" \
    ["SignTicketsDigest"]="${RPCN_SIGNTICKETSDIGEST}" \
    ["StatServer"]="${RPCN_ENABLESTATSERVER}" \
    ["StatServerHost"]="${RPCN_STATSERVERHOST}" \
    ["StatServerPort"]=${RPCN_STATSERVERPORT} \
    ["StatServerCacheLife"]=${RPCN_STATSERVERCACHELIFE} \
    ["AdminsList"]="${RPCN_ADMINLIST}" \
  )

  for key in "${!e_data[@]}"; do
      c_val="${c_data["$key"]}"
      e_val="${e_data["$key"]}"

      if [ "$c_val" != "$e_val" ]; then
        set_config_value "$c_file" "$key" "$e_val"
      fi
  done
}

print_header() {
  local pf="● %-21s %-25s\n"

  [ "${RPCN_CREATEMISSING,,}" = "true" ] && server_cm="Yes" || server_cm="No"
  [ "${RPCN_EMAILVALIDATION,,}" = "true" ] && server_ev="Yes" || server_ev="No"
  [ "${RPCN_SIGNTICKETS,,}" = "true" ] && server_st="Yes" || server_st="No"
  [ "${RPCN_ENABLESTATSERVER,,}" = "true" ] && server_ess="Yes" || server_ess="No"

  printf "\n"
  printf "░█▀▄░█▀█░█▀▀░█▀█\n"
  printf "░█▀▄░█▀▀░█░░░█░█\n"
  printf "░▀░▀░▀░░░▀▀▀░▀░▀\n"
  printf "\n"
  printf "$pf" "Host:" "${RPCN_HOST}"
  printf "$pf" "Port:" "${RPCN_PORT}"
  printf "$pf" "Host (IPv6):" "${RPCN_HOSTV6}"
  printf "$pf" "Create Missing Serv.:" "${server_cm}"
  printf "$pf" "Log Verbosity:" "${RPCN_LOGVERBOSITY}"
  printf "$pf" "Email Validation:" "${server_ev}"
  if [ $server_ev = "Yes" ]; then
    printf "$pf" "Email Host:" "${RPCN_EMAILHOST}"
    printf "$pf" "Email Login:" "${RPCN_EMAILLOGIN}"
    printf "$pf" "Email Password:" "(hidden)"
  fi
  printf "$pf" "Signed Tickets:" "${server_st}"
  if [ $server_st = "Yes" ]; then
    printf "$pf" "Tickets Digest:" "${RPCN_SIGNTICKETSDIGEST}"
  fi
  printf "$pf" "Stat Server Enabled:" "${server_ess}"
  if [ $server_ess = "Yes" ]; then
    printf "$pf" "S. Server Host:" "${RPCN_STATSERVERHOST}"
    printf "$pf" "S. Server Port:" "${RPCN_STATSERVERPORT}"
    printf "$pf" "S. Server Cache Life:" "${RPCN_STATSERVERCACHELIFE}"
  fi
  if [[ -n "$RPCN_ADMINLIST" ]]; then
    local server_al="${RPCN_ADMINLIST//,/\, }"
    printf "$pf" "Admin List:" "${server_al}"
  fi
  printf "\n"
}

print_header
update_config_file && $HOME/rpcn