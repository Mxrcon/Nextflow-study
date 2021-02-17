#!/usr/bin/env nextflow

// Default location: /home/davimarcon/github/Nextflow/seqera training/

loc = "/home/davimarcon/github/Nextflow/seqera training/rna-seq/"

   params.reads = "$baseDir/${params.rp}/*_{1,2}.fq"
   params.transcriptome = "$baseDir/ggal/transcriptome.fa"
   params.outdir = "${params.o}"
//log info
log.info """\
            ===================================
            DAVI ESTÁ APRENDENDO NEXTFLOW :)
            ===================================
            transcriptome: ${params.transcriptome}
            reads        : ${params.reads}
            outdir       : ${params.outdir}
            """
            .stripIndent()
process index {
   input:
   path transcriptome from params.transcriptome
   output:
   path 'index' into index_channel
   script:
    """
    salmon index --threads $task.cpus -t $transcriptome -i index
    """

}


Channel
   .fromFilePairs(params.reads,checkIfExists: true )
   .into{ read_pairs_ch; read_pairs2_ch}

process quantification {
      tag "$pair_id"
      publishDir "${params.outdir}"
      input:
      path index from index_channel
      tuple pair_id, path(reads) from read_pairs_ch
      output:
      path pair_id into quant_ch
      script:
      """
      salmon quant --threads $task.cpus --libType=U -i $index -1 ${reads[0]} -2 ${reads[1]} -o $pair_id
      """
  }
  process fastqc {
       tag "FASTQC on $sample_id"
       publishDir "${params.outdir}/fastqc/"
       input:
       tuple sample_id, path(reads) from read_pairs2_ch

       output:
       path "fastqc_${sample_id}_logs" into fastqc_ch
       script:
       """
       mkdir fastqc_${sample_id}_logs
       fastqc -o fastqc_${sample_id}_logs -f fastq -q ${reads}
       """
   }
   process multiqc {
     publishDir params.outdir, mode:'copy'

     input:
     path '*' from quant_ch.mix(fastqc_ch).collect()

     output:
     path 'multiqc_report.html'

     script:
     """
     multiqc .
     """
 }
 workflow.onComplete {
   log.info ( workflow.success ? "\nParabéns davi você chegou ao final  do tutorial\n" : "Davi você está fazendo alguma coisa errada" )    }
