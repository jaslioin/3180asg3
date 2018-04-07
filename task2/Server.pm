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
 
package Server;
use Gpu;
use Task;
our $gpu_num;
our $task;
our $gpu;
sub new {

	my $class = shift;
	my @gpus;
	my @waitq;
	$gpu_num= shift;
	for (my $i=0;$i<$gpu_num;$i++){
		push @gpus,Gpu->new($i);
	}
	my $object = {
		"gpus"=>\@gpus,
		"waitq"=>\@waitq,
	};
	bless $object,$class;
	return $object;
}
sub task_info {
	return "task(user: ".$task->name().", pid: ".$task->pid().", time: ".$task->time().")";
}
sub task_attr {
	return $task->name(), $task->pid(), $task->time();
}
sub gpu_info {
	return "gpu(id: ".$gpu->id().")";
}
sub submit_task {
	my $self = shift;
	my $name = shift;
	my $time = shift;
	#my $task = Task->new($name,$time);
	local $task = Task->new($name,$time);
	for my $i (@{$self->{gpus}}){
		local $gpu = $i;	
		if ($i->{state} == 0){			
			print $self->task_info()," => ",$self->gpu_info(),"\n";
			$i->assign_task($task);
			return;			
		}
	}
	#---------no empty gpu		
	push $self->{waitq},$task;
	print $self->task_info()," => waiting queue\n";
}
sub kill_task {
	my $self = shift;
	my $name = shift;
	my $pid = shift;
	for my $i (@{$self->{gpus}}){
		if ($i->{state} == 1 && $i->{task}->name() eq $name){	
			if($i->{task}->pid() == $pid){
				local $task = $i->{task};
				print "user ",$task->name()," kill ",$self->task_info(),"\n";
				$i->release();
				$self->deal_waitq();
				return;
			}							
		}
	}
	my $index=0;
	for my $i (@{$self->{waitq}}){
		if ($i->name() eq $name){	
			if($i->pid() == $pid){
				local $task = $i;
				print "user ",$task->name()," kill ",$self->task_info(),"\n";				
				splice $self->{waitq},$index,1;
				return;
			}							
		}
		$index++;
	}
	print "user liz kill task(pid: $pid) fail\n";
}
sub deal_waitq{
	my $self = shift;

	#------check if waitq not empty	
	#print "wait: ", scalar @{$self->{waitq}},"\n";
	if (scalar @{$self->{waitq}}!=0){
		#------find idle gpu
		for my $i (@{$self->{gpus}}){
			if ($i->{state} == 0){							
				local $task = $i->assign_task(shift $self->{waitq});	
				local $gpu = $i;			
				print $self->task_info()," => ",$self->gpu_info(),"\n";
			}
		}	
	}
}
sub execute_one_time {
	my $self = shift;
	print "execute_one_time..\n";
	for my $i (@{$self->{gpus}}){
		if ($i->{state} == 1){			

			$i->execute_one_time();			
			if($i->{time} == $i->{task}->{time}){

				$i->release();
				print "task in gpu(id: ",$i->id(),") finished\n";
			}
			#print "execute one task!\n";
		}

		$self->deal_waitq();
	}	
	
}
sub show {
	my $self = shift;
	print "==============Server Message================\n";
	print "gpu-id  ","state  ","user  ","pid  ","tot_time  ","cur_time","\n";

	for my $i (@{$self->{gpus}}){
		print "  ",$i->id(),"     ";
		if($i->{state} == 1){
			print "busy   ";
			local $task = $i->{task};
			printf "%-7s%-7s%-10s",$self->task_attr();
			print $i->{time},"\n";
		}else{
			print "idle\n";
		}
		
=begin		
		print "%-4s",$i->{task}->name(),"  ";
		print "%-3s",$i->{task}->pid(),"  ";
		print "%-8s",$i->{task}->time(),"  ";
=cut
		

	}
	if (scalar @{$self->{waitq}}!=0){
		for my $i (@{$self->{waitq}}){
			print "        ";
			print "wait";
			print "   ";
			printf "%-7s%-7s%-1s",$i->name(),$i->pid(),$i->time();
			print "\n";

		}
	}

	print "============================================\n";
	print "\n";
}
return 1;