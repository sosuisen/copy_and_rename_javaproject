#!/bin/bash

if [ $# -lt 3 ]; then
    echo "Usage: copy_and_rename.sh src_proj_dir/ old_project_name new_project_name"
    echo "Note that name of src_proj_dir may not be equal to old_project_name in .project"
    echo "e.g) copy_and_rename.sh /c/pleiades-ssj2023/workspace/kcg_ssj_Session/ Session Session2"
    exit 0
fi

# Remove trailing slash if exists
SRC=$1
SRC=${SRC%/}
PARENTDIR=`dirname ${SRC}`
PARENTDIR="$PARENTDIR/"

OLDPROJNAME=$2
NEWPROJNAME=$3
NEWPROJDIR="$PARENTDIR$NEWPROJNAME/"

if [[ $OLDPROJNAME = $NEWPROJNAME ]]; then
    echo "New proj must not equal to src proj"
    exit 0
fi
echo "copying $OLDPROJNAME to $NEWPROJNAME ..."

mkdir $NEWPROJDIR
COPYFROM="$SRC/."
cp -r $COPYFROM $NEWPROJDIR

#echo "renaming ${DST}$SRCPROJDIR to ${DST}$NEWPROJNAME..."
#mv ${DST}$SRCPROJDIR ${DST}$NEWPROJNAME

echo "removing ${NEWPROJDIR}bin..."
rm -rf "${NEWPROJDIR}bin"
echo "removing ${NEWPROJDIR}build..."
rm -rf "${NEWPROJDIR}build"
echo "removing ${NEWPROJDIR}.git..."
rm -rf "${NEWPROJDIR}.git"
rm -rf "${NEWPROJDIR}.gitignore"
echo "removing ${NEWPROJDIR}.gradle..."
rm -rf "${NEWPROJDIR}.gradle"
echo "# Replace OLD: ${OLDPROJNAME} -> NEW: ${NEWPROJNAME}"
echo "replace with new project name in ${NEWPROJDIR}.project..."
sed -i "s/$OLDPROJNAME/$NEWPROJNAME/g" ${NEWPROJDIR}.project
echo "replace with new project name in ${NEWPROJDIR}.settings/..."
echo "# for JavaFx.."
sed -i "s/$OLDPROJNAME/$NEWPROJNAME/g" ${NEWPROJDIR}.settings/*.launch
mv ${NEWPROJDIR}.settings/${OLDPROJNAME}-run.launch ${NEWPROJDIR}.settings/${NEWPROJNAME}-run.launch
mv ${NEWPROJDIR}.settings/${OLDPROJNAME}-debug.launch ${NEWPROJDIR}.settings/${NEWPROJNAME}-debug.launch
mv ${NEWPROJDIR}.settings/${OLDPROJNAME}-remotedebug.launch ${NEWPROJDIR}.settings/${NEWPROJNAME}-remotedebug.launch
echo "# for WST.."
sed -i "s/$OLDPROJNAME/$NEWPROJNAME/g" ${NEWPROJDIR}.settings/org.eclipse.wst.common.component
echo "completed!"
