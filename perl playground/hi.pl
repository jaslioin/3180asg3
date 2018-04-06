use strict;
use warnings;

package human;
sub new{
	my $class = shift @_;
	my $first_name = shift @_;
	my $last_name = shift @_;
	my $age = shift @_;
=begin
	my $object = {
		"fname"=>$first_name,
		"lname"=>$last_name,
		"age"=>$age
	};
=cut
	my $object ={
		first_name => shift @_,
		last_name => shift @_,
		age => shift @_,
	};
	bless $object ,$class;
	return $object;
}
sub bark{
	my $self = shift;
	print "bark";
}
package main;
my @arr=('1', '2', '3');

test(\@arr);

sub test
{
    my $a=$_[0];

    print "\n@$a";

}
my $jason = human->new("jason","li","2");

$jason->bark();

print 52 % 5;