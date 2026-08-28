#!/usr/bin/env nextflow

// Converting SAM files to BAM files and sorting.


process runSamtoBam {
    tag "${barcode}_${condition}"
    //publishDir "${params.outdir}/samtools_view/${barcode}_${condition}",
    //    mode: 'copy',
    //    overwrite: true

    input:
    tuple val(barcode), val(condition), path(sam)
    output:
    tuple val(barcode), val(condition),
          path("barcode_${barcode}_${condition}_aln.bam")
    script:
    """
    echo "Converting ${barcode} (${condition}) SAM to BAM"
    samtools view \
        -b \
        ${sam} \
        > barcode_${barcode}_${condition}_aln.bam
    """
}


process runSortBam {
    input:
    tuple val(barcode), val(condition), path(bam)
    output:
    tuple val(barcode), val(condition), path("barcode_${barcode}_${condition}_aln_sorted.bam")

    script:
    """
    echo "Starting Samtools conversion"
    echo "Converting $barcode SAM to BAM:"
    samtools sort $bam -o barcode_${barcode}_${condition}_aln_sorted.bam
    """
}


process runBamIndex {
    tag "${barcode}_${condition}"
    //publishDir "${params.outdir}/bam/${barcode}_${condition}",
    //    mode: 'copy',
    //    overwrite: true

    input:
    tuple val(barcode), val(condition), path(bam)
    output:
    tuple val(barcode), val(condition),
          path(bam),
          path("${bam}.bai")

    script:
    """
    echo "Indexing ${barcode} (${condition}) BAM"
    samtools index ${bam}
    """
}
