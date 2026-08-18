// --------------------------------------------- //
// Nextflow workflow for Bulk RNA-seq analysis using Nanopore data
// --------------------------------------------- //

// Pipeline parameters

params.samplesheet = 'samplesheet.csv'
params.fastq_dir = '/path/to/fastq_pass' // Directory containing the fastq files

// --------------------------------------------- //
// Processes
// --------------------------------------------- //
process readSamplesheet {
    input:
    path samplesheet
    output:
    path 'samplesheet_check.txt'

    script:
    """
    echo "Samplesheet:"
    cat ${samplesheet} > samplesheet_check.txt
    """
}

// samplesheet example 
// sample,barcode,condition
//  1,barcode_01,veh
//  2,barcode_02,veh
//  3,barcode_03,veh
//  ecc.


// --------------------------------------------- //
// Workflow
// --------------------------------------------- //

include { runConcatenateFastq } from 'modules/ConcatenateFastq.nf'
include { runNanoPlotQC_pre } from 'modules/NanoPlotQC.nf'
include { runNanoPlotQC_post } from 'modules/NanoPlotQC.nf'
include { runFastCat } from 'modules/FastCat_filtering.nf'  
include { runPychopper } from 'modules/Pychopper.nf'  

workflow {
    fastq_ch = channel.fromPath("${params.fastq_dir}/*.fastq.gz") // Reading fastq files but I should check with view() if the files are correctly read
    samplesheet_ch = channel.fromPath(params.samplesheet) // Reading CSV
    readSamplesheet(samplesheet_ch)
    
    // Parsing del CSV
    samplesheet_ch
        .splitCsv(header: true)
        .map { row -> tuple(row.barcode, row.condition) }
        .view()
        .set { barcode_ch }

    // Concatenate fastq
    runConcatenateFastq(fastq_ch)
    runNanoPlotQC_pre(runConcatenateFastq.out) // QC before filtering
    runFastCat(runConcatenateFastq.out)
    runNanoPlotQC_post(runFastCat.out) //di nuovo per il QC dopo il filtering
    runPychopper(runFastCat.out)
}


// CLI final command to run the workflow
// nextflow run main.nf --samplesheet samplesheet.csv --fastq_dir /data/fastq_pass







