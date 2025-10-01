#!/usr/bin/env bash

#SBATCH --time=02:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=fastp
#SBATCH --output=/data/users/lhennet/assembly_annotation_course/log/output_fastp_%j.o
#SBATCH --error=/data/users/lhennet/assembly_annotation_course/log/error_fastp_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/lhennet/assembly_annotation_course
OUTDIR=$WORKDIR/reads/reads_fastp_results
CONTAINER_PATH="/containers/apptainer/fastp_0.24.1.sif"

mkdir -p $OUTDIR

# runs fastp to (1) trim and filter paired-end Illumina RNA-seq reads with quality/adaptor control and (2) copy PacBio HiFi reads without filtering

# Illumina RNA-seq
apptainer run --bind /data $CONTAINER_PATH fastp \
    -i $WORKDIR/reads/RNAseq_Sha/ERR754081_1.fastq.gz -I $WORKDIR/reads/RNAseq_Sha/ERR754081_2.fastq.gz \ 
    -o "$OUTDIR/ERR754081_1.trimmed.fastq.gz" -O "$OUTDIR/ERR754081_2.trimmed.fastq.gz" \
    --detect_adapter_for_pe \
    --cut_front --cut_tail --cut_window_size 4 --cut_mean_quality 20 \
    --length_required 30 \ 
    -h "${OUTDIR}/fastp_rna.html"

#   -i: input read1 and read2; -o: trimmed output read1 and read2; --detect_adapter_for_pe: auto-detect adapters;
#   --cut_front / --cut_tail: trim low-quality bases at both ends;
#   --cut_window_size 4 --cut_mean_quality 20: sliding window quality trimming;
#   --length_required 30: discard reads shorter than 30 bp;
#   -h: generate HTML QC report

# PacBio HiFi (no filtering)
apptainer run --bind /data $CONTAINER_PATH fastp \
    -i $WORKDIR/reads/Elh-2/*.fastq.gz \
    -o "$OUTDIR/ERR11437332.copy.fastq.gz" \
    -A -Q -L \
    -h "${OUTDIR}/fastp_hifi.html"

#   -i: input fastq files (all HiFi reads); -o: single output file (copied reads);
#   -A -Q -L: disable adapter trimming, quality filtering, and length filtering
#   -h: generate HTML QC report