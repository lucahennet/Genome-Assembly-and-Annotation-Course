#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=flye_assembly
#SBATCH --output=/data/users/lhennet/assembly_annotation_course/log/output_flye_%j.o
#SBATCH --error=/data/users/lhennet/assembly_annotation_course/log/error_fly_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/lhennet/assembly_annotation_course
OUTDIR=$WORKDIR/flye_assembly
CONTAINER_PATH="/containers/apptainer/flye_2.9.5.sif"

mkdir -p $OUTDIR

apptainer run --bind /data $CONTAINER_PATH \
flye --pacbio-hifi $WORKDIR/reads/Elh-2/* \
--out-dir $OUTDIR \
--threads $SLURM_CPUS_PER_TASK \