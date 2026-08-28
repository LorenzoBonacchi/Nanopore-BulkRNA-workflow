#!/usr/bin/env nextflow

// Converting SAM files to BAM files and sorting.


process runSamtoBam {
    input:
    tuple val(barcode), val(condition), path(fastq)
    output:
    tuple val(barcode), val(condition), path("barcode_${barcode}_${condition}_aln.bam")

    script:
    """
    echo "Starting Samtools conversion"
    echo "Converting $barcode SAM to BAM:"
    samtools view -bS barcode_${barcode}_${condition}_aln.sam > barcode_${barcode}_${condition}_aln.bam
    """
}


process runSortBam {
    input:
    tuple val(barcode), val(condition), path(fastq)
    output:
    tuple val(barcode), val(condition), path("barcode_${barcode}_${condition}_aln_sorted.bam")

    script:
    """
    echo "Starting Samtools conversion"
    echo "Converting $barcode SAM to BAM:"
    samtools sort barcode_${barcode}_${condition}_aln.bam -o barcode_${barcode}_${condition}_aln_sorted.bam
    """
}


process runBamIndex {
    input:
    tuple val(barcode), val(condition), path(fastq)
    output:
    tuple val(barcode), val(condition), path("barcode_${barcode}_${condition}_aln_sorted.bam")

    script:
    """
    echo "Starting Samtools conversion"
    echo "Converting $barcode SAM to BAM:"
    samtools index barcode_${barcode}_${condition}_aln_sorted.bam
    """
}