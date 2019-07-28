// Initialise parameters
params.outdir = './results'

/*
 * Parse software version numbers
 */
process get_software_versions {
    publishDir "${params.outdir}/pipeline_info", mode: 'copy',
        saveAs: {filename ->
            if (filename.indexOf(".csv") > 0) filename
            else null
        }

    output:
    file 'software_versions_mqc.yaml'
    file "software_versions.csv"

    script:
    """
    echo $workflow.manifest.version > v_pipeline.txt
    echo $workflow.nextflow.version > v_nextflow.txt
    fastqc --version > v_fastqc.txt
    trim_galore --version > v_trim_galore.txt
    echo \$(bwa 2>&1) > v_bwa.txt
    samtools --version > v_samtools.txt
    bedtools --version > v_bedtools.txt
    echo \$(bamtools --version 2>&1) > v_bamtools.txt
    echo \$(plotFingerprint --version 2>&1) > v_deeptools.txt || true
    picard MarkDuplicates --version &> v_picard.txt  || true
    echo \$(R --version 2>&1) > v_R.txt
    python -c "import pysam; print(pysam.__version__)" > v_pysam.txt
    echo \$(macs2 --version 2>&1) > v_macs2.txt
    touch v_homer.txt
    echo \$(featureCounts -v 2>&1) > v_featurecounts.txt
    preseq &> v_preseq.txt
    multiqc --version > v_multiqc.txt
    scrape_software_versions.py &> software_versions_mqc.yaml
    """
}