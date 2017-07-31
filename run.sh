#!/bin/sh
set -e

# make sure $HOME/.ssh exists
if [ ! -d "$HOME/.ssh" ]; then
  debug "$HOME/.ssh does not exists, creating it"
  mkdir -p "$HOME/.ssh"
fi

# Write to system wide file by default
root_ssh_path="/etc/ssh"
known_hosts_path="$root_ssh_path/ssh_known_hosts"

if [ "$WERCKER_ADD_TO_KNOWN_HOSTS_LOCAL" = "true" ]; then
  known_hosts_path="$HOME/.ssh/known_hosts"
else
  if [ ! -d "$root_ssh_path" ]; then
    fail "$root_ssh_path does not exist. Cause: ssh-client software probably not installed."
  fi
fi

if [ ! -f "$known_hosts_path" ]; then
  debug "$known_hosts_path does not exists, touching it and chmod it to 644"
  sudo touch "$known_hosts_path"
  sudo chmod 644 "$known_hosts_path"
fi

# validate <hostname> exists
if [ ! -n "$WERCKER_ADD_TO_KNOWN_HOSTS_HOSTNAME" ]
then
  fail "missing or empty hostname, please check your wercker.yml"
fi

if [ -n "$WERCKER_ADD_TO_KNOWN_HOSTS_TYPE" ]; then
  types="$WERCKER_ADD_TO_KNOWN_HOSTS_TYPE"
else
  types="rsa,dsa,ecdsa"
fi

# Check if ssh-keyscan command exists
set +e
hash ssh-keyscan 2>/dev/null
result=$?
set -e

if [ $result -ne 0 ] ; then
  fail "ssh-keyscan command not found. Cause: ssh-client software probably not installed."
fi

ssh_keyscan_command="ssh-keyscan -t $types"


if [ ! -n "$WERCKER_ADD_TO_KNOWN_HOSTS_PORT" ] ; then
    ssh_keyscan_command="$ssh_keyscan_command $WERCKER_ADD_TO_KNOWN_HOSTS_HOSTNAME"
  else
    ssh_keyscan_command="$ssh_keyscan_command -p $WERCKER_ADD_TO_KNOWN_HOSTS_PORT $WERCKER_ADD_TO_KNOWN_HOSTS_HOSTNAME"
fi

ssh_keyscan_result=$(mktemp)

$ssh_keyscan_command > "$ssh_keyscan_result"


if [ ! -n "$WERCKER_ADD_TO_KNOWN_HOSTS_FINGERPRINT" ] ; then
  # shellcheck disable=SC2002
  cat "$ssh_keyscan_result" | sudo tee -a "$known_hosts_path"
  warn "Skipped checking public key with fingerprint, this setup is vulnerable to a man in the middle attack"
  success "Successfully added host $WERCKER_ADD_TO_KNOWN_HOSTS_HOSTNAME to known_hosts"

else

  debug "Searching for keys that match fingerprint $WERCKER_ADD_TO_KNOWN_HOSTS_FINGERPRINT"
  # shellcheck disable=SC2162,SC2002
  cat "$ssh_keyscan_result" | sed "/^ *#/d;s/#.*//" | while read ssh_key; do
    ssh_key_path=$(mktemp)
    echo "$ssh_key" > "$ssh_key_path"

    if [ "$WERCKER_ADD_TO_KNOWN_HOSTS_USE_MD5" = "true" ]; then
        ssh_key_fingerprint=$(ssh-keygen -l -f "$ssh_key_path" -E md5 | awk '{print $2}')
    else
        ssh_key_fingerprint=$(ssh-keygen -l -f "$ssh_key_path" | awk '{print $2}')
    fi
    if echo "$ssh_key_fingerprint" | grep -q "$WERCKER_ADD_TO_KNOWN_HOSTS_FINGERPRINT" ; then
      debug "Added a key to $known_hosts_path"
      echo "$ssh_key" | sudo tee -a "$known_hosts_path"
    else
      warn "Skipped adding a key to known_hosts, it did not match the fingerprint ($ssh_key_fingerprint)"
    fi
    rm -f "$ssh_key_path"
  done

fi
