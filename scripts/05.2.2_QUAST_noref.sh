#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=QUAST_noref
#SBATCH --output=/data/users/lhennet/assembly_annotation_course/log/output_QUAST_noref_%j.o
#SBATCH --error=/data/users/lhennet/assembly_annotation_course/log/error_QUAST_noref_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/lhennet/assembly_annotation_course
OUTDIR=$WORKDIR/QUAST_noref
CONTAINER_PATH="/containers/apptainer/quast_5.2.0.sif"

# Run QUAST to evaluate and compare three different genome assemblies based on intrinsic quality metrics and raw HiFi reads, without using a reference genome

apptainer run --bind /data $CONTAINER_PATH \
quast.py \
$WORKDIR/flye_assembly/assembly.fasta \
$WORKDIR/hifasm_assembly/Elh-2.asm.bp.p_ctg.fa \
$WORKDIR/LJA_assembly/Elh-2_assembly/assembly.fasta \
-o $OUTDIR \
-t $SLURM_CPUS_PER_TASK --eukaryote --no-sv --est-ref-size 135000000 --labels Flye,HiFiasm,LJA --pacbio $WORKDIR/reads/Elh-2/ERR11437332.fastq.gz

# paths to the three assembly FASTA files to be evaluated; --eukaryote: specify eukaryotic genome -> QUAST adjusts analysis parameters (e.g., k-mer sizes); --no-sv: do not look for structural variants; --est-ref-size: estimated reference genome size to aid in quality metrics calculation; --labels: labels for each assembly; --pacbio: PacBio reads for additional evaluation; --features: annotation file in GFF3 format for calculating gene-related assembly metrics