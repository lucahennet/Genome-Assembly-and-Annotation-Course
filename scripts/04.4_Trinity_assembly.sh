#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=trinity_assembly
#SBATCH --output=/data/users/lhennet/assembly_annotation_course/log/output_trinity_%j.o
#SBATCH --error=/data/users/lhennet/assembly_annotation_course/log/error_trinity_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/lhennet/assembly_annotation_course
OUTDIR=$WORKDIR/trinity_assembly

mkdir -p $OUTDIR

module add Trinity

# Runs Trinity on paired-end Illumina RNA-seq reads from RNAseq_Sha to assemble transcripts
Trinity --seqType fq --max_memory 60G --CPU $SLURM_CPUS_PER_TASK \
--left $WORKDIR/reads/RNAseq_Sha/*_1.fastq.gz --right $WORKDIR/reads/RNAseq_Sha/*_2.fastq.gz \
--output $OUTDIR

# --seqType: input files are FASTQ format; --left and --right: paired-end reads