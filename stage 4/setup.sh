#!/bin/bash

# This script installs all necessary tools for the pipeline.

#1: Update package list
sudo apt update

#2: Installing essential tools
sudo apt install -y wget fastqc fastp bwa samtools freebayes openjdk-11-jdk

#3: Install conda
wget https://repo.anaconda.com/archive/Anaconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh

#Execute the installer
bash ~/anaconda.sh -b -p $HOME/anaconda3

#Add anaconda to your PATH:
echo 'export PATH="$HOME/anaconda3/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

#Verify Installation
conda --version


#4: Install MultiQC using Conda
conda install multiqc -y

#Verfiy Installation
multiqc --version



#5: Install bbtools
wget https://sourceforge.net/projects/bbmap/files/latest/download -O bbtools.tar.gz

#Extract included files
tar -xvzf bbtools.tar.gz
