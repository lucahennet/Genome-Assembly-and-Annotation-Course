#!/usr/bin/env bash

#SBATCH --time=02:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=kmer_count
#SBATCH --output=/data/users/lhennet/assembly_annotation_course/log/output_kmer_%j.o
#SBATCH --error=/data/users/lhennet/assembly_annotation_course/log/error_kmer_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/lhennet/assembly_annotation_course
OUTDIR=$WORKDIR/kmer_counting
CONTAINER_PATH="/containers/apptainer/jellyfish:2.2.6--0"

mkdir -p $OUTDIR

# Runs Jellyfish to count 21-bp k-mers from the Elh-2 read dataset and generate a histogram of their frequency distribution

# Count k-mers
apptainer run --bind /data $CONTAINER_PATH \
jellyfish count \
-C -m 21 -s 5G -t $SLURM_CPUS_PER_TASK -o $OUTDIR/reads.jf \
<(zcat $WORKDIR/reads/Elh-2/*)

# -C : count both strands (canonical k-mers); -m 21 : use k-mer size of 21;
# <(zcat ...) : stream decompressed reads directly from FASTQ files

# Generate k-mer histogram
apptainer run --bind /data $CONTAINER_PATH \
jellyfish histo \
-t $SLURM_CPUS_PER_TASK $OUTDIR/reads.jf > $OUTDIR/reads.histo