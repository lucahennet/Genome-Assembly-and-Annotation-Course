#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=merqury
#SBATCH --output=/data/users/lhennet/assembly_annotation_course/log/output_merqury_%j.o
#SBATCH --error=/data/users/lhennet/assembly_annotation_course/log/error_merqury_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/lhennet/assembly_annotation_course
READS=$WORKDIR/reads/Elh-2/*.fastq.gz
OUTDIR=$WORKDIR/merqury
CONTAINER_PATH="/containers/apptainer/merqury_1.3.sif"

mkdir -p $OUTDIR

FLYE=$WORKDIR/flye_assembly/assembly.fasta
HIFIASM=$WORKDIR/hifasm_assembly/Elh-2.asm.bp.p_ctg.fa
LJA=$WORKDIR/LJA_assembly/Elh-2_assembly/assembly.fasta

# Path inside container
export MERQURY="/usr/local/share/merqury"

# Run Merqury to evaluate the completeness and consensus accuracy of three genome assemblies using k-mer frequency statistics

# Building meryl DB from HiFi reads
if [ ! -d "$OUTDIR/hifi.meryl" ]; then # checks if the meryl k-mer database directory already exists
  echo "Building meryl DB from reads..."
  apptainer exec --bind /data "$CONTAINER_PATH" \
    meryl count k=21 output "$OUTDIR/hifi.meryl" $READS # counts all k-mers of length 21 in the input reads
else
  echo "Using existing meryl DB: $OUTDIR/hifi.meryl"
fi

# Running Merqury for each assembly
for ASM in flye hifiasm lja; do # loops through the list of assembly labels.
    echo "Running Merqury for $ASM..."
    mkdir -p "$OUTDIR/$ASM"
    cd "$OUTDIR/$ASM"

  # Conditional logic to assign the correct assembly file path   
    if [ "$ASM" == "flye" ]; then
        ASMFILE="$FLYE"
    elif [ "$ASM" == "hifiasm" ]; then
        ASMFILE="$HIFIASM"
    elif [ "$ASM" == "lja" ]; then
        ASMFILE="$LJA"
    fi

    apptainer exec --bind /data "$CONTAINER_PATH" \
      $MERQURY/merqury.sh "$OUTDIR/hifi.meryl" "$ASMFILE" "$ASM"
done