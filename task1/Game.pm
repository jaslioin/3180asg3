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

package Game;
use MannerDeckStudent; 
use Player;
use Deck;
sub new {
	my $class = shift @_;
	my $deck = Deck->new();
	my @players = {};
	my @cards;
	
	my $object = {
		"cards" => \@cards,
		"players" => \@players,
		"deck" => $deck,
		
	};
	bless $object , $class;
	return $object;
}

sub set_players {
	print "set_players!\n";
	my $self = shift @_;
	#my $names = $_[0];
	my $names = shift @_;
	my $count=0;
	for my $i (@$names){
		#print "$i\n";	
		my $playerobj = Player->new($i);
		print $playerobj->{name};
		push $self->{players},$playerobj;
		#print $self->{players}[$count + 1]->{name};
		print "\n";
		#print "$count ++\n";
		$count +=1;	
	}
	#---------delete first meaningless element--------	
	shift $self->{players};
	#print @{$self->{players}};	
	#---------check if num of players is available	
	if (52 % $count == 0){
		
		return 1;	
	}else{
		print "52 not 1divisible by $count\n";
		return 0;
	}
}

sub getReturn {
	print "getReturn!\n";
}

sub showCards {
	print "showCards!\n";	
	my $self = shift;
	#my $cards = $self->{cards};
	print @{$self->{cards}},"\n";
}

sub start_game {
	print "start_game!\n";		
	my $self = shift;
	#$self->{deck}->showCards();
	#-------------shuffle the deck----------
	$self->{deck}->shuffle();
	print "shuffled !\n";
	$self->{deck}->showCards();
	#-------------divide the cards to players	
	#print "num of players: ",scalar(@{$self->{players}}),"\n";
	my @num = $self->{deck}->AveDealCards(scalar(@{$self->{players}}));	
	my $playercounter=0;
	#print scalar(@{$num[0]});
	#print @{$num[0]},"\n";
	#print @{$num[1]},"\n";
	for (my $i =0;$i<scalar(@{$self->{players}});$i++){
		#print @{$num[$i]},"\n";
		$self->{players}[$i]->getCards(@{$num[$i]});
	}
	#------------delete the first meaningless element in the card array;
	my $countie = 0;
	for my $i (@{$self->{players}}){
		shift $self->{players}[$countie]->{cards};
		$countie++;
	}
	#-----------while game not end
	my $turn=0;
	my $testcount=0;
	while(1){
		if ($testcount == 4){
			last;
		}				
		print "#####turn ",$turn,"\n";		
		#---------check if the player already losed
		if (scalar(@{$self->{players}[$turn]->{cards}}) == 0){
			$turn++;
			next;
		}
		#---------display the stack now
		$self->showCards();
		#---------player deal card
		my $dealtCard = $self->{players}[$turn]->dealCards();
		my $token =0;
		my $index;
		my @returncards;
		my $numtopop=1;#include the dealtcard
		if ($dealtCard){			
			print "player ",$self->{players}[$turn]->{name}," dealt", $dealtCard,"\n";			
			push $self->{cards}, $dealtCard;			
			$self->showCards();
			#-----find identical card 
			for(my $i =scalar(@{$self->{cards}})-2;$i>=0;$i--){
				$numtopop++;
				if ($self->{cards}[$i] eq $dealtCard){
					$token=1;
					last;
				}
				if ($dealtCard eq "J" && scalar(@{$self->{cards}}) !=0){															
					$token =1;
					$numtopop = scalar(@{$self->{cards}});
					last;
				}								
			}
			#-----pop the card stack and push into returncards
			if ($token == 1){
				print "num of cards to pop ",$numtopop,"\n";
				for(my $i =0;$i<$numtopop;$i++){
					push @returncards ,pop $self->{cards};				
				}

			}
			
=begin			
			for(my $i =0;$i<scalar(@{$self->{cards}});$i++){
				if ($token==1){
					push @returncards, $self->{cards}[$i];
				}else {
					if ($self->{cards}[$i] == $dealtCard){
						push @returncards, $self->{cards}[$i];
						$index = $i;
						$token =1;					
					}
					if ($dealtCard == "J" && scalar(@{$self->{cards}}) !=0){
						push @returncards, $self->{cards}[$i];
						$index = $i;
						$token =1;
					}
				}
			}
=cut			
			$self->{players}[$turn]->getCards(@returncards);
			print "player ",$self->{players}[$turn]->{name}," cards: ",$self->{players}[$turn]->showCards() ,"\n";			
			#-----clean card stack
=begin			
			for(my $i =scalar(@{$self->{cards}})-1;$i>=0;$i--){
				pop $self->{cards};
				if ($i == $index){
					last;
				}
			}
=cut
		}else{
			print "this player already losed!\n";
		}

		#---------check win
		my $alive=0;
		for my $i (@{$self->{players}}){
			if (scalar(@{$self->{players}[$turn]->{cards}}) != 0){
				$alive++;
			}
		}
		if ($alive == 1 ){
			print "we have winner yay\n";
			last;
		}
		#---------next player's turn
		$turn++;
		$testcount++;
		#---------reset turn when all players had their move
		print "turnmax: ",scalar(@{$self->{players}})-1,"\n";
		if ($turn > scalar(@{$self->{players}})-1){
			print "turn reset\n";
			$turn = 0;
		}
	}


	print "GAME END!\n";
}

return 1;
