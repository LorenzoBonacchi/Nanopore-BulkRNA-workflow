#!/usr/bin/env nextflow

// This process, after loading concatenated fastq files, will perform Filtering QC with Fastcat.


process runFastCat {
    tag "${barcode}_${condition}"

    publishDir "${params.outdir}/fastcat/${barcode}_${condition}",
        mode: 'copy',
        overwrite: true

    input:
    tuple val(barcode), val(condition), path(fastq)
    output:
    tuple val(barcode), val(condition), path("filtered/*.fastq"), emit: filtered_fastq

    script:
    """
    mkdir -p filtered
    fastcat fastq \
        --min-qscore 10 \
        --min-length 200 \
        -o filtered \
        ${fastq}
    """
}