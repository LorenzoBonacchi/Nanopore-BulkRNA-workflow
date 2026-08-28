#!/usr/bin/env nextflow

// Aligning Post QC-ready fastq files.


process runMinimap2 {
    input:
    tuple val(barcode), val(condition), path(fastq)
    output:
    tuple val(barcode), val(condition), path("barcode_${barcode}_${condition}_aln.sam")

    script:
    """
    echo "Starting Minimap2 alignment"
    echo "Aligning $barcode:"
    minimap2 -t 60 -a -x splice /home/lab-user/reference/Homo_sapiens.GRCh38.dna.primary_assembly.fa  ${fastq} > barcode_${barcode}_${condition}_aln.sam"
    """
}