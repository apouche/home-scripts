#! /bin/bash
SCRIPT_PATH="$PWD/`dirname $0`"
SCRIPT_FILES=`find ${SCRIPT_PATH} ! \( -regex ".*/\.git.*" \) -type f |grep -oP "[^/]+$"|tr '\n' ' '`

for file in ${SCRIPT_FILES}
do
	res=`find  ~ -name "${file}" -maxdepth 1`
	if [[ "$res" != "" ]]; then
		echo "backing up $res into ${res}.mine"
		mv "$res" "${res}.mine"
	fi
	ln -s "${SCRIPT_PATH}/$file" ~/$file
done
