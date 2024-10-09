#!/bin/bash

# Step 1: Download forward and reverse sequence files using wget

# Download the forward sequences
wget https://zenodo.org/records/10426436/files/ERR8774458_1.fastq.gz?download=1

# Download the reverse sequences
wget https://zenodo.org/records/10426436/files/ERR8774458_2.fastq.gz?download=1

#Download the refrence sequence
wget https://zenodo.org/records/10886725/files/Reference.fasta?download=1

#Rename the files

mv ERR8774458_1.fastq.gz\?download\=1 ERR8774458_1.fastq.gz  #rename forward sequence file

mv ERR8774458_2.fastq.gz\?download\=1 ERR8774458_2.fastq.gz  #rename reverse sequence file

mv Reference.fasta\?download\=1 Reference.fasta  #rename refrence sequence file

# Step 2: Run FastQC on raw FASTQ files

fastqc ERR8774458_1.fastq.gz ERR8774458_2.fastq.gz

# Use MultiQC: A tool for aggregating and visualizing results from multiple bioinformatics analyses.
# It consolidates output from various tools (like FastQC) into a single interactive report,
# making it easier to assess quality metrics across multiple samples.

# 1: Ensure MultiQC is installed.

# Step 3:Trimming
fastp -i ERR8774458_1.fastq.gz -I ERR8774458_2.fastq.gz -o trimmed_1.fastq.gz -O trimmed_2.fastq.gz

#Verify if FASTQ Files are Trimmed, run fastqc after trimming and compare it to before trimming
fastqc trimmed_1.fastq.gz trimmed_2.fastq.gz

# Step 4: Genome Mapping
# This step maps the trimmed reads (cleaned versions) to a reference genome
# BWA-MEM tool is used

# 1: Index the reference genome.
bwa index Reference.fasta

# 2:Map the sequences from our target sample to the reference genome
bwa mem Reference.fasta trimmed_1.fastq.gz trimmed_2.fastq.gz >ERR8774458.sam

# 3:Convert the SAM file to a BAM file using samtools to save space
samtools view -@ 10 -S -b ERR8774458.sam > ERR8774458.bam

# 4:We want a BAM file of reads and mapping information ordered by where in the reference genome those reads were aligned
samtools sort -@ 10 -o ERR8774458.sorted.bam ERR8774458.bam

# 5:Index the sorted BAM file
samtools index ERR8774458.sorted.bam

# 6:visualize the BAM file on Integrative Genomics Viewer (IGV)
#To load a reference genome in IGV, use the .fasta file and ensure that its corresponding .fai index file. The BWA index files are not applicable for this purpose.

samtools faidx Reference.fasta


# Step 5: Variant Calling using FreeBayes

# -f specifies the reference genome in FASTA format
# Input BAM file should be sorted and indexed
# Output will be directed to a VCF file containing the called variants

freebayes -f Reference.fasta ERR8774458.sorted.bam  > ERR8774458.vcf
# 2: Run MultiQC on the directory containing analysis results

multiqc  .


############################################################################################################### ANALYZE THE 5 DATASETS
# List of sample names
samples=("ACBarrie" "Alsen" "Baxter" "Chara" "Drysdale")

# Reference genome URL
reference_url="https://raw.githubusercontent.com/josoga2/yt-dataset/main/dataset/raw_reads/reference.fasta"

# Download reference genome
wget -O reference.fasta https://raw.githubusercontent.com/josoga2/yt-dataset/main/dataset/raw_reads/reference.fasta

# Loop through each sample
for sample in "${samples[@]}"; do
    echo "Processing $sample"

    # Download the forward and reverse reads
    wget -O ${sample}_R1.fastq.gz https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/${sample}_R1.fastq.gz
    wget -O ${sample}_R2.fastq.gz https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/${sample}_R2.fastq.gz

    # Run FastQC for quality control
    fastqc ${sample}_R1.fastq.gz ${sample}_R2.fastq.gz

    # Step 2:Trimming
    #1: Run FastP for trimming
    fastp -i ${sample}_R1.fastq.gz -I ${sample}_R2.fastq.gz -o ${sample}_R1_trimmed.fastq.gz -O ${sample}_R2_trimmed.fastq.gz -j ${sample}_fastp.json -h ${sample}_fastp.html

    #2: Verify if FASTQ Files are Trimmed, run fastqc after trimming and compare it to before trimming
    fastqc ${sample}_R1_trimmed.fastq.gz ${sample}_R2_trimmed.fastq.gz

    #Step 3:use BBTools to fix disordered paired-end sequencing read
    url="https://sourceforge.net/projects/bbmap/files/latest/download"
    file="bbtools.tar.gz"

    #1: Check if the file exists
    if [ -f "$file" ]; then
    echo "File '$file' already exists. No need to download."
    else
    echo "File '$file' not found. Downloading..."
    wget "$url" -O "$file"
    # Extract files.
    tar -xvzf bbtools.tar.gz
    if [ $? -eq 0 ]; then
        echo "Download successful."
    else
        echo "Download failed."
        fi
    fi

    #2: Construct input and output file names
    in1="${sample}_R1.fastq.gz"
    in2="${sample}_R2.fastq.gz"
    out1="corrected_${sample}_R1.fastq.gz"
    out2="corrected_${sample}_R2.fastq.gz"
    singletons="singletons_${sample}.fastq.gz"

    #2: Run the repair.sh command using the absolute path
    $PWD/bbmap/repair.sh in1="$in1" in2="$in2" out1="$out1" out2="$out2" outs="$singletons" repair

    # Step 4: Genome Mapping
    # This step maps the trimmed reads (cleaned versions) to a reference genome
    # BWA-MEM tool is used

    # 1: Index the reference genome.
    bwa index reference.fasta

    # 2:Map the sequences from our target sample to the reference genome
    bwa mem reference.fasta corrected_${sample}_R1.fastq.gz corrected_${sample}_R2.fastq.gz >${sample}.sam

    # 3:Convert the SAM file to a BAM file using samtools to save space
    samtools view -@ 10 -S -b ${sample}.sam > ${sample}.bam

    # 4:We want a BAM file of reads and mapping information ordered by where in the reference genome those reads were aligned
    samtools sort -@ 10 -o ${sample}.sorted.bam ${sample}.bam

    # 5:Index the sorted BAM file
    samtools index ${sample}.sorted.bam

    # 6:visualize the BAM file on Integrative Genomics Viewer (IGV)
    #To load a reference genome in IGV, use the .fasta file and ensure that its corresponding .fai index file. The BWA index files are not applicable for this purpose.

    samtools faidx reference.fasta


    # Step 5: Variant Calling using FreeBayes

    #  -f specifies the reference genome in FASTA format
    # Input BAM file should be sorted and indexed
    # Output will be directed to a VCF file containing the called variants

    freebayes -f reference.fasta ${sample}.sorted.bam  > ${sample}.vcf


done

    #Step 6
    # final report analysis: Run MultiQC on the directory containing analysis results
    multiqc --force .

