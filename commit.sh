#! /bin/bash
SCRIPT_PATH="$PWD/`dirname $0`"
SCRIPT_LOGFILE="${SCRIPT_PATH}/git.log"

cd ${SCRIPT_PATH}
res=`git status|grep "nothing to commit"`
if [[ "$res" == "" ]]; then
	echo "---------------------------------------"  >>${SCRIPT_LOGFILE} 2>&1
	echo "-- `date '+%y%m%d.%H%M%S'`"  >>${SCRIPT_LOGFILE} 2>&1
	git add -A >>${SCRIPT_LOGFILE} 2>&1
	git commit -a -m "modifications made" >>${SCRIPT_LOGFILE} 2>&1
	git push 2>&1 >>${SCRIPT_LOGFILE}
	echo "---------------------------------------"   >>${SCRIPT_LOGFILE} 2>&1
	echo ""
fi
