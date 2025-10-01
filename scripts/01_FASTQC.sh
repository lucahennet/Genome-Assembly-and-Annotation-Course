#!/usr/bin/env bash

#SBATCH --time=02:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=fastqc
#SBATCH --output=/data/users/lhennet/assembly_annotation_course/log/output_fastqc_%j.o
#SBATCH --error=/data/users/lhennet/assembly_annotation_course/log/error_fastqc_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/lhennet/assembly_annotation_course
OUTDIR=$WORKDIR/read_QC/fastqc_results
CONTAINER_PATH="/containers/apptainer/fastqc-0.12.1.sif"

mkdir -p $OUTDIR

# Runs FastQC to generate quality control reports for all FASTQ files from the Elh-2 and RNAseq_Sha datasets
apptainer exec --bind /data $CONTAINER_PATH \
  fastqc \
  -t 4 \
  -o $OUTDIR \
  $WORKDIR/reads/Elh-2/*.fastq.gz \
  $WORKDIR/reads/RNAseq_Sha/*.fastq.gz