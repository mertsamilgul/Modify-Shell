#!/bin/bash
IFS=${IFS#??} #Used for preventing error on file names contain spaces
if [ -n "$1" ];  then
    PATTERN=$1
fi
case "$1" in #creating a case for first arguement
-h) #HELP
    echo ""

    echo " modify:usage: modify.sh [-r] [-l|-u] <dir/file_name>"
    echo " modify:usage: modify.sh <pattern> <dir/file/name>"
    echo "  -r for recursive mode"
    echo "  -l for lowercasing"
    echo "  -u for uppercasing"
    echo "  enter sed pattern"
    echo "  Examples:"
    echo "  modify.sh -u test"
    echo "  modify.sh -r -u test"
    echo "  modify.sh -r -l TEST"
    ;;
-l) #LOWERCASE
    OPTION="-maxdepth${IFS#??}0"
    for i in $(find $2 -depth $OPTION); do
        FILE_NAME=$(basename "$i")
        FILE_PATH=$(dirname "$i")
        CHANGED_NAME=$(echo "${FILE_NAME}" | tr '[:upper:]' '[:lower:]')
        if [ "${FILE_NAME}" != "${CHANGED_NAME}" ] ; then
	    if [ -e "$FILE_PATH/${CHANGED_NAME}" ]; then
		echo "File '$FILE_PATH/$FILE_NAME' is not changed to '$CHANGED_NAME' to prevent override!"
	    else
	        mv "$i" "${FILE_PATH}/${CHANGED_NAME}"
	    fi
        fi
    done
    ;;
-u) #UPPERCASE
    OPTION="-maxdepth${IFS#??}0"
    for i in $(find $2 -depth $OPTION); do
        FILE_NAME=$(basename "$i")
        FILE_PATH=$(dirname "$i")
        CHANGED_NAME=$(echo "${FILE_NAME}" | tr '[:lower:]' '[:upper:]')
        if [ "${FILE_NAME}" != "${CHANGED_NAME}" ] ; then
	    if [ -e "$FILE_PATH/${CHANGED_NAME}" ]; then
		echo "File '$FILE_PATH/$FILE_NAME' is not changed to '$CHANGED_NAME' to prevent override!"
	    else
		mv "$i" "${FILE_PATH}/${CHANGED_NAME}"
	    fi
        fi
    done
    ;;
-r) #RECURSIVE
    if [ -n "$2" -a -z "$OPT" ];  then
	PATTERN=$2
    fi

    case "$2" in
    
    -l) #RECURSIVE LOWERCASE -r -l
    OPTION=""
    for i in $(find $3 -depth $OPTION); do
        FILE_NAME=$(basename "$i")
        FILE_PATH=$(dirname "$i")
        CHANGED_NAME=$(echo "${FILE_NAME}" | tr '[:upper:]' '[:lower:]')
        if [ "${FILE_NAME}" != "${CHANGED_NAME}" ] ; then
	     if [ -e "$FILE_PATH/${CHANGED_NAME}" ]; then
		echo "File '$FILE_PATH/$FILE_NAME' is not changed to '$CHANGED_NAME' to prevent override!"
	    else
		mv "$i" "${FILE_PATH}/${CHANGED_NAME}"
	    fi
        fi
    done
    ;;
    
    -u) #RECURSIVE UPPERCASE -r -u
    OPTION=""
    for f in $(find $3 -depth $OPTION); do
        FILE_NAME=$(basename "$i")
        FILE_PATH=$(dirname "$i")
        CHANGED_NAME=$(echo "${FILE_NAME}" | tr '[:lower:]' '[:upper:]')
        if [ "${FILE_NAME}" != "${CHANGED_NAME}" ] ; then
	    if [ -e "$FILE_PATH/${CHANGED_NAME}" ]; then
		echo "File '$FILE_PATH/$FILE_NAME' is not changed to '$CHANGED_NAME' to prevent override!"
	    else
		mv "$i" "${FILE_PATH}/${CHANGED_NAME}"
	    fi
        fi
    done
    ;;
    
    *) #RECURSIVE DEFAULT
    OPTION=""
    for i in $(find $3 -depth $OPTION); do
        FILE_NAME=$(basename "$i")
        FILE_PATH=$(dirname "$i")
        CHANGED_NAME=$(echo "${FILE_NAME}" | sed -s "$PATTERN")
        if [ "${FILE_NAME}" != "${CHANGED_NAME}" ] ; then
	    if [ -e "$FILE_PATH/${CHANGED_NAME}" ]; then
		echo "File '$FILE_PATH/$FILE_NAME' is not changed to '$CHANGED_NAME' to prevent override!"
	    else
		mv "$i" "${FILE_PATH}/${CHANGED_NAME}"
	    fi
        fi
    done
    esac
    ;;
*) #DEFAULT
    OPTION="-maxdepth${IFS#??}0"
    for i in $(find $2 -depth $OPTION); do
        FILE_NAME=$(basename "$i")
        FILE_PATH=$(dirname "$i")
        CHANGED_NAME=$(echo "${FILE_NAME}" | sed -s "$PATTERN")
        if [ "${FILE_NAME}" != "${CHANGED_NAME}" ] ; then
	    if [ -e "$FILE_PATH/${CHANGED_NAME}" ]; then
		echo "File '$FILE_PATH/$FILE_NAME' is not changed to '$CHANGED_NAME' to prevent override!"
	    else
		mv "$i" "${FILE_PATH}/${CHANGED_NAME}"
	    fi
        fi
    done
    ;;
    
esac
