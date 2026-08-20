#!/usr/bin/env nextflow

// This process, after loading concatenated fastq files, will perform Filtering QC with Fastcat.


process runFastCat {
    input:
    tuple val(barcode), val(condition), path(fastq)

    output:
    tuple val(barcode), val(condition), path("filtered")

    script:
    """
    fastcat fastq \
        --min-qscore 10 \
        --min-length 200 \
        -o filtered \
        ${fastq}
    """
}