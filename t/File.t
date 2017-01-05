#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use Test::More;
use File::Basename;

use Env qw($TEST_VERBOSE);

#test 1
BEGIN { use_ok('Module::Info::File'); }

my $path = 'lib/Module/Info/File.pm';
my $module = Module::Info::File->new_from_file($path);

#test 2
isa_ok($module, 'Module::Info::File');

#test 3
isa_ok($module, 'Module::Info');

#test 4
can_ok($module, qw(new_from_module new_from_loaded));

#test 4
is($module->name, 'Module::Info::File', 'Testing the name');
diag "Name = ".$module->name."\n" if $TEST_VERBOSE;

#test 5
like($module->version, qr/^\d+\.\d+$/, 'Testing the version'); 
diag "Version = ".$module->version."\n" if $TEST_VERBOSE;

#test 6
my ($name,$v,$suffix) = fileparse($path,"\.pm");
fileparse_set_fstype($^O);

like($module->file, qr/$name$suffix/, 'Testing the file');
diag "File = ".$module->file."\n" if $TEST_VERBOSE;

#test 7
like($module->inc_dir, qr/\w+/, 'Testing the dir');
diag "Dir = ".$module->inc_dir."\n" if $TEST_VERBOSE;

diag Dumper $module if $TEST_VERBOSE;

#test 8
{
    my $path = 'lib/Module/Info/File.pm';
    my @modules = Module::Info::File->new_from_file($path);

    is(scalar @modules, 1, 'Testing the count of values returned on list context');

    #test 9-12
	foreach my $m (@modules) {
		like($m->name, qr/\w+/, 'Testing the name');
		like($m->version, qr/\d+\.\d+/, 'Testing the version');
		like($m->inc_dir, qr/\w+/, 'Testing the dir');
		my ($name,$v,$suffix) = fileparse($path,"\.pm");
		fileparse_set_fstype($^O);
		like($m->file, qr/$name$suffix/, 'Testing the file');
	}

    diag Dumper \@modules if $TEST_VERBOSE;
}

{
    my $path = 't/lib/Foo.pm';
    my @modules = Module::Info::File->new_from_file($path);

    is(scalar @modules, 1, 'Testing the count of values returned on list context');

    #test 9-12
    foreach my $m (@modules) {
        like($m->name, qr/Foo/, 'Testing the name');
        like($m->version, qr/\d+\.\d+/, 'Testing the version');
        like($m->inc_dir, qr/\w+/, 'Testing the dir');
        my ($name,$v,$suffix) = fileparse($path,"\.pm");
        fileparse_set_fstype($^O);
        like($m->file, qr/$name$suffix/, 'Testing the file');
    }

    diag Dumper \@modules if $TEST_VERBOSE;
}

done_testing();
