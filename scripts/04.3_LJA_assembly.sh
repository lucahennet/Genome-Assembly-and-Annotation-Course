#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=LJA_assembly
#SBATCH --output=/data/users/lhennet/assembly_annotation_course/log/output_LJA_%j.o
#SBATCH --error=/data/users/lhennet/assembly_annotation_course/log/error_LJA_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/lhennet/assembly_annotation_course
OUTDIR=$WORKDIR/LJA_assembly
CONTAINER_PATH="/containers/apptainer/lja-0.2.sif"

mkdir -p $OUTDIR

# Runs LJA to assemble Elh-2 PacBio HiFi reads into a genome assembly
apptainer run --bind /data $CONTAINER_PATH \
lja -t $SLURM_CPUS_PER_TASK -o $OUTDIR/Elh-2_assembly \
--reads $WORKDIR/reads/Elh-2/*