####################################################################################################################################
# COMMON STRING MODULE
####################################################################################################################################
package BackRest::Common::String;

use threads;
use strict;
use warnings FATAL => qw(all);
use Carp qw(confess longmess);

use Exporter qw(import);
    our @EXPORT = qw();
use File::Basename qw(dirname);

####################################################################################################################################
# dataHashBuild
#
# Hash a delimited multi-line string with a header.
####################################################################################################################################
sub dataHashBuild
{
    my $oHashRef = shift;
    my $strData = shift;
    my $strDelimiter = shift;
    my $strUndefinedKey = shift;

    my @stryFile = split("\n", $strData);
    my @stryHeader = split($strDelimiter, $stryFile[0]);

    for (my $iLineIdx = 1; $iLineIdx < scalar @stryFile; $iLineIdx++)
    {
        my @stryLine = split($strDelimiter, $stryFile[$iLineIdx]);

        if (!defined($stryLine[0]) || $stryLine[0] eq '')
        {
            $stryLine[0] = $strUndefinedKey;
        }

        for (my $iColumnIdx = 1; $iColumnIdx < scalar @stryHeader; $iColumnIdx++)
        {
            if (defined(${$oHashRef}{"$stryHeader[0]"}{"$stryLine[0]"}{"$stryHeader[$iColumnIdx]"}))
            {
                confess 'the first column must be unique to build the hash';
            }

            if (defined($stryLine[$iColumnIdx]) && $stryLine[$iColumnIdx] ne '')
            {
                ${$oHashRef}{"$stryHeader[0]"}{"$stryLine[0]"}{"$stryHeader[$iColumnIdx]"} = $stryLine[$iColumnIdx];
            }
        }
    }
}

push @EXPORT, qw(dataHashBuild);

####################################################################################################################################
# trim
#
# Trim whitespace.
####################################################################################################################################
sub trim
{
    my $strBuffer = shift;

    if (!defined($strBuffer))
    {
        return;
    }

    $strBuffer =~ s/^\s+|\s+$//g;

    return $strBuffer;
}

push @EXPORT, qw(trim);

####################################################################################################################################
# commonPrefix
#
# Determine how much of two strings is the same from the beginning.
####################################################################################################################################
sub commonPrefix
{
    my $strString1 = shift;
    my $strString2 = shift;

    my $iCommonLen = 0;
    my $iCompareLen = length($strString1) < length($strString2) ? length($strString1) : length($strString2);

    for (my $iIndex = 0; $iIndex < $iCompareLen; $iIndex++)
    {
        if (substr($strString1, $iIndex, 1) ne substr($strString2, $iIndex, 1))
        {
            last;
        }

        $iCommonLen++;
    }

    return $iCommonLen;
}

push @EXPORT, qw(commonPrefix);

####################################################################################################################################
# boolFormat
#
# Outut boolean as true or false.
####################################################################################################################################
sub boolFormat
{
    my $bValue;

    if ($bValue)
    {
        return 'true';
    }

    return 'false';
}

push @EXPORT, qw(boolFormat);

####################################################################################################################################
# fileSizeFormat
#
# Format file sizes in human-readable form.
####################################################################################################################################
sub fileSizeFormat
{
    my $lFileSize = shift;

    if ($lFileSize < 1024)
    {
        return $lFileSize . 'B';
    }

    if ($lFileSize < (1024 * 1024))
    {
        return (int($lFileSize / 102.4) / 10) . 'KB';
    }

    if ($lFileSize < (1024 * 1024 * 1024))
    {
        return (int($lFileSize / 1024 / 102.4) / 10) . 'MB';
    }

    return (int($lFileSize / 1024 / 1024 / 102.4) / 10) . 'GB';
}

push @EXPORT, qw(fileSizeFormat);

####################################################################################################################################
# timestampFormat
#
# Get standard timestamp format (or formatted as specified).
####################################################################################################################################
sub timestampFormat
{
    my $strFormat = shift;
    my $lTime = shift;

    if (!defined($strFormat))
    {
        $strFormat = '%4d-%02d-%02d %02d:%02d:%02d';
    }

    if (!defined($lTime))
    {
        $lTime = time();
    }

    my ($iSecond, $iMinute, $iHour, $iMonthDay, $iMonth, $iYear, $iWeekDay, $iYearDay, $bIsDst) = localtime($lTime);

    return sprintf($strFormat, $iYear + 1900, $iMonth + 1, $iMonthDay, $iHour, $iMinute, $iSecond);
}

push @EXPORT, qw(timestampFormat);

####################################################################################################################################
# timestampFileFormat
####################################################################################################################################
sub timestampFileFormat
{
    my $strFormat = shift;
    my $lTime = shift;

    return timestampFormat(defined($strFormat) ? $strFormat : '%4d%02d%02d-%02d%02d%02d', $lTime);
}

push @EXPORT, qw(timestampFileFormat);

####################################################################################################################################
# stringSplit
####################################################################################################################################
sub stringSplit
{
    my $strString = shift;
    my $strChar = shift;
    my $iLength = shift;

    if (length($strString) <= $iLength)
    {
        return $strString, undef;
    }

    my $iPos = index($strString, $strChar);

    if ($iPos == -1)
    {
        return $strString, undef;
    }

    my $iNewPos = $iPos;

    while ($iNewPos != -1 && $iNewPos + 1 < $iLength)
    {
        $iPos = $iNewPos;
        $iNewPos = index($strString, $strChar, $iPos + 1);
    }

    return substr($strString, 0, $iPos + 1), substr($strString, $iPos + 1);
}

push @EXPORT, qw(stringSplit);

1;
