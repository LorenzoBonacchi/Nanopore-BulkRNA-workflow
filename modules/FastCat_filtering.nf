#!/usr/bin/env nextflow

// This process, after loading concatenated fastq files, will perform Filtering QC with Fastcat.


process runFastCat {
    input:
    tuple val(barcode), val(condition), path(fastq)
    output:
    tuple val(barcode), val(condition), path("${barcode}_${condition}_filtered.fastq")

    script:
    """
    fastcat -i ${fastq} -o ${barcode}_${condition}_filtered.fastq
    """
}