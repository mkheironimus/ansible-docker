#! /bin/bash

umask 022
export PATH=/usr/bin

_check() {
	local rc="$1" out="$2"
	if [ ${rc} -ne 0 ] ; then
		echo "${out}" 1>&2
		exit ${rc}
	fi
}

DANGLING=$(docker image ls -f'dangling=true' -q --no-trunc 2>&1)
_check $? "${DANGLING}"
if [ -n "${DANGLING}" ] ; then
	RM=$(docker image rm ${DANGLING} 2>&1)
	_check $? "${RM}"
fi

PRUNE=$(docker builder prune 2>&1)
_check $? "${PRUNE}"

exit 0
