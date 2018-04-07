 #
 # CSCI3180 Principles of Programming Languages
 #
 # --- Declaration ---
 #
 # I declare that the assignment here submitted is original except for source
 # material explicitly acknowledged. I also acknowledge that I am aware of
 # University policy and regulations on honesty in academic work, and of the
 # disciplinary guidelines and procedures applicable to breaches of such policy
 # and regulations, as contained in the website
 # http://www.cuhk.edu.hk/policy/academichonesty/
 #
 # Assignment 3
 # Name : Li Ho Yin
 # Student ID : 1155077785
 # Email Addr : hyli6@cse.cuhk.edu.hk
 #
use strict;
use warnings;

package Task;
our $pidcounter=0;
sub new {
	my $class = shift;
	my $pid = $pidcounter;;
	my $name = shift;
	my $time = shift;
	my $object = bless {
		"pid"=>$pid,
		"name"=>$name,
		"time"=>$time
	},$class;
	
	$pidcounter ++;
	return $object;


}
sub pid{
	my $self = shift;
	return $self->{pid};
}
sub name{
	my $self = shift;
	return $self->{name};
}
sub time{
	my $self = shift;
	return $self->{time};
}
return 1;