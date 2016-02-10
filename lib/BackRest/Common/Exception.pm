####################################################################################################################################
# COMMON EXCEPTION MODULE
####################################################################################################################################
package BackRest::Common::Exception;

use strict;
use warnings FATAL => qw(all);
use Carp qw(confess longmess);

use Exporter qw(import);
    our @EXPORT = qw();

####################################################################################################################################
# Exception codes
####################################################################################################################################
use constant ERROR_MINIMUM                                          => 100;
    push @EXPORT, qw(ERROR_MINIMUM);
use constant ERROR_MAXIMUM                                          => 199;
    push @EXPORT, qw(ERROR_MAXIMUM);

use constant ERROR_ASSERT                                           => ERROR_MINIMUM;
    push @EXPORT, qw(ERROR_ASSERT);
use constant ERROR_CHECKSUM                                         => ERROR_MINIMUM + 1;
    push @EXPORT, qw(ERROR_CHECKSUM);
use constant ERROR_CONFIG                                           => ERROR_MINIMUM + 2;
    push @EXPORT, qw(ERROR_CONFIG);
use constant ERROR_FILE_INVALID                                     => ERROR_MINIMUM + 3;
    push @EXPORT, qw(ERROR_FILE_INVALID);
use constant ERROR_FORMAT                                           => ERROR_MINIMUM + 4;
    push @EXPORT, qw(ERROR_FORMAT);
use constant ERROR_COMMAND_REQUIRED                                 => ERROR_MINIMUM + 5;
    push @EXPORT, qw(ERROR_COMMAND_REQUIRED);
use constant ERROR_OPTION_INVALID                                   => ERROR_MINIMUM + 6;
    push @EXPORT, qw(ERROR_OPTION_INVALID);
use constant ERROR_OPTION_INVALID_VALUE                             => ERROR_MINIMUM + 7;
    push @EXPORT, qw(ERROR_OPTION_INVALID_VALUE);
use constant ERROR_OPTION_INVALID_RANGE                             => ERROR_MINIMUM + 8;
    push @EXPORT, qw(ERROR_OPTION_INVALID_RANGE);
use constant ERROR_OPTION_INVALID_PAIR                              => ERROR_MINIMUM + 9;
    push @EXPORT, qw(ERROR_OPTION_INVALID_PAIR);
use constant ERROR_OPTION_DUPLICATE_KEY                             => ERROR_MINIMUM + 10;
    push @EXPORT, qw(ERROR_OPTION_DUPLICATE_KEY);
use constant ERROR_OPTION_NEGATE                                    => ERROR_MINIMUM + 11;
    push @EXPORT, qw(ERROR_OPTION_NEGATE);
use constant ERROR_OPTION_REQUIRED                                  => ERROR_MINIMUM + 12;
    push @EXPORT, qw(ERROR_OPTION_REQUIRED);
use constant ERROR_POSTMASTER_RUNNING                               => ERROR_MINIMUM + 13;
    push @EXPORT, qw(ERROR_POSTMASTER_RUNNING);
use constant ERROR_PROTOCOL                                         => ERROR_MINIMUM + 14;
    push @EXPORT, qw(ERROR_PROTOCOL);
use constant ERROR_RESTORE_PATH_NOT_EMPTY                           => ERROR_MINIMUM + 15;
    push @EXPORT, qw(ERROR_RESTORE_PATH_NOT_EMPTY);
use constant ERROR_FILE_OPEN                                        => ERROR_MINIMUM + 16;
    push @EXPORT, qw(ERROR_FILE_OPEN);
use constant ERROR_FILE_READ                                        => ERROR_MINIMUM + 17;
    push @EXPORT, qw(ERROR_FILE_READ);
use constant ERROR_PARAM_REQUIRED                                   => ERROR_MINIMUM + 18;
    push @EXPORT, qw(ERROR_PARAM_REQUIRED);
use constant ERROR_ARCHIVE_MISMATCH                                 => ERROR_MINIMUM + 19;
    push @EXPORT, qw(ERROR_ARCHIVE_MISMATCH);
use constant ERROR_ARCHIVE_DUPLICATE                                => ERROR_MINIMUM + 20;
    push @EXPORT, qw(ERROR_ARCHIVE_DUPLICATE);
use constant ERROR_VERSION_NOT_SUPPORTED                            => ERROR_MINIMUM + 21;
    push @EXPORT, qw(ERROR_VERSION_NOT_SUPPORTED);
use constant ERROR_PATH_CREATE                                      => ERROR_MINIMUM + 22;
    push @EXPORT, qw(ERROR_PATH_CREATE);
use constant ERROR_COMMAND_INVALID                                  => ERROR_MINIMUM + 23;
    push @EXPORT, qw(ERROR_COMMAND_INVALID);
use constant ERROR_HOST_CONNECT                                     => ERROR_MINIMUM + 24;
    push @EXPORT, qw(ERROR_HOST_CONNECT);
use constant ERROR_LOCK_ACQUIRE                                     => ERROR_MINIMUM + 25;
    push @EXPORT, qw(ERROR_LOCK_ACQUIRE);
use constant ERROR_BACKUP_MISMATCH                                  => ERROR_MINIMUM + 26;
    push @EXPORT, qw(ERROR_BACKUP_MISMATCH);
