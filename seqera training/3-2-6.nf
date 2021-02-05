reads = Channel
    .fromFilePairs('data/ggal/*_{1,2}.fq')
    .view()
process fastqc{
   publishDir "/home/davimarcon/github/Nextflow/seqera training/3-2-6/output_log/", mode: 'copy'

   input:
   tuple sample_id, file(reads_file) from reads

   output:
   file("fastqc_${sample_id}_logs") into fastqc_ch



   script:
   """
   mkdir fastqc_${sample_id}_logs
   fastqc -o fastqc_${sample_id}_logs -f fastq -q ${reads_file}

   """
}
