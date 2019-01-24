#!/usr/bin/perl

if (scalar(@ARGV) < 2) {
    print STDERR "Usage: $0 <chr/pos file> <window size>\n";
    exit(1);
}

$window = $ARGV[1];

open($chrfile, "<$ARGV[0]");
while (<$chrfile>) {
    chomp;
    ($chr,$beg,$end) = split(/\t/,$_,3);

    for ($i=$beg; $i<=$end; $i+=$window) {
        if ($i+$window <= $end) {
            print "sbatch --output=slurmout/slurm.fb.${chr}_$i-".($i+$window-1).".out --error=slurmout/slurm.fb.${chr}_$i-".($i+$window-1).".err fb.slurm variant/fb.${chr}_$i-".($i+$window-1).".vcf $chr:$i-".($i+$window-1)."\n";
        } else {
            print "sbatch --output=slurmout/slurm.fb.${chr}_$i-$end.out --error=slurmout/slurm.fb.${chr}_$i-$end.err fb.slurm variant/fb.${chr}_$i-$end.vcf $chr:$i-$end\n";
        }
    }
}
close($chrfile);
