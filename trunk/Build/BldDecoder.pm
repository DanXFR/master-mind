
package BldDecoder;

#==============================================================================
# Build Parameters File Decoder
# Creator: Greg Akselson, Sep 1999
# Modified last: Chris Hsiung Jun 2002
# Modified last: Jun Shih Sep 2002
#==============================================================================
#
# Purpose
#
#  This Perl module will be used to decode the info required to perform a 
#  loadbuild of WDC's CDMA software from a text file.  This info includes:
#   Environment variables, paths to software, standard flags, log output file,
#   build type (ie btsc), initialize req'd tools, debug files, <anything else?>
#
#
# Interface
#
#  ReadBLD($BldFilename, $DebugLevel)
#
#  It returns an array of build data.  All bldData Keys are present here,
#  along with a hash of the <id>'s and strings containing debug files and
#  flags separated with whitespace. The following is a table describing
#  the type and content of each part of the array:
#  position	type	content
#  --------	----	-------
#	0	hash	Build Data keys...
#	1	hash	pointer to hash keyed on <id> to commandline
#	2	string	build root directory (pls tree root)
#	3	Integer	DEBUGLevel
#
#  Also present on return is a modified environment containing all the 
#  requested envVar's, path changes, and symlinks.  The envVar's and path 
#  changes will dissapate on the calling program's termination.
#
#
# BLD Language Description
#
#  A BPF file will contain a fairly simple language.
#  Specifics:
#   -pound comments are allowed, but only at the BEGINNING of a line.
#   -white space is ignored, but type, key, value must be on the same line.
#   -keys with values wrapped in <> will be ignored (not set or used).
#    Specifically, values or keys beginning with a "<" will be ignored. No 
#    further checking is done on that line.
#   -type, key and value must be separated with colons 
#    (ie "envVar : CS_VERSION : 0008.2").  Some types are unique and therefore
#    ARE the key, but a key can still be assigned to help describe it. 
#    Type uniqueness is indicated in the table below.
#   -There are several types that are handled by the decoder:
#     *envVar - environment variable, set for the duration of the build
#     *path   - added to head of path, regardless if present or not (unique)
#     *symLink- used to create the required software tree with symlinks
#     *bldData- used by the decoder to describe the build, esp. name & log info
#     *debugLevel - sets how much diagnostic info to print (0..9)
#    -The bldData type has a few specific Key handling mechanisms, but in 
#     general is free form (just feed keys and values to it):
#     *log_location - The location to write the logfiles to. If the directory
#                     doesn't exist an attempt will be made to create it. If
#                     it doesn't have write permission it will null'd out.
#     *<anything else> - Key, Value pair is dropped into the hash untouched. 
#
#==============================================================================


#===========================================================================
# Standard Perl Libraries to Be Used


#===========================================================================
# Custom Perl Libraries to be Used

# Perl pragma to restrict unsafe constructs 
use strict;


#===========================================================================
# Function Prototypes

sub note;                       # note($string)
sub ReadBLD;                    # ReadBLD($bpfFilename,$DebugLevel)
sub SetEnvVar;                  # SetEnvVar($EnvVar, $Value)
sub UnSetEnvVar;                # UnSetEnvVar($EnvVar)
sub SetPath;                    # SetPath($tool, $path)
sub StoreBldData;               # StoreBldData ($BldData, $Value)
sub StoreCmdLineData;           # StoreCmdLineData ($BldData, $Value)


#===========================================================================
# Global Variables

# Stores the program filename without suffix
my $prog = "BldDecoder";
my $DEBUGLevel = 0;
my $linenum = 0;
my $ifCond = 1;
my $ifBit = 0x1;
my @fileHandlers; 	#A typeglob array used to save file handlers

my %compareTable;
BEGIN
{
    $compareTable{ $_} = eval "sub { \$_[ 0] $_ \$_[ 1]}" for
        qw( eq ne == != ); # add more comparison operators as needed
}


#===========================================================================
# evaluate an expr in string format and return 1 or none
sub evalExpr {
    my ( $operand1, $operator, $operand2) = split ' ', $_[ 0];
    die "Unsupported comparison: $operator" unless
	$compareTable{ $operator};
    $operand1 = &expandVar($operand1);
    $operand2 = &expandVar($operand2);
    note "$operand1:$operand2 \n";
    $compareTable{ $operator}->( $operand1, $operand2);
}

#===========================================================================
# check the if condition.
sub checkCondition {
    my $expr = shift;
    $ifCond = evalExpr($expr) if ($ifBit & 0x1);
    $ifBit = ($ifBit << 1) + $ifCond;
}

