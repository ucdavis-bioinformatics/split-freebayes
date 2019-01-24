#!/bin/bash
#
#SBATCH --job-name=freebayes # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=1 # Number of cores
#SBATCH --mem=128000 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --time=2-0
#SBATCH --partition=production

start=`date +%s`

hostname

module load freebayes/1.1.0

GENOME="/share/biocore/projects/Bannasch_D_UCDVM/2018_March_Canine_WGS/ref/genome.fa"
BAMLIST="/share/biocore/projects/Bannasch_D_UCDVM/2018_March_Canine_WGS/03-Align-100-dogs/bamlist.txt"

call="freebayes \
  --bam-list $BAMLIST \
  --fasta-reference $GENOME \
  --vcf  $1 \
  --region $2 \
  --ploidy 2 \
  --use-best-n-alleles 6 \
  --max-complex-gap 75 \
  --min-mapping-quality 30 \
  --min-base-quality 20 \
  --min-supporting-allele-qsum 0 \
  --genotype-variant-threshold 0"

echo $call
eval $call

end=`date +%s`

runtime=$((end-start))

echo $runtime
