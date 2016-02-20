####################################################################################################################################
# BACKUP FILE MODULE
####################################################################################################################################
package BackRest::BackupFile;

use threads;
use Thread::Queue;
use strict;
use warnings FATAL => qw(all);
use Carp qw(confess);

use Exporter qw(import);
    our @EXPORT = qw();
use File::Basename qw(dirname);

use lib dirname($0);
use BackRest::Common::Exception;
use BackRest::Common::Log;
use BackRest::Common::String;
use BackRest::File;
use BackRest::Manifest;

####################################################################################################################################
# Operation constants
####################################################################################################################################
use constant OP_BACKUP_FILE                                         => 'BackupFile';

use constant OP_BACKUP_FILE_BACKUP_FILE                             => OP_BACKUP_FILE . '::backupFile';
use constant OP_BACKUP_FILE_BACKUP_MANIFEST_UPDATE                  => OP_BACKUP_FILE . '::backupManifestUpdate';

####################################################################################################################################
# backupFile
####################################################################################################################################
sub backupFile
{
    # Assign function parameters, defaults, and log debug info
    my
    (
        $strOperation,
        $oFile,                                     # File object
        $strSourceFile,                             # Source file to backup
        $strDestinationFile,                        # Destination backup file
        $bDestinationCompress,                      # Compress destination file
        $strChecksum,                               # File checksum to be checked
        $lModificationTime,                         # File modification time
        $lSizeFile,                                 # File size
        $lSizeTotal,                                # Total size of the files to be copied
        $lSizeCurrent,                              # Size of files copied so far
    ) =
        logDebugParam
        (
            OP_BACKUP_FILE_BACKUP_FILE, \@_,
            {name => 'oFile', trace => true},
            {name => 'strSourceFile', trace => true},
            {name => 'strDestinationFile', trace => true},
            {name => 'bDestinationCompress', trace => true},
            {name => 'strChecksum', required => false, trace => true},
            {name => 'lModificationTime', trace => true},
            {name => 'lSizeFile', trace => true},
            {name => 'lSizeTotal', default => 0, trace => true},
            {name => 'lSizeCurrent', required => false, trace => true}
        );

    my $bCopyResult = true;                         # Copy result
    my $strCopyChecksum;                            # Copy checksum
    my $lCopySize;                                  # Copy Size

    # Add the size of the current file to keep track of percent complete
    $lSizeCurrent += $lSizeFile;

    # If checksum is defined then the file already exists but needs to be checked
    my $bCopy = true;

    if (defined($strChecksum))
    {
        ($strCopyChecksum, $lCopySize) =
            $oFile->hashSize(PATH_BACKUP_TMP, $strDestinationFile .
                             ($bDestinationCompress ? '.' . $oFile->{strCompressExtension} : ''), $bDestinationCompress);

        $bCopy = !($strCopyChecksum eq $strChecksum && $lCopySize == $lSizeFile);

        if ($bCopy)
        {
            &log(WARN, "resumed backup file ${strDestinationFile} should have checksum ${strChecksum} but " .
                       "actually has checksum ${strCopyChecksum}.  The file will be recopied and backup will " .
                       "continue but this may be an issue unless the backup temp path is known to be corrupted.");
        }
    }

    if ($bCopy)
    {
        # Copy the file from the database to the backup (will return false if the source file is missing)
        ($bCopyResult, $strCopyChecksum, $lCopySize) =
            $oFile->copy(PATH_DB_ABSOLUTE, $strSourceFile,
                         PATH_BACKUP_TMP, $strDestinationFile .
                             ($bDestinationCompress ? '.' . $oFile->{strCompressExtension} : ''),
                         false,                   # Source is not compressed since it is the db directory
                         $bDestinationCompress,   # Destination should be compressed based on backup settings
                         true,                    # Ignore missing files
                         $lModificationTime,      # Set modification time - this is required for resume
                         undef,                   # Do not set original mode
                         true);                   # Create the destination directory if it does not exist

        if (!$bCopyResult)
        {
            # If file is missing assume the database removed it (else corruption and nothing we can do!)
            &log(INFO, "skip file removed by database: " . $strSourceFile);
        }
    }

    # Ouput log
    if ($bCopyResult)
    {
        &log(INFO, (defined($strChecksum) && !$bCopy ? 'checksum resumed file' : 'backup file') .
                   " $strSourceFile (" . fileSizeFormat($lCopySize) .
                   ($lSizeTotal > 0 ? ', ' . int($lSizeCurrent * 100 / $lSizeTotal) . '%' : '') . ')' .
                   ($lCopySize != 0 ? " checksum ${strCopyChecksum}" : ''));
    }

    # Return from function and log return values if any
    return logDebugReturn
    (
        $strOperation,
        {name => 'bCopyResult', value => $bCopyResult, trace => true},
        {name => 'lSizeCurrent', value => $lSizeCurrent, trace => true},
        {name => 'lCopySize', value => $lCopySize, trace => true},
        {name => 'strCopyChecksum', value => $strCopyChecksum, trace => true}
    );
}

push @EXPORT, qw(backupFile);

####################################################################################################################################
# backupManifestUpdate
####################################################################################################################################
sub backupManifestUpdate
{
    # Assign function parameters, defaults, and log debug info
    my
    (
        $strOperation,
        $oManifest,
        $strSection,
        $strFile,
        $bCopied,
        $lSize,
        $strChecksum,
        $lManifestSaveSize,
        $lManifestSaveCurrent
    ) =
        logDebugParam
        (
            OP_BACKUP_FILE_BACKUP_MANIFEST_UPDATE, \@_,
            {name => 'oManifest', trace => true},
            {name => 'strSection', trace => true},
            {name => 'strFile', trace => true},
            {name => 'bCopied', trace => true},
            {name => 'lSize', required => false, trace => true},
            {name => 'strChecksum', required => false, trace => true},
            {name => 'lManifestSaveSize', required => false, trace => true},
            {name => 'lManifestSaveCurrent', required => false, trace => true}
        );

    # If copy was successful store the checksum and size
    if ($bCopied)
    {
        $oManifest->set($strSection, $strFile, MANIFEST_SUBKEY_SIZE, $lSize + 0);

        if ($lSize > 0)
        {
            $oManifest->set($strSection, $strFile, MANIFEST_SUBKEY_CHECKSUM, $strChecksum);
        }

        # Determine whether to save the manifest
        if (defined($lManifestSaveSize))
        {
            $lManifestSaveCurrent += $lSize;

            if ($lManifestSaveCurrent >= $lManifestSaveSize)
            {
                $oManifest->save();
                logDebugMisc
                (
                    $strOperation, 'save manifest',
                    {name => 'lManifestSaveSize', value => $lManifestSaveSize},
                    {name => 'lManifestSaveCurrent', value => $lManifestSaveCurrent}
                );

                $lManifestSaveCurrent = 0;
            }
        }
    }
    # Else the file was removed during backup so remove from manifest
    else
    {
        $oManifest->remove($strSection, $strFile);
    }

    # Return from function and log return values if any
    return logDebugReturn
    (
        $strOperation,
        {name => 'lManifestSaveCurrent', value => $lManifestSaveCurrent, trace => true}
    );
}

push @EXPORT, qw(backupManifestUpdate);

1;
