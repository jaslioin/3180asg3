package WaterTypePokemon;
sub new{
	my $class = shift @_; 
	my $hp = shift @_;
	my $weight = shift @_;
 	my $object = bless {"HP" => $hp, "weight" => $weight}, $class;
	return $object; 
}
$pkm1 = WaterTypePokemon->new(80, 30);
print $pkm1->{"HP"};