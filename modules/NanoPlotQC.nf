#!/usr/bin/env nextflow

// This process, after loading concatenated fastq files, will output the QC metrics using NanoPlot for each barcode and plot the results in a separate directory. 
// The output will be named as "${barcode}_${condition}_NanoPlotQC".
// I'm working on providing a single summary report for all barcodes and conditions, but for now, the output will be separate for each barcode and condition.

process runNanoPlotQC_pre {
    input:
    tuple val(barcode), val(condition), path(fastq)
    output:
    path "Nanoplot_${barcode}_${condition}"

    script:
    """
    NanoPlot -t 30 --fastq ${fastq} --outdir Nanoplot_${barcode}_${condition}
    """
}



process runNanoPlotQC_post {
    input:
    tuple val(barcode), val(condition), path(fastq)
    output:
    path "Nanoplot_${barcode}_${condition}_filtered"

    script:
    """
    NanoPlot -t 30 --fastq ${fastq} --outdir Nanoplot_${barcode}_${condition}_filtered
    """
}