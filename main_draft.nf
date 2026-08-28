// --------------------------------------------- //
// Nextflow workflow for Bulk RNA-seq analysis using Nanopore data
// --------------------------------------------- //

// Pipeline parameters

params.samplesheet = 'samplesheet.csv'
params.fastq_dir = '/path/to/fastq_pass' // Directory containing the fastq files
params.reference_genome = '/home/lab-user/reference/Homo_sapiens.GRCh38.dna.primary_assembly.fa'
params.outdir = 'results'

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
include { runConcatenateFastq } from './modules/ConcatenateFastq.nf'
include { runNanoPlotQC_pre } from './modules/NanoPlotQC.nf'
include { runNanoPlotQC_post } from './modules/NanoPlotQC.nf'
include { runFastCat } from './modules/FastCat_filtering.nf'  
include { runPychopper } from './modules/Pychopper.nf'  
include { runMinimap2 } from './modules/Minimap2.nf'
include { runSamtoBam } from './modules/Samtools.nf'
include { runSortBam } from './modules/Samtools.nf' 
include { runBamIndex } from './modules/Samtools.nf'    


workflow {
    samplesheet_ch = channel.fromPath(params.samplesheet)
    readSamplesheet(samplesheet_ch)
    samplesheet_ch
        .splitCsv(header: true)
        .map { row ->
            tuple(
                row.barcode,
                row.condition,
                file("${params.fastq_dir}/${row.barcode}/*.fastq.gz", checkIfExists: true)
            )
        }
        .view { "INPUT: $it" }
        .set { fastq_ch }

    runConcatenateFastq(fastq_ch)
    runNanoPlotQC_pre(runConcatenateFastq.out)
    runFastCat(runConcatenateFastq.out)
    runNanoPlotQC_post(runFastCat.out.filtered_fastq)
    runPychopper(runFastCat.out.filtered_fastq)
    runMinimap2(runPychopper.out.full_length)
    runSamtoBam(runMinimap2.out)
    runSortBam(runSamtoBam.out)
    runBamIndex(runSortBam.out)
}

// CLI final command to run the workflow
// nextflow run main.nf --samplesheet samplesheet.csv --fastq_dir /data/fastq_pass









