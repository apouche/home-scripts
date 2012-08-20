#! /bin/bash
SCRIPT_PATH="$PWD/`dirname $0`"
GLOBAL_FILES_NAME="files"
GLOBAL_FILES=`find ${SCRIPT_PATH}/${GLOBAL_FILES_NAME} -type f|grep -oE "[^/]+$"|tr '\n' ' '`
#GLOBAL_FILES=`find ${SCRIPT_PATH} ! \( -regex ".*/\.git.*" \) -type f |grep -oP "[^/]+$"|tr '\n' ' '`

echo ${SCRIPT_PATH}
for file in ${GLOBAL_FILES}
do
	res=`find  ~ -name "${file}" -maxdepth 1`
	if [[ "$res" != "" ]]; then
		echo "backing up $res into ${res}.mine"
		mv -n "$res" "${res}.mine"
	fi
	ln -s "${SCRIPT_PATH}/${GLOBAL_FILES_NAME}/$file" ~/$file
done

