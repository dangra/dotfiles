#!/usr/bin/perl -w
use strict;

my @message=map hex($_),@ARGV;
my $crc = crc16(@message);
push @message,lsb($crc),msb($crc);
showtrame(@message);

sub crc16 {
    my @trame=@_;
    my ($crc,$poly)=(0xFFFF,0xA001);
    foreach my $byte (@trame){
        $crc^=$byte&0xFF;
        for(my $i=0;$i<8;$i++){
            my $carry=$crc&0x01;
            $crc>>=1;
            $crc^=$poly if $carry;
        }
    }
    return $crc;
}
sub lsb { 
    return (shift()&0xFF); 
}
sub msb { 
    return ((shift()>>8)&0xFF); 
}
sub showtrame {
    print join(' ',map(sprintf("%02X",$_),@_))."\n";
}
