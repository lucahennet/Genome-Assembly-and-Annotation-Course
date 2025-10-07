#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=nucmer_mummer
#SBATCH --output=/data/users/lhennet/assembly_annotation_course/log/output_nucmer_mummer_%j.o
#SBATCH --error=/data/users/lhennet/assembly_annotation_course/log/error_nucmer_mummer_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/lhennet/assembly_annotation_course
OUTDIR=$WORKDIR/nucmer_mummer
CONTAINER_PATH="/containers/apptainer/mummer4_gnuplot.sif"

REF=/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
FLYE=$WORKDIR/flye_assembly/assembly.fasta
HIFIASM=$WORKDIR/hifasm_assembly/Elh-2.asm.bp.p_ctg.fa
LJA=$WORKDIR/LJA_assembly/Elh-2_assembly/assembly.fasta

mkdir -p $OUTDIR

# Run MUMmer (specifically nucmer and mummerplot) inside an Apptainer container to perform all-against-all sequence alignments between three genome assemblies and a reference genome, generating alignment files and dot plots for visualization

apptainer run --bind /data $CONTAINER_PATH bash <<EOF

# Move into output directory so nucmer/mummerplot write results here
cd $OUTDIR

# ---------- Align assemblies against reference ----------
nucmer --prefix=flye_vs_ref --breaklen 1000 --mincluster 1000 $REF $FLYE

    # nucmer: aligns the query (FLYE) against the reference (REF)
    # --prefix: base name for output files
    # --breaklen 1000: breaks alignments that span a gap of >1000bp, useful for finding misassemblies
    # --mincluster 1000: minimum length of a match cluster to be reported

mummerplot -R $REF -Q $FLYE --filter -t png --large --layout --fat -p flye_vs_ref flye_vs_ref.delta

    # -R/-Q: explicitly defines the reference/query for the plot
    # --filter: filters alignments to keep only the 'best' unique alignments
    # -t png: output format is PNG image
    # --large: creates a larger, higher-resolution plot
    # --layout: lays out multiple reference sequences (e.g., chromosomes) linearly on the X-axis
    # --fat: increases line thickness for better visibility
    # -p: prefix for the output plot files

nucmer --prefix=hifiasm_vs_ref --breaklen 1000 --mincluster 1000 $REF $HIFIASM
mummerplot -R $REF -Q $HIFIASM --filter -t png --large --layout --fat -p hifiasm_vs_ref hifiasm_vs_ref.delta

nucmer --prefix=lja_vs_ref --breaklen 1000 --mincluster 1000 $REF $LJA
mummerplot -R $REF -Q $LJA --filter -t png --large --layout --fat -p lja_vs_ref lja_vs_ref.delta

# ---------- Compare assemblies to each other ----------
nucmer --prefix=flye_vs_hifiasm --breaklen 1000 --mincluster 1000 $FLYE $HIFIASM
mummerplot -R $FLYE -Q $HIFIASM --filter -t png --large --layout --fat -p flye_vs_hifiasm flye_vs_hifiasm.delta

nucmer --prefix=flye_vs_lja --breaklen 1000 --mincluster 1000 $FLYE $LJA
mummerplot -R $FLYE -Q $LJA --filter -t png --large --layout --fat -p flye_vs_lja flye_vs_lja.delta

nucmer --prefix=hifiasm_vs_lja --breaklen 1000 --mincluster 1000 $HIFIASM $LJA
mummerplot -R $HIFIASM -Q $LJA --filter -t png --large --layout --fat -p hifiasm_vs_lja hifiasm_vs_lja.delta

EOF