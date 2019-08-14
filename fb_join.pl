#!/usr/bin/perl

$OUTDIR="variant";

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
            $fn = "$OUTDIR/fb.${chr}_$i-".($i+$window-1).".vcf";
            if (! -e $fn || -z $fn) {
                print STDERR "ERROR: $fn does not exist or is zero size.\n";
                $flag=1;
            }
        } else {
            $fn = "$OUTDIR/fb.${chr}_$i-$end.vcf";
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
                print "grep ^# variant/fb.${chr}_$i-".($i+$window-1).".vcf > combined/$chr.ALL.vcf\ncat ";
                $flag = 1;
            }
            print "variant/fb.${chr}_$i-".($i+$window-1).".vcf ";
        } else {
            if ($flag==0) {
                print "grep ^# variant/fb.${chr}_$i-$end.vcf > combined/$chr.ALL.vcf\ncat ";
                $flag = 1;
            }
            print "variant/fb.${chr}_$i-$end.vcf ";
        }
    }

    print "| grep -v ^# >> combined/$chr.ALL.vcf\n";
}
close($chrfile);
