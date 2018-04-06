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
 
package Player;
sub new {
	my $class = shift @_;
	my $name = shift @_;
	#card deck??
	my @cards = {};
	my $dead = 0;
	my $object = bless {
		"name"=>$name,
		"cards"=>\@cards,
		"dead"=>$dead,
		},$class;
	return $object;
}
sub showCards{
	my $self = shift;
	print @{$self->{cards}};

	print "\n";
}
sub getCards {
	my $self = shift;	
	#print "num of cards ",scalar(@_),"\n";
	for( my $i =0;$i<scalar(@_);$i++){
		#print "got ",$i,"\n";
		push $self->{cards}, $_[$i];			
	}
	#print "\n";
}

sub dealCards {
	my $self = shift;
	if (!$self->{cards}){
		print "$self->{name} no more cards\n";
		return 0;
	}
	return shift $self->{cards};
	print "\n";
}

sub numCards {
	my $self = shift;
	my $num=0;
	my $cards = $self->{cards};
	for my $i (@$cards){
		$num++;
	}
	return $num;
}

return 1;