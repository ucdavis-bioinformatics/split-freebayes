#!/usr/bin/perl

$INDIR="variant";
$OUTDIR="combined";

if (scalar(@ARGV) < 2) {
    print STDERR "Usage: $0 <chr/pos file> <window size>\n";
    exit(1);
}

$window = $ARGV[1];

$flag=0;
open($chrfile, "<$ARGV[0]");
while (<$chrfile>) {
    chomp;
    ($chr,$beg,$end) = split(/\t/,$_,3);

    for ($i=$beg; $i<=$end; $i+=$window) {
        if ($i+$window <= $end) {
            $fn = "$INDIR/fb.${chr}_$i-".($i+$window-1).".vcf";
            if (! -e $fn || -z $fn) {
                print STDERR "ERROR: $fn does not exist or is zero size.\n";
                $flag=1;
            }
        } else {
            $fn = "$INDIR/fb.${chr}_$i-$end.vcf";
            if (! -e $fn || -z $fn) {
                print STDERR "ERROR: $fn does not exist or is zero size.\n";
                $flag=1;
            }
        }
    }
}
close($chrfile);

if ($flag == 1) {
    print STDERR "Errors found... Exiting.\n";
    exit(1)
}


open($chrfile, "<$ARGV[0]");
while (<$chrfile>) {
    chomp;
    ($chr,$beg,$end) = split(/\t/,$_,3);

    $flag=0;
    print "echo $chr\n";
    for ($i=$beg; $i<=$end; $i+=$window) {
        if ($i+$window <= $end) {
            if ($flag==0) {
                print "grep ^# $INDIR/fb.${chr}_$i-".($i+$window-1).".vcf > $OUTDIR/$chr.ALL.vcf\ncat ";
                $flag = 1;
            }
            print "$INDIR/fb.${chr}_$i-".($i+$window-1).".vcf ";
        } else {
            if ($flag==0) {
                print "grep ^# $INDIR/fb.${chr}_$i-$end.vcf > $OUTDIR/$chr.ALL.vcf\ncat ";
                $flag = 1;
            }
            print "$INDIR/fb.${chr}_$i-$end.vcf ";
        }
    }

    print "| grep -v ^# >> $OUTDIR/$chr.ALL.vcf\n";
}
close($chrfile);
