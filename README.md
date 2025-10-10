# Genome and Transcriptome Assembly Project

This repository contains the scripts and documentation for the Assembly and annotation course given at the University of Bern, Switzerland. The goal was to assemble and evaluate the genome (using PacBio HiFi reads) and transcriptome (using Illumina RNA-Seq reads) of *Arabidopsis thaliana* accessions.

## Workflow Overview

The project followed a two-part pipeline: Genome Assembly and Transcriptome Assembly, followed by a comprehensive evaluation and comparison phase.

### 1. Genome Assembly Pipeline

This pipeline focused on generating a *de novo* genome assembly from PacBio HiFi reads.

1. Read Quality Control and Preprocessing
    - Initial QC: `01_FASTQC.sh` was run to assess the quality of the raw reads using FastQC.
    - Filtering: `02_FASTP.sh` used fastp for basic read processing, filtering, and quality trimming.

2. K-mer Analysis

    - `03_k-mer_counting.sh` used Jellyfish to count k-mers. These counts were used with GenomeScope to estimate key genomic properties like genome size, heterozygosity, and coverage depth.

3. Genome Assembly

    Three different long-read assemblers were used:
     - Flye: `04.1_flye_assembly.sh`

    - Hifiasm: `04.2_hifiasm_assembly.sh`

    - LJA: `04.3_LJA_assembly.sh`

### 2. Transcriptome Assembly Pipeline

This pipeline focused on assembling transcripts (*de novo*) from the Illumina RNA-Seq data.
- Assembly: the filtered RNA-Seq reads (from the QC steps) were used by `04.4_Trinity_assembly.sh` to perform de novo transcriptome assembly using Trinity.

### 3. Assembly Evaluation & Comparison

The final phase assessed the quality, completeness, and structure of all generated assemblies.

1. Biological Completeness (BUSCO)

    - `05.1_BUSCO.sh` assessed the biological completeness of both genome and transcriptome assemblies by quantifying the presence of conserved single-copy orthologs from the Brassicales lineage.

2. Structural Quality (QUAST)

    - Reference-based: `05.2.1_QUAST_ref.sh` calculated assembly quality metrics (N50, total length) and alignment statistics using the A. thaliana reference genome.

    - Reference-free: `05.2.2_QUAST_noref.sh` calculated basic assembly quality metrics (N50, contig counts, etc.) without a reference genome for comparison.

3. Base-Level Quality (Merqury)

    - `05.3_merqury.sh` used k-mer based analysis to estimate the assembly's base-level quality (Qv score) and confirm read concordance with the assemblies.

4. Genome Alignment (MUMmer)

    - `06_nucmer_mummer.sh` performed whole-genome alignment (NUCmer) and visualization (MUMmerplot) to compare assemblies against the reference and each other, highlighting structural differences.

## Datasets

The datasets used in this project come from the following studies:

Lian Q, et al. A pan-genome of 69 Arabidopsis thaliana accessions reveals a conserved genome structure throughout the global species range Nature Genetics. 2024;56:982-991. Available from: https://www.nature.com/articles/s41588-024-01715-9
    
Jiao WB, Schneeberger K. Chromosome-level assemblies of multiple Arabidopsis genomes reveal hotspots of rearrangements with altered evolutionary dynamics. Nature Communications. 2020;11:1–10. Available from: http://dx.doi.org/10.1038/s41467-020-14779-y

## Tools Used

Note that the different parameters used are listed and explained within the scripts.
- Read Processing: FastQC, fastp
- Analysis: Jellyfish, GenomeScope (external)
- Genome Assemblers: Flye, Hifiasm, LJA
- Transcriptome Assembler: Trinity
- Evaluators: BUSCO, QUAST, Merqury, MUMmer/NUCmer
