#! /bin/zsh

SCRIPT_PATH="$PWD/`dirname $0`"
GLOBAL_FILES_NAME="files"
GLOBAL_FOLDERS_NAME="folders"
GLOBAL_BIN_FOLDER="bin"

GLOBAL_FILES=`find ${SCRIPT_PATH}/${GLOBAL_FILES_NAME} -type f|grep -oE "[^/]+$"|tr '\n' ' '`
GLOBAL_FOLDERS=`find ${SCRIPT_PATH}/${GLOBAL_FOLDERS_NAME} -type d -maxdepth 1 -mindepth 1|grep -oE "[^/]+$"|tr '\n' ' '`

ALL_FILES="${GLOBAL_FILES} ${GLOBAL_FOLDERS}"
BIN_FILES=`echo ${SCRIPT_PATH}/${GLOBAL_BIN_FOLDER}/*`

#########################################
## Creating Links
#########################################

for file in ${ALL_FILES}
do
	res=`find  ~ -name "${file}" -maxdepth 1`
	if [[ "$res" != "" ]]; then
		echo "backing up $res into ${res}.mine"
		mv -n "$res" "${res}.mine"
	fi

  isFolder=`echo "$GLOBAL_FOLDERS"|grep "$file"`
  if [[ "$isFolder" != "" ]]; then 
    folder=${GLOBAL_FOLDERS_NAME}
  else
    folder=${GLOBAL_FILES_NAME}
  fi
  
	ln -sf "${SCRIPT_PATH}/${folder}/$file" ~/$file
done

#########################################
## Copying to /usr/local/bin
#########################################

cp ${BIN_FILES} /usr/local/bin/

