#!/bin/bash
# Runs bcftools query to make a SNP matrix

script=$(basename $0);
while getopts "o:" o; do
  case "${o}" in
    o)
      OUT="$OPTARG"
      ;;
    *)
      echo "ERROR: I do not understand option $OPTARG"
      ;;
  esac
done
shift $(($OPTIND-1)) # remove the flag arguments from ARGV

IN=$1

if [ "$OUT" == "" ] || [ "$IN" == "" ]; then
  echo "$script: generates a SNP matrix using BCFtools and a pooled VCF file"
  echo "USAGE: $script -o bcfmatrix.tsv pooled.vcf.gz"
  exit 1;
fi


command="bcftools query -i '%TYPE=\"snp\"' -f '%CHROM\\t%POS\\t%REF\\t[%TGT\\t]\\n' --print-header $IN > $OUT.tmp && mv -v $OUT.tmp $OUT"
eval $command
if [ $? -gt 0 ]; then
  echo -e "ERROR with bcftools:\n  $command";
  exit 1
fi

