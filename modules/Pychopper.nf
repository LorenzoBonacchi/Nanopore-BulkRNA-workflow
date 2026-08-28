#!/usr/bin/env nextflow

// Trimming and orienting filtered fastq files.


process runPychopper {
    tag "${barcode}_${condition}"
    publishDir "${params.outdir}/pychopper/${barcode}_${condition}",
        mode: 'copy',
        overwrite: true

    input:
    tuple val(barcode), val(condition), path(fastq)
    output:
    tuple val(barcode), val(condition),
          path("${barcode}_${condition}_full_length.fastq"),
          emit: full_length
    tuple val(barcode), val(condition),
          path("${barcode}_${condition}_pychopper_report.txt"),
          emit: report
    tuple val(barcode), val(condition),
          path("${barcode}_${condition}_unclassified.fastq"),
          emit: unclassified

    script:
    """
    echo "Processing ${barcode} (${condition})"
    pychopper \
        -t 18 \
        -r ${barcode}_${condition}_pychopper_report.txt \
        -u ${barcode}_${condition}_unclassified.fastq \
        ${fastq} \
        ${barcode}_${condition}_full_length.fastq
    """
}
