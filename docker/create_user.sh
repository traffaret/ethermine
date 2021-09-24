#!/usr/bin/env ash

USER_ID=1000
USER_NAME=appuser
HOME_DIR=/home/${USER_NAME}

verbose=false

if [[ $# == 0 ]]; then
  printf "\nUsage: ./create_user.sh [OPTIONS]\n\n"
  printf "Create user for the docker containers\n\n"
  printf "Options:\n"
  printf "\t--id\t\t User identity\n"
  printf "\t--name\t\t User name\n"
  printf "\t--home\t\t Home directory\n"
  printf "\t--verbose\t Verbose output"
  return 0
fi

while [ $# -gt 0 ]; do
  if [[ $1 == *"--verbose"* ]]; then
    verbose=true
    shift
    continue
  fi

  if [[ $1 == *"--id"* ]]; then
    USER_ID="${2/--/}"
    shift
    continue
  fi

  if [[ $1 == *"--name"* ]]; then
    USER_NAME="${2/--/}"
    shift
    continue
  fi

  if [[ $1 == *"--home"* ]]; then
      HOME_DIR="${2/--/}"
      shift
      continue
    fi

  shift
done

if [[ ${verbose} == true ]]; then
  printf "[INFO] User: ${USER_NAME}:${USER_ID}\n"
fi

if id -u "${USER_ID}" &>/dev/null; then
  printf "User with ID \"${USER_ID}\" already exists\n"
  return 1
fi

if id -u "${USER_NAME}" &>/dev/null; then
  printf "User with name \"${USER_NAME}\" already exists\n"
  return 1
fi

if [[ ${verbose} == true ]]; then
  printf "[INFO] Create group: ${USER_NAME}:${USER_ID}\n"
fi

addgroup --gid ${USER_ID} ${USER_NAME}

if [[ ${verbose} == true ]]; then
  printf "[INFO] Create user: ${USER_NAME}:${USER_ID}\n"
fi

mkdir -p "${HOME_DIR}"
addgroup -g "${USER_ID}" "${USER_NAME}"
adduser -D -u "${USER_ID}" -h "${HOME_DIR}" -G "${USER_NAME}" "${USER_NAME}"
chown -R "${USER_NAME}:${USER_NAME}" "${HOME_DIR}"

