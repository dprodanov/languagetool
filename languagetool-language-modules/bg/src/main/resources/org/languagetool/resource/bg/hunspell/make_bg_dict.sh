#!/bin/sh
# Bulgarian language generation

echo "Merge and truncate additional hunspell dictionary file and update binary morfologik spelling dictionary"
echo "This script assumes you have the full LanguageTool build environment"
echo "Please call this script from the LanguageTool top-level directory"
echo "Also ensure all files used are in UTF-8 encoding"
#echo "Expects separate header files for .dic / spelling.txt"
echo ""


echo $#
if [ $# -ne 2 ]
then
  SCRIPT=`basename $0`
  echo "Usage: $SCRIPT <langCode> <countryCode>"
  echo "  For example: $SCRIPT bg BG_IV"
  exit 1
fi

REPO="$HOME/GitHub/languagetool"
LT_VERSION=5.7-SNAPSHOT
TEMP_FILE="/tmp/lt-dictionary.txt"


LIBPREFF=${REPO}/languagetool-standalone/target/LanguageTool-5.7-SNAPSHOT/LanguageTool-5.7-SNAPSHOT/libs

#CPATH=${REPO}/org/carrot2/morfologik-tools/2.1.2/morfologik-tools-2.1.2.jar:${REPO}/org/carrot2/morfologik-fsa/2.1.2/morfologik-fsa-2.1.2.jar:${REPO}/org/carrot2/morfologik-fsa-builders/2.1.2/morfologik-fsa-builders-2.1.2.jar:${REPO}/commons-cli/commons-cli/1.2/commons-cli-1.2.jar:${REPO}/com/beust/jcommander/1.48/jcommander-1.48.jar:${REPO}/com/carrotsearch/hppc/0.7.1/hppc-0.7.1.jar:languagetool-tools/target/languagetool-tools-${LT_VERSION}.jar

echo "Libraries in " ${LIBPREFF}

CPATH=${LIBPREFF}/morfologik-tools.jar:${LIBPREFF}/morfologik-fsa.jar:${LIBPREFF}/morfologik-fsa-builders.jar:${LIBPREFF}/commons-cli.jar:${LIBPREFF}/jcommander.jar:${LIBPREFF}/hppc.jar

LANG_CODE=$1
COUNTRY_CODE=$2
PREFIX=${LANG_CODE}_${COUNTRY_CODE}

echo ${PREFIX}

 
CONTENT_DIR=languagetool-language-modules/${LANG_CODE}/src/main/resources/org/languagetool/resource/${LANG_CODE}/hunspell

COUNTRY_CODE_LOWER=`echo ${COUNTRY_CODE} | tr '[:upper:]' '[:lower:]'`

#echo ${COUNTRY_CODE_LOWER}

INFO_FILE=${CONTENT_DIR}/${PREFIX}.info 
DIC_FILE=${CONTENT_DIR}/${PREFIX}
OUTPUT_FILE=${DIC_FILE}.dict

echo ${DIC_FILE}

UNMUNCHED=/tmp/unmunched.txt
 ${CONTENT_DIR}/unmunch.sh  ${DIC_FILE}.dic ${DIC_FILE}.aff >${UNMUNCHED}

 cat ${UNMUNCHED} | sort | uniq > ${TEMP_FILE}

 if [ -f ${CONTENT_DIR}/${COUNTRY_CODE_LOWER}_wordlist.xml ]; then
         WORD_COUNT="${CONTENT_DIR}/${COUNTRY_CODE_LOWER}_wordlist.xml"
		 echo "word counts in " ${WORD_COUNT}
   fi

echo "Building morfologik dictionary..."

 if [ -f ${FREQ_FILE} ]; then
	java -cp ${CPATH}:languagetool-standalone/target/LanguageTool-${LT_VERSION}/LanguageTool-${LT_VERSION}/languagetool.jar:languagetool-standalone/target/LanguageTool-${LT_VERSION}/LanguageTool-${LT_VERSION}/libs/languagetool-tools.jar \
	org.languagetool.tools.SpellDictionaryBuilder -i ${TEMP_FILE} -info ${INFO_FILE} -o ${OUTPUT_FILE} -freq ${WORD_COUNT}
else
	java -cp ${CPATH}:languagetool-standalone/target/LanguageTool-${LT_VERSION}/LanguageTool-${LT_VERSION}/languagetool.jar:languagetool-standalone/target/LanguageTool-${LT_VERSION}/LanguageTool-${LT_VERSION}/libs/languagetool-tools.jar \
	org.languagetool.tools.SpellDictionaryBuilder -i ${TEMP_FILE} -info ${INFO_FILE} -o ${OUTPUT_FILE} 
 fi
 
 rm ${UNMUNCHED} 
 rm ${TEMP_FILE}