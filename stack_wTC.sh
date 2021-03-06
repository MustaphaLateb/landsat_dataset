#!/bin/bash
#$ -l h_rt=24:00:00
#$ -V
#$ -N landsat_stack_wTC
#$ -j y

module load batch_landsat

if [ -z "$1" ]; then
    echo "Error - please specify a directory with extracted Landsat archives. Usage:"
    echo "    $0 <directory>"
    exit 1
fi

here=$1

cd $here

stack="L*stack"
TC="L*BGW.tif"

mtl=$(find ./ -name 'L*MTL.txt' | head -1)
utm=$(grep "UTM_ZONE" $mtl | tr -d ' ' | awk -F '=' '{ print $2 }')

landsat_stack.py -q -p --files "$stack; $TC; $stack" \
    -b "1 2 3 4 5 6 7; 1 2 3; 8" \
    -n "-9999 -9999 -9999 -9999 -9999 -9999 -9999; -9999 -9999 -9999; 1" \
    --utm $utm -o "*_all" \
    --format "ENVI" --co "INTERLEAVE=BIP" --max_extent ./


