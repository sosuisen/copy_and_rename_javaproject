#!/bin/bash
if [ $# -lt 4 ]; then
    echo "Usage: copy_and_rename.sh src_dir_and_src_proj_dir/ old_project_name dst_dir/ new_project_name"
    echo "Note that name of src_proj_dir may not be equal to old_project_name in .project"
    echo "e.g) copy_and_rename.sh /c/pleiades-ssj2023/workspace/kcg_ssj_Session/ Session /c/tmp/ Session2"
    exit 0
fi

# Add trailing slash
SRC=$1
SRC=${SRC%/}
SRC="$SRC/"

SRCPROJDIR=`basename ${SRC}`

OLDPROJNAME=$2

DST=$3
DST=${DST%/}
DST="$DST/"

NEWPROJNAME=$4
NEWPROJDIR="${DST}$4/"

if [[ $SRC = $NEWPROJDIR ]]; then
    echo "New proj must not equal to src proj"
    exit 0
fi
echo "copying $SRC to $DST ..."

cp -r $SRC $DST

echo "renaming ${DST}$SRCPROJDIR to ${DST}$NEWPROJNAME..."
mv ${DST}$SRCPROJDIR ${DST}$NEWPROJNAME

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