#===========================================================================
# FUNCTION:     ReadBLD($BpfFilename, $DebugLevel)
# DESCRIPTION:  Takes the BPF file, sets enviornment variables, and
#               the path.  Returns (\%BLDdata, \%CMDLines).  
#
sub ReadBLD
{
    my $BLDname    = shift;
    my $DebugLevel = shift;
    
    $BLDname = &expandVar($BLDname);
    
    # Set the debug level
    $DEBUGLevel = $DebugLevel;

    # Initialize CMD and BLD data hash tables
    my %CMDlines;
    my %BLDdata;

    # Get and open BLD file
    if (defined($BLDname)) 
    {
        open (BLD, $BLDname) or die "BLD parser: Critical failure: BLD 
        file \"$BLDname\" not found!!\nEnsure you gave a file to parse\n\n";
    } 
    else 
    {
        die "BLD parser: Critical failure:  BLD file not found!!\n
        Ensure you gave a file to parse\n\n";
    }

    note "Working with BLD file : $BLDname";


    # Parse the bpf makefile line by line
    while (<BLD>) 
    {
        # Increment line number of BLD file.
        ++$linenum;

        # ignore comments and blank lines
        if (/^\s*#/ || /^\s*$/) 
        { 
            next; 
        }
	
        # Look for bad line types.  All lines should start with a # or have a :
        if (! /:/) 
        { 
            die "BLD Decoder: Critical Error!\n** Line $linenum is 
            incorrectly formatted!!\n** See the BLD guide for 
            formatting instructions\n\n"; 
        }  

  
        # Take line in BPF file and split data into tokens in the array
        my $bpfline = $_;
        chomp $bpfline;
        my @data = split /\s*:\s*/, $bpfline;

        # For each token, store in the $Type, $Key and $Value variable
        # First token contains Type
        my $Type = $data[0];
	$Type =~ s/^ *//g;
        my $Key;
        my $Value;

        # Second token contains Key
        if (defined $data[1]) 
        {
            $Key = $data[1];
        } 
        else 
        {
            $Key = "";
        } 

        # Third token contains Value
        if (defined $data[2]) 
        {
            $Value = $data[2];
        } 
        else 
        {
            $Value = "";
        }
        
        # Any additional tokens are joined with Value
        if (defined $data[3]) 
        {
            $Value = join ':', $Value, @data[3 .. $#data]; 
        }

        # If $Key or $Value begins with an angle bracket (<) then skip
        if ($Value =~ /^</) 
        { 
            print "BPF decoder: Warning!\n** Line $linenum, Key \"$Key\" has 
            no value.\n\n"; 
            next;
        }
        if ($Key   =~ /^</) 
        { 
            print "BPF decoder: Warning!\n** Line $linenum, 
            Type \"$data[0]\" has no Key or Value.\n\n"; 
            next;
        }

	if (!$ifCond && ($Type ne "endif") && ($Type ne "if")){
	   next;
	}

        # Depending on the $Key, set the appropriate value.
        SWITCH: 
        {
            # Set the environment variable
            if ($Type eq "envVar") 
            { 
                SetEnvVar($Key, $Value);
                last SWITCH; 
            }

            # Set the environment variable (same as envVar)
            if ($Type eq "setenv") 
            { 
                SetEnvVar($Key, $Value);
                last SWITCH; 
            }
            
            # Undefine the environment variable
            if ($Type eq "unsetenv") 
            { 
                UnSetEnvVar($Key);
                last SWITCH; 
            }

            # Sym links not implemented yet
            if ($Type eq "symLink") 
            { 
                note "Creating of sym links not implemented."; 
                last SWITCH; 
            }
            
            # Set the path in the environment
            if ($Type eq "path") 
            { 
                SetPath($Key, $Value); 
                last SWITCH; 
            }

            # Store bldData in an array for return            
            if ($Type eq "bldData") 
            { 
                StoreBldData($Key, $Value, \%BLDdata);
                last SWITCH; 
            }

            # Store command line data for return
            if ($Type eq "cmdLineData") 
            {
                StoreCmdLineData($Key, $Value, \%CMDlines);
                last SWITCH; 
            }
            
	    # read another bpf file
	    if ($Type eq "include"){
	        #Dup the filehandler
	        local *SAVEHDR;
		open SAVEHDR, "<&BLD";
		
		#Save the duplicated file handler in a typeglob array 
		push @fileHandlers, *SAVEHDR;
		
		ReadBLD($Key, $DebugLevel);
		
		#recover the filehandle
	        *BPF = pop @fileHandlers;
		
		last SWITCH;
	    }

	    # if condition
	    if ($Type eq "if"){
		checkCondition($Key);
		note "if:$ifCond\n";
		last SWITCH;
	    }

	    # if condition
	    if ($Type eq "endif"){
		note "endif:$ifCond\n";	    
	        $ifBit >>= 1;
		$ifCond = $ifBit & 0x1;
		last SWITCH;
	    }

	    # echo
	    if ($Type eq "echo"){
		print "$Key\n";
		last SWITCH;
	    }

	    # echo
	    if ($Type eq "exit"){
		exit($Key);
		last SWITCH;
	    }

            # Default SWITCH rule
            warn "Line $linenum contains an unknown type.
            \n Valid types are: envVar, symLink, path, bldData";

        } #end of SWITCH

    } # end of while (<BLD>)

    # Returns bldData and cmdLines as an array
    return (\%BLDdata, \%CMDlines);

} #end ReadBPF sub...

sub expandVar{
    my $value = shift;

    if ($value =~ /[\$\`]/){
	$value = `echo $value`;
    }

    chomp($value);
    return $value;
}

#===========================================================================
# FUNCTION:     SetEnvVar($EnvVar, $Value)
# DESCRIPTION:  Sets $EnvVar to $Value in the environment.
#
sub SetEnvVar  {
    my $EnvVar = shift;
    my $Value = shift;

    note "Setting environment variables."; 
    
    if ($EnvVar eq "") 
    { 
        die "BPF decoder: Fatal Error!!\n** Line $linenum, 
        Environment variable needs a name!\n** Line $linenum 
        contains a type \"$EnvVar\" with no key name!!\n"; 
    }
    
    if ($Value eq "") 
    { 
        print "BPF decoder: Warning!!\n** Setting environment 
        variable \"$EnvVar\" to <NULL> (nothing)\n\n"; 
    }

    if ($ENV{$EnvVar} eq $EnvVar) 
    { 
        print "BPF decoder: Warning!!\n** Environment variable 
        \"$EnvVar\" is currently set to \"$ENV{$EnvVar}\"\n** This will 
        be overwritten with \"$Value\" for the duration of the build!!\n\n"; 
    }

    # Set environment variable "key" to "value".
    $ENV{$EnvVar} = &expandVar($Value);
    note "$EnvVar set to $ENV{$EnvVar}\n";
}


#===========================================================================
# FUNCTION:     UnSetEnvVar($EnvVar)
# DESCRIPTION:  Sets $EnvVar to $Value in the environment.
#
sub UnSetEnvVar  {
    my $EnvVar = shift;
    my $Value = shift;

    note "Unsetting environment variables."; 
    
    if ($EnvVar eq "") 
    { 
        die "BPF decoder: Fatal Error!!\n** Line $linenum, 
        Environment variable needs a name!\n** Line $linenum 
        contains a type \"$EnvVar\" with no key name!!\n"; 
    }
    

    if ($ENV{$EnvVar} eq $EnvVar) 
    { 
        print "BPF decoder: Warning!!\n** Environment variable 
        \"$EnvVar\" is currently set to \"$ENV{$EnvVar}\"\n
        ** This will be undefined for the duration of the build!!\n\n"; 
    }

    # Unset environment variable "key".
    $ENV{$EnvVar} = &expandVar($Value);
    note "$EnvVar undefined\n";
}

#===========================================================================
# FUNCTION:     SetPath($Tool, $Path)
# DESCRIPTION:  Adds $Path to the beginning of PATH env variable.
#
sub SetPath {
    my $tool = shift;
    my $path = shift;

    # Prepend the value to the path.
    note "SetPath";
    note "PATH before: $ENV{PATH}";

    if ($path ne "")  
    {
        note "Adding path element \"$path\" for tool \"$tool\""; 
	$path = &expandVar($path);
        $ENV{PATH} = "$path:$ENV{PATH}";
    } 
    elsif ($tool ne "") 
    {
	$path = &expandVar($tool);
        note "Adding path element \"$path\""; 
        $ENV{PATH} = "$path:$ENV{PATH}";
    } 
    else 
    {
        note "BPF decoder: Warning!\n** Line $linenum, Null path 
        value detected, Line ignored.";
    }
    
    note "PATH after : $ENV{PATH}";
}



#===========================================================================
# FUNCTION:     StoreBldData($Key, $Value, \%BldDataHashRef)
# DESCRIPTION:  Adds $Key and $Value to the BldData hash table
#
sub StoreBldData {
    my $Key = shift;
    my $Value = shift;
    my $BldDataHashRef = shift;

    note "Bld Decoder: BUILDdata";
    note "** Adding \"$Key, $Value\" pair to build data hash"; 
    ${$BldDataHashRef}{$Key} = $Value;
}


#===========================================================================
# FUNCTION:     StoreCmdLineData($Key, $Value, \%CmdLineDataHashRef)
# DESCRIPTION:  Adds $Key and $Value to the BldData hash table
#
sub StoreCmdLineData
{
    my $Key                = shift;
    my $Value              = shift;
    my $CmdLineDataHashRef = shift;

    note "BPF decoder: BUILDdata";
    note "** Adding \"$Key, $Value\" pair to build data hash";

    ${$CmdLineDataHashRef}{$Key} = $Value;
}


#===========================================================================
# FUNCTION:     note($string)
# DESCRIPTION:  Prints message if verbose option has been set.

sub note
{
    print STDERR "$prog\@$linenum: @_\n" if $DEBUGLevel > 1;
}


1; # Package always returns positive result

