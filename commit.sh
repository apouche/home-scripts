#! /bin/bash
SCRIPT_PATH="$PWD/`dirname $0`"
SCRIPT_LOGFILE="${SCRIPT_PATH}/git.log"

cd ${SCRIPT_PATH}
res=`git status|grep "nothing to commit"`
if [[ "$res" == "" ]]; then
	git add -A 2>&1 >>${SCRIPT_LOGFILE}
	git commit -a -m "modifications made" 2>&1 >>${SCRIPT_LOGFILE}
	git push 2>&1 >>${SCRIPT_LOGFILE}
fi
