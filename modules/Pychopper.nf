#!/usr/bin/env nextflow

// Trimming and orienting filtered fastq files.


process runPychopper {
    input:
    tuple val(barcode), val(condition), path(fastq)
    output:
    tuple val(barcode), val(condition), path("${barcode}_${condition}_pychopper_report.txt"), path("${barcode}_${condition}_unclassified.fastq"), path("${barcode}_${condition}_pychopped.fastq")

    script:
    """
    echo "Processing $barcode:"
    pychopper -t 18 -r ${barcode}_${condition}_pychopper_report.txt -u ${barcode}_${condition}_unclassified.fastq ${fastq} ${barcode}_${condition}_full_length.fastq
    """
}