#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=BUSCO
#SBATCH --output=/data/users/lhennet/assembly_annotation_course/log/output_BUSCO_%j.o
#SBATCH --error=/data/users/lhennet/assembly_annotation_course/log/error_BUSCO_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/lhennet/assembly_annotation_course
OUTDIR=$WORKDIR/BUSCO
# CONTAINER_PATH="/containers/apptainer/busco_5.7.1.sif"

mkdir -p $OUTDIR

cd $OUTDIR

module add BUSCO/5.4.2-foss-2021a

# runs BUSCO on four different genome/transcriptome assemblies (Flye, HiFiasm, LJA, and Trinity) using the brassicales_odb10 lineage dataset to assess their completeness

# Flye assembly
busco -i $WORKDIR/flye_assembly/assembly.fasta \
-l brassicales_odb10 -o busco_flye --mode genome -c $SLURM_CPUS_PER_TASK

# LJA assembly
busco -i $WORKDIR/hifasm_assembly/Elh-2.asm.bp.p_ctg.fa \
-l brassicales_odb10 -o busco_hifiasm --mode genome -c $SLURM_CPUS_PER_TASK

# LJA assembly
busco -i $WORKDIR/LJA_assembly/Elh-2_assembly/assembly.fasta \
-l brassicales_odb10 -o busco_LJA --mode genome -c $SLURM_CPUS_PER_TASK

# Trinity (RNA-seq) assembly
busco -i $WORKDIR/trinity_assembly/trinity_assembly.Trinity.fasta \
-l brassicales_odb10 -o busco_trinity --mode transcriptome -c $SLURM_CPUS_PER_TASK