use strict;
use warnings;

package GoldenHookFishing;
use Game;
use Player;

my $game = Game->new();
if ($game->set_players(['lin', 'liz'])) {
	$game->start_game();	
	


#----------remaining cards after game end
	$game->{players}[0]->showCards();	
	$game->{players}[1]->showCards();		
}else{
	print "No Game";
}
#$game->{players}[1]->getCards(["3","5"]);
#$game->{players}[1]->showCards();
#$game->{players}[1]->dealCards();
#print $game->{players}[1]->numCards();;