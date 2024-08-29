#!/bin/bash

umask=002
module load freesurfer
source ${FREESURFER_HOME}/SetUpFreeSurfer.sh
export ROOTDIR=/path/to/your/dir
export SUBJECTS_DIR=${ROOTDIR}/derivatives/freesurfer
export STL_DIR=${ROOTDIR}/derivatives/stl
SUBJECT=$1
mkdir ${STL_DIR}/${SUBJECT}
SWARMFILE=${ROOTDIR}/slurm/swarm.surf
# Maybe tweak the following line
T1w="$(find /path/to/raw/data/$SUBJECT -name "*T1W*.nii.gz" | head -1)" # This line will run freesurfer for the first file for the subject.
echo ""
echo "Working on T1W: ${T1w}"
echo ""
echo -n "" > ${SWARMFILE}
echo "  export TMPDIR=/lscratch/\${SLURM_JOBID} ; \
	export TMP=/lscratch/\${SLURM_JOBID} ; \
	mkdir -p \${TMPDIR} ; \
	recon-all -all -s ${SUBJECT} -i ${T1w} ; \
	for hemi in lh rh ; \
		do mris_convert ${SUBJECTS_DIR}/${SUBJECT}/surf/\${hemi}.pial ${STL_DIR}/${SUBJECT}/\${hemi}_pial.stl ; \
	done ; \
	chgrp -R EDB ${SUBJECTS_DIR}/${SUBJECT} ${STL_DIR}/${SUBJECT} ; \
	chmod -R 770 ${SUBJECTS_DIR}/${SUBJECT} ${STL_DIR}/${SUBJECT} " >> ${SWARMFILE}
swarm -f ${SWARMFILE} -g 16 --gres=lscratch:10 -t 2 --logdir ${ROOTDIR}/slurm --time=24:00:00 --job-name surface.$SUBJECT


