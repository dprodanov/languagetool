#!/bin/sh
# Bulgarian language generation

./unmunch.sh bg_BG_IV.dic bg_BG_IV.aff > bg_BG2.txt

cat bg_BG2.txt | sort | uniq > bg_BG3.txt

hunspell -d bg_BG_IV -L bg_BG3.txt > wrong.txt

while read line; 
	do cat bg_BG.txt | grep -a -v "^$line$" > tmp.txt; 
	mv tmp.txt bg_BG.txt ; 
done < wrong.txt

#java -cp languagetool-core.jar:languagetool-dev-5.7-SNAPSHOT.jar:slf4j-api.jar:segment.jar:commons-logging.jar:jaxb-api.jar:logback-core.jar org.languagetool.dev.archive.WordTokenizer bg | sort -u > bg_BG.txt
#cat bg_BG1.txt spelling_merged.txt | java -cp languagetool-core.jar org.languagetool.dev.archive.WordTokenizer bg | sort -u > bg_BG.txt
java -cp languagetool-tools.jar org.languagetool.tools.SpellDictionaryBuilder -i bg_BG1.txt -info bg_BG.info -o bg_BG.dict