use constant ERROR_FILE_SYNC                                        => ERROR_MINIMUM + 27;
    push @EXPORT, qw(ERROR_FILE_SYNC);
use constant ERROR_PATH_OPEN                                        => ERROR_MINIMUM + 28;
    push @EXPORT, qw(ERROR_PATH_OPEN);
use constant ERROR_PATH_SYNC                                        => ERROR_MINIMUM + 29;
    push @EXPORT, qw(ERROR_PATH_SYNC);
use constant ERROR_FILE_MISSING                                     => ERROR_MINIMUM + 30;
    push @EXPORT, qw(ERROR_FILE_MISSING);
use constant ERROR_DB_CONNECT                                       => ERROR_MINIMUM + 31;
    push @EXPORT, qw(ERROR_DB_CONNECT);
use constant ERROR_DB_QUERY                                         => ERROR_MINIMUM + 32;
    push @EXPORT, qw(ERROR_DB_QUERY);
use constant ERROR_DB_MISMATCH                                      => ERROR_MINIMUM + 33;
    push @EXPORT, qw(ERROR_DB_MISMATCH);
use constant ERROR_DB_TIMEOUT                                       => ERROR_MINIMUM + 34;
    push @EXPORT, qw(ERROR_DB_TIMEOUT);
use constant ERROR_FILE_REMOVE                                      => ERROR_MINIMUM + 35;
    push @EXPORT, qw(ERROR_FILE_REMOVE);
use constant ERROR_PATH_REMOVE                                      => ERROR_MINIMUM + 36;
    push @EXPORT, qw(ERROR_PATH_REMOVE);
use constant ERROR_STOP                                             => ERROR_MINIMUM + 37;
    push @EXPORT, qw(ERROR_STOP);
use constant ERROR_TERM                                             => ERROR_MINIMUM + 38;
    push @EXPORT, qw(ERROR_TERM);
use constant ERROR_FILE_WRITE                                       => ERROR_MINIMUM + 39;
    push @EXPORT, qw(ERROR_FILE_WRITE);
use constant ERROR_UNHANDLED_EXCEPTION                              => ERROR_MINIMUM + 40;
    push @EXPORT, qw(ERROR_UNHANDLED_EXCEPTION);
use constant ERROR_PROTOCOL_TIMEOUT                                 => ERROR_MINIMUM + 41;
    push @EXPORT, qw(ERROR_PROTOCOL_TIMEOUT);
use constant ERROR_FEATURE_NOT_SUPPORTED                            => ERROR_MINIMUM + 42;
    push @EXPORT, qw(ERROR_FEATURE_NOT_SUPPORTED);
use constant ERROR_ARCHIVE_COMMAND_INVALID                          => ERROR_MINIMUM + 43;
    push @EXPORT, qw(ERROR_ARCHIVE_COMMAND_INVALID);
use constant ERROR_LINK_EXPECTED                                    => ERROR_MINIMUM + 44;
    push @EXPORT, qw(ERROR_LINK_EXPECTED);
use constant ERROR_ABSOLUTE_LINK_EXPECTED                           => ERROR_MINIMUM + 45;
    push @EXPORT, qw(ERROR_ABSOLUTE_LINK_EXPECTED);
use constant ERROR_TABLESPACE_IN_PGDATA                             => ERROR_MINIMUM + 46;
    push @EXPORT, qw(ERROR_TABLESPACE_IN_PGDATA);
use constant ERROR_HOST_INVALID                                     => ERROR_MINIMUM + 47;
    push @EXPORT, qw(ERROR_HOST_INVALID);
use constant ERROR_PATH_MISSING                                     => ERROR_MINIMUM + 48;
    push @EXPORT, qw(ERROR_PATH_MISSING);
use constant ERROR_BACKUP_SET_INVALID                               => ERROR_MINIMUM + 49;
    push @EXPORT, qw(ERROR_BACKUP_SET_INVALID);

use constant ERROR_INVALID_VALUE                                    => ERROR_MAXIMUM - 1;
    push @EXPORT, qw(ERROR_INVALID_VALUE);
use constant ERROR_UNKNOWN                                          => ERROR_MAXIMUM;
    push @EXPORT, qw(ERROR_UNKNOWN);

####################################################################################################################################
# CONSTRUCTOR
####################################################################################################################################
sub new
{
    my $class = shift;       # Class name
    my $iCode = shift;       # Error code
    my $strMessage = shift;  # ErrorMessage
    my $strTrace = shift;    # Stack trace

    # if ($iCode < ERROR_MINIMUM || $iCode > ERROR_MAXIMUM)
    # {
    #     $iCode = ERROR_INVALID_VALUE;
    # }

    # Create the class hash
    my $self = {};
    bless $self, $class;

    # Initialize exception
    $self->{iCode} = $iCode;
    $self->{strMessage} = $strMessage;
    $self->{strTrace} = $strTrace;

    return $self;
}

####################################################################################################################################
# CODE
####################################################################################################################################
sub code
{
    my $self = shift;

    return $self->{iCode};
}

####################################################################################################################################
# MESSAGE
####################################################################################################################################
sub message
{
    my $self = shift;

    return $self->{strMessage};
}

####################################################################################################################################
# TRACE
####################################################################################################################################
sub trace
{
    my $self = shift;

    return $self->{strTrace};
}

1;
