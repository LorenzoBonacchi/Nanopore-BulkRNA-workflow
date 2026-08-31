#!/usr/bin/env nextflow

// This process runs Bambu on the sorted and indexed BAM files produced by the previous steps of the workflow. 
// The output will be a directory named "bambu_output" containing the Bambu results for each barcode and condition.

process runBambu {
    tag "${barcode}_${condition}"

    cpus params.bambu_threads
    publishDir "${params.outdir}/bambu/${barcode}", mode: 'copy'

    input:
    tuple val(barcode), val(condition), path(bam), path(bai)
    path reference_genome
    path annotation_gtf

    output:
    path "bambu_output/*"

    script:
    """
    mkdir -p bambu_output

    Rscript - <<'RSCRIPT'

    library(bambu)

    message("========================================")
    message("Bambu")
    message("Sample: ${barcode}")
    message("Condition: ${condition}")
    message("BAM: ${bam}")
    message("GTF: ${annotation_gtf}")
    message("Genome: ${reference_genome}")
    message("========================================")

    annotations <- prepareAnnotations(
        "${annotation_gtf}"
    )

    se <- bambu(
        reads = "${bam}",
        annotations = annotations,
        genome = "${reference_genome}",
        discovery = ${params.bambu_discovery},
        quant = ${params.bambu_quant},
        lowMemory = ${params.bambu_low_memory}
    )

    writeBambuOutput(
        se,
        path = "bambu_output",
        prefix = "${barcode}"
    )

    RSCRIPT
    """
}