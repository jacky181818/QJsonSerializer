#!/bin/bash
# $1: $$SRCDIR
# $2: $$VERSION
# $3: $$[QT_INSTALL_BINS]
# $4: $$[QT_INSTALL_HEADERS]
# $5: $$[QT_INSTALL_DOCS]
# $pwd: dest dir

destDir="$(pwd)"
srcDir=$1
version=$2
verTag=$(echo "$version" | sed -e 's/.//g')
qtBins=$3
qtHeaders=$4
qtDocs=$5
doxyTemplate="$srcDir/Doxyfile"

cat "$doxyTemplate" > Doxyfile
echo "PROJECT_NUMBER = \"$version\"" >> Doxyfile
echo "OUTPUT_DIRECTORY = \"$destDir\"" >> Doxyfile
echo "QHP_NAMESPACE = \"de.skycoder42.qtjsonserializer.$verTag\"" >> Doxyfile
echo "QHP_CUST_FILTER_NAME = \"JsonSerializer $version\"" >> Doxyfile
echo "QHP_CUST_FILTER_ATTRS = \"qtjsonserializer $version\"" >> Doxyfile
echo "QHG_LOCATION = \"$qtBins/qhelpgenerator\"" >> Doxyfile
echo "INCLUDE_PATH += \"$qtHeaders\"" >> Doxyfile
echo "GENERATE_TAGFILE = \"$destDir/qtjsonserializer/qtjsonserializer.tags\"" >> Doxyfile
if [ "$DOXY_STYLE" ]; then
	echo "HTML_STYLESHEET = \"$DOXY_STYLE\"" >> Doxyfile
fi
if [ "$DOXY_STYLE_EXTRA" ]; then
	echo "HTML_EXTRA_STYLESHEET = \"$DOXY_STYLE_EXTRA\"" >> Doxyfile
fi

for tagFile in $(find "$qtDocs" -name *.tags); do
	if [ $(basename "$tagFile") !=  "qtjsonserializer.tags" ]; then
		echo "TAGFILES += \"$tagFile=https://doc.qt.io/qt-5\"" >> Doxyfile
	fi
done

cd "$srcDir"
doxygen "$destDir/Doxyfile"
