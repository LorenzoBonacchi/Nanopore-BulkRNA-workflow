#!/usr/bin/env nextflow

// Trimming and orienting filtered fastq files.


process runPychopper {
    tag "${barcode}_${condition}"
    publishDir "${params.outdir}/pychopper",
        mode: 'copy',
        overwrite: true,
        saveAs: { filename ->
            "${barcode}_${condition}/${filename}"
        }

    input:
    tuple val(barcode), val(condition), path(fastq)
    output:
    tuple val(barcode), val(condition),
          path("${barcode}_${condition}_pychopper_report.txt"),
          emit: report
    tuple val(barcode), val(condition),
          path("${barcode}_${condition}_unclassified.fastq"),
          emit: unclassified
    tuple val(barcode), val(condition),
          path("${barcode}_${condition}_full_length.fastq"),
          emit: full_length

    script:
    """
    echo "Processing ${barcode} (${condition})"
    pychopper \
        -t ${params.default_threads} \
        -r ${barcode}_${condition}_pychopper_report.txt \
        -u ${barcode}_${condition}_unclassified.fastq \
        ${fastq} \
        ${barcode}_${condition}_full_length.fastq
    """
}