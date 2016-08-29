use strict;
use warnings;
use File::Find;
my @file_list;
main (@ARGV);

sub main{
  my $match_count = 0;
  my $mismatch_count = 0;
  find(\&wanted, $ARGV[0]);
  foreach my $f_name(@file_list){
    if(open(my $f_h, $f_name)){
      while(my $row = <$f_h>) {
	if($row =~ /Total\s+CMPL\s+Packets\s+Expected::\(\s*([0-9]+)\s*\),Rcvd::\(\s*([0-9]+)/){
	  if($1 != $2){
	    $mismatch_count = $mismatch_count +1;
	    print "'Mismatching in $f_name \nExpected CMPL = $1\tReceived CMPL is $2\n";
	  } else {
	    $match_count = $match_count +1;
	  }
	}
	
      }
    } else {
      warn "can't open $f_name$!";
    }
  }
  print "match_count is $match_count\n";
  print "mismatch_count is $mismatch_count\n";
}

sub wanted{
  return unless -f;
  return unless /vcs.log$/;
  push @file_list, $File::Find::name;
}


