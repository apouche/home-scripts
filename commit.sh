#! /bin/bash
SCRIPT_PATH="$PWD/`dirname $0`"

cd ${SCRIPT_PATH}
res=`git status|grep "nothing to commit"`
if [[ "$res" == "" ]]; then
	git add -A
	git commit -a -m "modifications made"
	git push
fi
