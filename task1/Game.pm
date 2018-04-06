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
	my $deck = MannerDeckStudent->new();
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
	my $self = shift @_;
	#my $names = $_[0];
	my $names = shift @_;
	my $count=0;
	for my $i (@$names){
		#print "$i\n";	
		my $playerobj = Player->new($i);
		
		push $self->{players},$playerobj;
		#print $self->{players}[$count + 1]->{name};
		#print "\n";
		#print "$count ++\n";
		$count +=1;	
	}
	#---------delete first meaningless element--------	
	shift $self->{players};

	#print @{$self->{players}};	
	#---------check if num of players is available	
	if (52 % $count == 0){
		print "There $count players in the game:\n";
		for my $i (@$names){
			print $i," ";
		}
		print "\n";	
		print "\n";	
		return 1;	
	}else{
		print "Error: cards' number 52 can not be divided by players number $count!\n";
		return 0;
	}
}

sub getReturn {
	my $self = shift;

#-----find identical card
	#-----if not the stack is not empty before deal
	if (scalar(@{$self->{cards}}) > 1){
		for(my $i =scalar(@{$self->{cards}})-2;$i>=0;$i--){
			$_[0]++;									
			if ($self->{cards}[$i] eq $_[2]){
				$_[1]=1;
				last;
			}
			if ($_[2] eq "J" && scalar(@{$self->{cards}}) !=0){															
				$_[1] =1;
				$_[0] = scalar(@{$self->{cards}});
				last;
			}								
		}
	}
}

sub showCards {
	#print "showCards!\n";	
	my $self = shift;
	my $cards = $self->{cards};
	
	#print @{$self->{cards}},"\n";
	print join " ", @{$self->{"cards"}};
=begin	
	for my $i (@$cards){
		print $i;
	}
=cut

	print "\n";
}

sub start_game {
	print "Game begin!!!\n";		
	my $self = shift;
	#$self->{deck}->showCards();
	#-------------shuffle the deck----------
	$self->{deck}->shuffle();
	#print "shuffled !\n";
	#$self->{deck}->showCards();
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
	#my $testcount=0;
	my $gameturn=1;
	my $winner;
	while(1){
		
=begin		
		if ($testcount == 100){
			last;
		}	
=cut
		#print "#####turn ",$turn,"\n";		
		#---------check if the player already losed
		#print $self->{players}[$turn]->{name}," has ",scalar(@{$self->{players}[$turn]->{cards}})," cards\n";
		if (scalar(@{$self->{players}[$turn]->{cards}}) == 0){
			$turn++;
			#print "player ",$self->{players}[$turn]->{name},"has no cards, out!\n";
			if ($turn > scalar(@{$self->{players}})-1){
			#	print "turn reset\n";
				$gameturn ++;
				$turn = 0;
			}
			next;
		}
		print "\n";
			
		print "Player ",$self->{players}[$turn]->{name}," has ",scalar(@{$self->{players}[$turn]->{cards}}) ," cards before deal.\n";
		#$self->{players}[$turn]->showCards();			
		print "=====Before player's deal=======\n";
		$self->showCards();
		print "================================\n";
		
		#---------player deal card
		my $dealtCard = $self->{players}[$turn]->dealCards();
		my $token =0;
		my $index;
		my @returncards;
		my $numtopop=1;#include the dealtcard
		
		if ($dealtCard){			
			print $self->{players}[$turn]->{name}," ==> card ", $dealtCard,"\n";			
			push $self->{cards}, $dealtCard;		
			
			#cal how many to return to player
			$self->getReturn($numtopop,$token,$dealtCard);
			
			#-----pop the card stack and push into returncards
			if ($token == 1){
				#print "num of cards to pop ",$numtopop,"\n";
				for(my $i =0;$i<$numtopop;$i++){
					push @returncards ,pop $self->{cards};								
				}
				#print "returncards: ",@returncards;
				$self->{players}[$turn]->getCards(@returncards);
			}
			print "=====After player's deal=======\n";
			$self->showCards();
			print "================================\n";
			
=begin			
239547396JJK8274106K8Q105QAA
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
			print "Player ",$self->{players}[$turn]->{name}," has ",scalar(@{$self->{players}[$turn]->{cards}}) ," cards after deal.\n";
			
			#$self->{players}[$turn]->showCards();			
			#-----clean card stack
=begin			
			for(my $i =scalar(@{$self->{cards}})-1;$i>=0;$i--){
				pop $self->{cards};
				if ($i == $index){
					last;
				}
			}
=cut
		}

		#---------check win
		my $alive=0;
		$countie = 0;
		for my $i (@{$self->{players}}){
			#print " check win ",scalar(@{$self->{players}[$countie]->{cards}}),"\n";
			if (scalar(@{$self->{players}[$countie]->{cards}}) > 0){
				$alive++;
				$winner = $countie;
			}else{
				if($self->{players}[$countie]->{dead} == 0)
				{
					print "Player ",$self->{players}[$countie]->{name}," has no cards, out!\n";
					$self->{players}[$countie]->{dead} = 1;		
				}
				
			}
			$countie++;
		}
		if ($alive == 1 ){		
			last;
		}
		#---------next player's turn
		$turn++;
		#$testcount++;
		#---------reset turn when all players had their move
		#print "turnmax: ",scalar(@{$self->{players}})-1,"\n";
		if ($turn > scalar(@{$self->{players}})-1){
		#	print "turn reset\n";
			$gameturn ++;
			$turn = 0;
		}
	}

	print "\n";
	print "Winner is ",$self->{players}[$winner]->{name}," in game ",$gameturn,"\n";
	print "\n";

}

return 1;
