#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=hifasm_assembly
#SBATCH --output=/data/users/lhennet/assembly_annotation_course/log/output_hifasm_%j.o
#SBATCH --error=/data/users/lhennet/assembly_annotation_course/log/error_hifasm_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/lhennet/assembly_annotation_course
OUTDIR=$WORKDIR/hifasm_assembly
CONTAINER_PATH="/containers/apptainer/hifiasm_0.25.0.sif"

mkdir -p $OUTDIR

apptainer run --bind /data $CONTAINER_PATH \
hifiasm -o $OUTDIR/Elh-2.asm -t $SLURM_CPUS_PER_TASK -f0 $WORKDIR/reads/Elh-2/*

# command run separately in the terminal to convert the gfa file to a fasta file
# awk '/^S/{print ">"$2;print $3}' ./hifasm_assembly/Elh-2.asm.bp.p_ctg.gfa > ./hifasm_assembly/Elh-2.asm.bp.p_ctg.fa