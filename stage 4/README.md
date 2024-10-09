Author: " Mahmoud Hassanen(@Mahmoud203) , Sarah Shebl (@Sarah50)
# HackBio-internship-stage-4

This repository contains a Bash script designed to automate the process of downloading sequencing data, performing quality control, trimming, genome mapping, and variant calling for multiple datasets. The script utilizes various bioinformatics tools, including FastQC, FastP, BWA, Samtools, and FreeBayes.

# Contents

**Data Download:** Downloads forward and reverse sequence files along with a reference genome.

**Quality Control:** Uses FastQC to assess the quality of raw and trimmed FASTQ files.

**Trimming:** Utilizes FastP to trim low-quality bases from the sequences.

**Genome Mapping:** Maps the cleaned reads to a reference genome using BWA.

**Variant Calling:** Calls variants from the mapped reads using FreeBayes.

**MultiQC Reporting:** Aggregates results from various analyses into a single report.

# Prerequisites

Before running the script, ensure that you have the following tools installed:

wget

fastqc

fastp

bwa

samtools

freebayes

multiqc

# Steps in the Script

**Step 1: Download Data**

The script downloads:

Forward and reverse sequence files.

A reference genome.

**Step 2: Quality Control**

FastQC is run on both raw and trimmed FASTQ files to assess their quality.

**Step 3: Trimming**

FastP is used to trim low-quality sequences from the FASTQ files.

**Step 4: Genome Mapping**

The cleaned reads are mapped to a reference genome using BWA. The output is converted from SAM to BAM format for efficient storage.

**Step 5: Variant Calling**

FreeBayes is used to call variants from the sorted BAM file, generating a VCF file with variant information.

**Step 6: MultiQC Reporting**

MultiQC is executed to generate an aggregated report of all analysis results.

**Sample Processing Loop**
The script includes a loop that processes multiple datasets specified in an array. Each sample undergoes the same steps as outlined above.





![image](https://github.com/user-attachments/assets/fb0f0fb9-f9b7-4c0e-99c0-05dacab396ad)
