#!/bin/bash
if [ $# -lt 3 ]; then
    echo "Usage: copy_and_rename.sh src_proj_dir/ dst_dir/ new_project_name"
    exit 0
fi

# Add trailing slash
SRC=$1
if [[ SRC != */ ]]; then
    SRC="$SRC/"
fi

DST=$2
if [[ DST != */ ]]; then
    DST="$DST/"
fi

NEWPROJNAME=$3
NEWPROJDIR="${DST}$3/"

if [[ $SRC = $NEWPROJDIR ]]; then
    echo "New proj must not equal to src proj"
    exit 0
fi

echo "copying $SRC to $DST ..."
OLDPROJNAME=`basename ${SRC}`
cp -r $SRC $DST

echo "renaming ${DST}$OLDPROJNAME to ${DST}$NEWPROJNAME..."
mv ${DST}$OLDPROJNAME ${DST}$NEWPROJNAME

echo "removing ${NEWPROJDIR}bin..."
rm -rf "${NEWPROJDIR}bin"
echo "removing ${NEWPROJDIR}build..."
rm -rf "${NEWPROJDIR}build"
echo "removing ${NEWPROJDIR}.git..."
rm -rf "${NEWPROJDIR}.git"
rm -rf "${NEWPROJDIR}.gitignore"
echo "removing ${NEWPROJDIR}.gradle..."
rm -rf "${NEWPROJDIR}.gradle"

echo "replace with new project name in ${NEWPROJDIR}.project..."
sed -i "s/$OLDPROJNAME/$NEWPROJNAME/g" ${NEWPROJDIR}.project
echo "replace with new project name in ${NEWPROJDIR}.settings/..."
sed -i "s/$OLDPROJNAME/$NEWPROJNAME/g" ${NEWPROJDIR}.settings/*.launch
mv ${NEWPROJDIR}.settings/${OLDPROJNAME}-run.launch ${NEWPROJDIR}.settings/${NEWPROJNAME}-run.launch
mv ${NEWPROJDIR}.settings/${OLDPROJNAME}-debug.launch ${NEWPROJDIR}.settings/${NEWPROJNAME}-debug.launch
mv ${NEWPROJDIR}.settings/${OLDPROJNAME}-remotedebug.launch ${NEWPROJDIR}.settings/${NEWPROJNAME}-remotedebug.launch

echo "completed!"

