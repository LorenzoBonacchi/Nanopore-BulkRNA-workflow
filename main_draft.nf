# --------------------------------------------- #
# Nextflow workflow for Bulk RNA-seq analysis using Nanopore data
# --------------------------------------------- #

/*
 * Pipeline parameters
 */
params.samplesheet = 'samplesheet.csv'


# --------------------------------------------- #
# Processes
# --------------------------------------------- #
process readSamplesheet {
    publishDir 'results', mode: 'copy'
    input:
        val samplesheet
    output:
        path "${samplesheet}-barcode.txt"

    script:
    """
    echo '$samplesheet' > '$samplesheet-barcode.txt'
    """
}

process runConcatenateFastq {
    publishDir 'results', mode: 'copy'
    input:
        val barcode
    output:
        ????
    echo "Processing $barcode:"
    zcat /path/to/fastq_pass/barcode${barcode}*.fastq.gz > barcode_${barcode}_veh_combined.fastq
}

// samplesheet example 
// sample,barcode,condition
//  1,barcode_01,veh
//  2,barcode_02,veh
//  3,barcode_03,veh
//  ecc.

# --------------------------------------------- #
# Workflow
# --------------------------------------------- #

workflow {
    samplesheet_ch = Channel.fromPath(params.samplesheet) #fromPath is used to read csv
    // emit a greeting
    readSamplesheet(samplesheet_ch).splitCsv(header:true)
    .map { row -> row.barcode } //row -> row[1] in the example
    .view()

    // Concatenate fastq files for each barcode 
    runConcatenateFastq(readSamplesheet.out)
}

