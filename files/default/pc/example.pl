$Conf{XferMethod} = 'smb';
$Conf{XferLogLevel} = 1;
$Conf{SmbShareName} = [
  'F$',
 ];
$Conf{SmbShareUserName} = 'domainadmin';
$Conf{SmbSharePasswd} = 'password';
$Conf{BackupFilesExclude} = [
    'RECYCLER',
    'System Volume Information',
];
