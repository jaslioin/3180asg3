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

package Gpu;
use Task;
sub new {
	my $class = shift;
	my $time=0;
	my $state=0;
	my $task;
	my $id = shift;
	my $object ={
		"id" =>$id,
		"state" =>$state,
		"task" =>$task,
		"time" =>$time,
	};
	
	
	bless $object,$class;
	return $object;
}
sub assign_task {
	my $self = shift;
	my $task = shift;
	$self->{task}= $task;
	$self->{state}=1;
	#print "assign_task!\n";
	$self->{time}=0;
	return $task;
}
sub release {
	my $self = shift;
	$self->{task}={};
	$self->{state}=0;
	$self->{time}=0;

}
sub execute_one_time {
	my $self = shift;
	$self->{time} += 1;
}
sub id{
	my $self = shift;
	return $self->{id};
}

return 1;
