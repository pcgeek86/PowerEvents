
# TODO: Test creation of WMI Event Consumer on remote machine (should work fine)
# TODO: Finish comment-based help (add several .Example)
# TODO: Check for existence of script file during consumer creation
# TODO: Consolidate certain parameters (eg. Message, Text, InsertionStringTemplate) that do more or less the same thing

#region New-WmiEventConsumer
function New-WmiEventConsumer
{

	<# 
		.Synopsis
		Creates a new, permanent WMI event consumer.
		
		.Description
		Creates a permanent WMI event consumer, leveraging the out-of-box classes provided by Microsoft. The consumer class, and related configuration, can be specified as parameters.

		.Parameter Name
		The name for the the event consumer. Giving a consumer a name is not required, however it is strongly recommended, to make referencing it in the future easier.
		
		.Parameter ComputerName
		The computer name to create the WMI event consumer on. Requires administrative access to the remote computer.
		
		.Parameter ConsumerType
		The type of event consumer you would like to use. This can be any of the following values: EventLog, LogFile, CommandLine, Script, or SMTP. These values represent the five out-of-box event consumers available in the Windows operating system.
		
		.Parameter Timeout
		The execution timeout for CommandLineEventConsumer and ActiveScriptEventConsumer instances.
		
		.Parameter Namespace
		The WMI namespace that you would like to create the new event consumer in. Typically in practice, this will be root\subscription, as that is where the out-of-box event consumer classes reside.
		
		.Parameter ScriptFile
		The path to the script file you would like to execute, if using the ActiveScriptEventConsumer (VBscript consumer) class.

		.Parameter ScriptingEngine
		The scripting engine to use for execution of the script in the ActiveScriptEventConsumer. In practice, this will almost always be "VBscript."
			
		.Parameter ScriptText
		ScriptText is used if ScriptFile is not available. Script code can be embedded inside the event consumer. Most often, this will simply be VBscript code.
		
		.Parameter CommandLineTemplate
		Ideally used instead of ExecutablePath. The standard string template that specifies the process to be started for the CommandLineEventConsumer.
		
		.Parameter ExecutablePath
		Module to execute. The string can specify the full path and file name of the module to execute, or it can specify a partial name. If a partial name is specified, the current drive and current directory are assumed.
		
		.Parameter WorkingDirectory
		The working directory for the CommandLineEventConsumer instance.
		
		.Parameter BccLine
		The BCC property for a SMTPEventConsumer instance. Either a [string[]] or a comma or semicolon delimited list of e-mail addresses.
		
		.Parameter CcLine
		The CC property for a SMTPEventConsumer instance. Either a [string[]] or a comma or semicolon delimited list of e-mail addresses.

		.Parameter FromLine
		From line of an email message in the format of a standard string template. If NULL, a From line is constructed in the form of WinMgmt@MachineName.
		
		.Parameter Message
		Standard string template that contains the body of an email message.
		
		.Parameter ReplyToLine
		Reply-to line of an email message in the format of a standard string template. If NULL, no Reply-to line is used.
		
		.Parameter Subject
		Standard string template that contains the subject of an email message.
		
		.Parameter ToLine
		A list of addresses, separated by a comma or semicolon, in the format of a standard string template that identifies where the message is to be sent.
		
		.Parameter FileName
		Name of a file that includes the path to which the log entries are appended. If the file does not exist, LogFileEventConsumer attempts to create it. The consumer fails when the path does not exist, or when the user who creates the consumer does not have write permissions for the file or path.
		
		.Parameter IsUnicode
		If TRUE, the log file is a Unicode text file. If FALSE, the log file is a multibyte code text file. If the file exists, this property is ignored and the current file setting is used. For example, if IsUnicode is FALSE, but the existing file is a Unicode file, then Unicode is used. If IsUnicode is TRUE, but the file is multibyte code, then multibyte code is used.
		
		.Parameter MaximumFileSize
		Maximum size of a log file—in bytes. If the primary file exceeds its maximum size, the contents are moved to a different file and the primary file is emptied. A value of 0 (zero) means there is no size limit. The default value is 65,535 bytes. The size of the file is checked before a write operation. Therefore, you can have a file that is slightly larger than the specified size limit. The next write operation catches it and starts a new file.
		
		.Parameter Text
		Standard string template for the text of a log entry. Details available at: http://msdn.microsoft.com/en-us/library/aa393954(v=VS.85).aspx
		
		.Parameter Category
		A UInt16 value representing the event log category. Must not be null.
		
		.Parameter EventId
		Event message in the message DLL. This property cannot be NULL.
		
		.Parameter EventType
		The event type to use for the NTEventLogEventConsumer. Valid values are: 'Success', 'Error', 'Warning', 'Information', 'AuditSuccess', 'AuditFailure'

		.Parameter InsertionStringTemplates
		An array of string templates that the provider will use to insert event log entries. This parameter uses WMI standard string templates.
		
		.Parameter UncServerName
		The name of the computer on which you would like to log the event to.
		
		.Link
		http://trevorsullivan.net
		
		.Link
		http://powershell.artofshell.com
		
		.Link
		http://msdn.microsoft.com/en-us/library/aa392395(v=VS.85).aspx
		
		.Link
		http://msdn.microsoft.com/en-us/library/aa394647(v=VS.85).aspx
		
		.Link
		http://msdn.microsoft.com/en-us/library/aa393954(v=VS.85).aspx

		.Link
		http://www.streamline-it-solutions.co.uk/blog/post/Configuring-WMI-Event-Handling-with-PowerShell.aspx
		
		.Link
		http://www.codeproject.com/KB/system/PermEvtSubscriptionMOF.aspx?display=Print#5.TemporaryEventConsumers4
	#>

	[CmdletBinding(
		  SupportsShouldProcess = $false
		, SupportsTransactions  = $false
		, ConfirmImpact         = 'Low'
	)]
	#region New-WmiEventConsumer Parameters
	Param(
		#region New-WmiEventConsumer General Parameters
		# In the interest of think + type, I've adjusted these types from their actual WMI class names
		#   EventLog    = NTEventLogEventConsumer
		#   LogFile     = LogFileEventConsumer 
		#   Script      = ActiveScriptEventConsumer
		#   CommandLine = CommandLineEventConsumer
		#   SMTP        = SMTPEventConsumer
		[parameter(
			  Mandatory   = $true
			, HelpMessage = "Please specify the type of event consumer you would like to create."
		)]
		[ValidateSet(
			  "EventLog"
			, "LogFile"
			, "CommandLine"
			, "Script"
			, "SMTP"
		)]
		[alias("Type")]
		${ConsumerType}
		,
		[parameter(
			  Mandatory   = $false
			, HelpMessage = "Please specify the WMI namespace to create the event consumer in."
		)]
		[alias("ns", "WmiNamespace")]
		[string]
		${Namespace} = 'root\default'
		,
		[parameter(
			  Mandatory   = $false
			, HelpMessage = "Please specify a name for this WMI event consumer."
		)]
		[string]
		${Name} = $null
		,
		# TODO: Investigate if 10 is an adequate default number for this parameter (it's NOT)
		[parameter(
			  Mandatory = $false
			, HelpMessage = "Please specify the maximum queue size (in bytes) for this event consumer."
		)]
		[Int32]
		${MaximumQueueSize} = $null
		,
		[parameter(
			  Mandatory   = $false
			, HelpMessage = "Please specify the computer to create the consumer on."
		)]
        [ValidateScript({
            if (Test-Connection -ComputerName $_ -Count 1) { $true; }
            else { $false; }
            })]
		[Alias('pc', 'cn')]
		[string]
		${ComputerName} = 'localhost'
		,
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "Script"
			, HelpMessage      = "Please enter the timeout (in seconds) for the ActiveScriptEventConsumer."
		)]
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "CommandLine"
			, HelpMessage      = "Please enter the timeout (in seconds) for the CommandLineEventConsumer."
		)]
		[Int32]
		${Timeout} = 60
		#endregion New-WmiEventConsumer General Parameters
		#region ParameterSet: ActiveScriptEventConsumer
		# MSDN Documentation for ActiveScriptEventConsumer: http://msdn.microsoft.com/en-us/library/aa384749(VS.85).aspx
		,
		[parameter(		
			  Mandatory        = $false
			, ParameterSetName = "Script"
			, HelpMessage      = 'Please enter the path to the VBscript file that will handle events.'
		)]
		[string]
		${ScriptFile} = $null
		,
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "Script"
			, HelpMessage      = 'Please enter the script engine to use for the ActiveScriptEventConsumer (eg. VBscript).'
		)]
		[string]
		[alias("Engine")]
		${ScriptingEngine} = 'VBScript'
		,
		# TODO: ScriptText should be a DynamicParam, in the event that $ScriptFile is not defined
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "Script"
			, HelpMessage      = "Please specify the script code to be executed for this consumer."
		)]
		[string]
		# TODO: Make sure that ${ScriptFile} over-writes ${ScriptText} parameter
		[ValidateScript( {
			Write-Debug ([Runspace]::DefaultRunspace).InstanceId
			Write-Debug "`${ScriptFile} value is: ${ScriptFile}" 
			if (${ScriptFile} -eq $null)
			{
				$_ -ne $null
			}
		} )]
		${ScriptText} = $null
		#endregion ParameterSet: ActiveScriptEventConsumer
		#region ParameterSet: CommandLineEventConsumer
		# TODO: Add more parameters to the CommandLineEventConsumer (maybe, if deemed necessary)
		,
		# According to MSDN (http://msdn.microsoft.com/en-us/library/aa389231(v=VS.85).aspx) either the CommandLineTemplate can be used
		# or if it is null, then the ExecutablePath property can be used instead.
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "CommandLine"
			, HelpMessage      = "Please specify the command line for the CommandLineEventConsumer."
		)]
		${CommandLineTemplate} = $null
		,
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "CommandLine"
			, HelpMessage      = "Please specify the executable for the CommandLineEventConsumer."
		)]
		[string]
		${ExecutablePath} = $null
		,
		[parameter(
			  Mandatory   = $false
			, ParameterSetName = "CommandLine"
			, HelpMessage = "Please specify a working directory."
		)]
		[string]
		${WorkingDirectory} = $null
		<#
		# PARAMETER IS NOT USED
		# See MSDN: http://msdn.microsoft.com/en-us/library/aa389231(v=VS.85).aspx
		,
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "CommandLine"
			, HelpMessage      = "Please specify whether or not a new console should be opened."
		)]
		[bool]
		${CreateNewConsole} = $true
		#>
		,
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "CommandLine"
			, HelpMessage      = "Please specify whether or not the command should be run interactively."
		)]
		[bool]
		${RunInteractively} = $false
		#endregion ParameterSet: CommandLineEventConsumer
		#region ParameterSet: SMTPEventConsumer
		# MSDN SMTPEventConsumer: http://msdn.microsoft.com/en-us/library/aa393629(v=VS.85).aspx
		,
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "SMTP"
			, HelpMessage      = "Please enter a list of e-mail addresses to blind carbon-copy (BCC) as a [String[]], or a [String] containing a comma or semicolon delimited list."
		)]
		[String[]]
		${BccLine} = $null
		,
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "SMTP"
			, HelpMessage      = "Please enter a list of e-mail addresses to carbon copy (CC) as a [String[]], or a [String] containing a comma or semicolon delimited list."
		)]
		[String[]]
		${CcLine} = $null
		,
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "SMTP"
			, HelpMessage      = "Please enter the text you would like to appear in the 'From' line of notification e-mails."
		)]
		[String]
		${FromLine} = $null
		<#
		# UNSUPPORTED PARAMETER -- not sure how to use it yet
		,
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "SMTP"
			, HelpMessage      = "CURRENTLY UNSUPPORTED! Please enter the additional header fields you'd like to add to the e-mail."
		)]
		[String]
		${HeaderFields} = $null
		#>
		,
		[parameter(
			  Mandatory        = $true
			, ParameterSetName = "SMTP"
			, HelpMessage      = "Please enter the text you would like to appear in the body of the e-mail message."
		)]
		[String]
		${Message} = $null
		,
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "SMTP"
			, HelpMessage      = "Please enter the text you would like to appear in the Reply-to area of the e-mail message."
		)]
		[String]
		${ReplyToLine} = $null
		,
		[parameter(
			  Mandatory        = $true
			, ParameterSetName = "SMTP"
			, HelpMessage      = "Please the IP address or DNS name of the SMTP server."
		)]
		[String]
		${SMTPServer} = $null
		,
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "SMTP"
			, HelpMessage      = "Please enter the text you would like to appear in the Subject field of the e-mail message."
		)]
		[String]
		${Subject} = $null
		,
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "SMTP"
			, HelpMessage      = "Please enter the e-mail address of the receipient."
		)]
		[String]
		[alias("Recipient")]
		${ToLine} = $null
		#endregion ParameterSet: SMTPEventConsumer
		#region ParameterSet: LogFileEventConsumer
		# (DONE) TODO: Add parameters for LogFileEventConsumer
		# (MSDN) LogFileEventConsumer: http://msdn.microsoft.com/en-us/library/aa392277(v=VS.85).aspx
		,
		[parameter(
			  Mandatory        = $true
			, ParameterSetName = "LogFile"
			, HelpMessage      = 'Please specify the full path of the log file to log to.'
		)]
		[string]
		# TODO: Add file name validation to this parameter
		# TODO: Add validation of user permissions to log file path
		# [ValidateScript({ $_.IndexOfAny })]
		${FileName}
		,
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "LogFile"
			, HelpMessage      = 'Please specify whether or not the file is unicode. Valid values: $true or $false'
		)]
		[bool]
		${IsUnicode} = $true
		,
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "LogFile"
			, HelpMessage      = 'Please specify a maximum file size for the log file. Default is 65,535.'
		)]
		[int]
		${MaximumFileSize} = 65535
		,
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "LogFile"
			, HelpMessage      = 'Please specify the text template for the consumer. See http://msdn.microsoft.com/en-us/library/aa393954(v=VS.85).aspx for template information.'
		)]
		# TODO: Add validation for template syntax? Maybe. http://msdn.microsoft.com/en-us/library/aa393954(v=VS.85).aspx
		[string]
		${Text}
		#endregion ParameterSet: LogFileEventConsumer
		#region ParameterSet: NTEventLogEventConsumer
		# (DONE) TODO: Add parameters for NTEventLogEventConsumer
		# (MSDN) NTEventLogEventConsumer: http://msdn.microsoft.com/en-us/library/aa392715(v=VS.85).aspx
		,
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "EventLog"
			, HelpMessage      = 'Please specify the event category for this event log consumer.'
		)]
		[ValidateNotNull()]
		[UInt16]
		${Category} = 10
		,
		[parameter(
			  Mandatory        = $true
			, ParameterSetName = "EventLog"
			, HelpMessage      = 'Please specify the event ID for this event log consumer.'
		)]
		[ValidateNotNull()]
		[UInt32]
		${EventId}
		,
		[parameter(
			  Mandatory        = $true
			, ParameterSetName = "EventLog"
			, HelpMessage      = 'Please specify the event type for this event log consumer.'
		)]
		# These are normalized values that will translate into numeric values from winnt.h
		# http://source.winehq.org/source/include/winnt.h
		[ValidateSet(
			  "Success"			# EVENTLOG_SUCCESS			= 0x0000
			, "Error"			# EVENTLOG_ERROR_TYPE		= 0x0001
			, "Warning"			# EVENTLOG_WARNING			= 0x0002
			, "Information"		# EVENTLOG_INFORMATION_TYPE = 0x0004
			, "AuditSuccess"	# EVENTLOG_AUDIT_SUCCESS	= 0x0008
			, "AuditFailure"	# EVENTLOG_AUDIT_FAILURE	= 0x0010
		)]
		${EventType}
		,
		# TODO: Rename this parameter to -EventMessage?
		[parameter(
			  Mandatory        = $true
			, ParameterSetName = "EventLog"
			, HelpMessage      = 'Please specify the array of string templates for this event log consumer.'
		)]
		[String[]]
		[Alias("MessageTemplates")]
		${InsertionStringTemplates}
		,
		# TODO: Test the use of a NTEventLogEventConsumer to log an event on a remote server or workstation.
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "EventLog"
			, HelpMessage      = 'Please specify the computer you would like to log the event on.'
		)]
		[string]
		# TODO: Use script validation to ensure remote computer is available?
		# TODO: Use -Force parameter to force creation of event consumer against remote event log even if remote computer is unavailable? Maybe.
		${UNCServerName}
		,
		[parameter(
			  Mandatory        = $false
			, ParameterSetName = "EventLog"
			, HelpMessage      = 'Please specify the source name for the event. If none is specified, the parameter will default to "UnknownEventSource"'
		)]
		[string]
		${SourceName} = 'UnknownEventSource'
		#endregion ParameterSet: NTEventLogEventConsumer
	)
	#endregion New-WmiEventConsumer Parameters
	
	#region New-WmiEventConsumer Begin block
	begin
	{
		# Get the cmdlet name for writing dynamic log messages
		${CmdletName} = $Pscmdlet.MyInvocation.MyCommand.Name

		Write-Debug -Message "${CmdletName}: Runspace ID is: $(([Runspace]::DefaultRunspace).InstanceId)";

		Write-Verbose -Message "${CmdletName}: Start running BEGIN block";
		Write-Verbose -Message ("${CmdletName}: Using the parameter set: " + $Pscmdlet.ParameterSetName);
		# TODO: Convert BccLine and CcLine from [string[]] to comma or semicolon separated lists of e-mail addresses
		# TODO: Validate that both ${ScriptText} and ${ScriptFilename} are not BOTH $null (AND ${ConsumerType} is Script)

		# This is a lookup hashtable, so that the parameter can take the friendly names, and they can later be translated into their numeric values
		# Used for NTEventLogEventConsumer.EventType property
		$EventTypes = @{
			Success      = 0;
			Error        = 1;
			Warning      = 2;
			Information  = 4;
			AuditSuccess = 8;
			AuditFailure = 16;
		}
		
		<#
		#region DEPRECATED CODE
		# (DONE) TODO: IMPORTANT: Translate $EventType into numeric values from winnt.h - See: http://source.winehq.org/source/include/winnt.h
		# (DONE) TODO: Convert this to a hashtable for easier reference
		if ($Pscmdlet.ParameterSetName -eq 'EventLog')
		{
			Write-Verbose -Message "Event type is: ${EventType}"
			switch (${EventType})
			{
				'Success'
				{
					${EventType} = [int]0
				}
				'Error'
				{
					${EventType} = [int]1
				}
				'Warning'
				{
					${EventType} = [int]2
				}
				'Information'
				{
					${EventType} = [int]4
				}
				'AuditSuccess'
				{
					${EventType} = [int]8
				}
				'AuditFailure'
				{
					${EventType} = [int]16
				}
				$null
				{
					Write-Verbose '${EventType} is $null, assuming unused'
				}
				# Unrecognized value passed to ${EventType}. This should be caught in the argument validation, but if not, this ought to take care of it
				default
				{
					Write-Error -Category InvalidArgument -Message 'Invalid value specified for ${EventType} argument.' -RecommendedAction 'Use one of the following values for EventType: Success, Warning, Error, Information, AuditSuccess, AuditFailure'
				}
			}
		}
		#endregion END DEPRECATED CODE
		#>
	}
	#endregion New-WmiEventConsumer Begin block
	
	#region New-WmiEventConsumer process block
	process
	{
		switch (${ConsumerType})
		{
			#region ActiveScriptEventConsumer
			# If the consumer type is a script, then we will create an instance of ActiveScriptEventConsumer
			# Documentation: http://msdn.microsoft.com/en-us/library/aa384749(VS.85).aspx
			'Script'
			{
				# Create a new instance of the ActiveScriptEventConsumer class
				${NewConsumer} = ([wmiclass]"\\${ComputerName}\root\subscription:ActiveScriptEventConsumer").CreateInstance()
				# Set the KillTimeout property of ActiveScriptEventConsumer
				# (MSDN): Number, in seconds, that the script is allowed to run. If 0 (zero), which is the default, the script is not terminated.
#				${NewConsumer}.{KillTimeout} = ${Timeout}
				# Set the MachineName property on ActiveScriptEventConsumer
				# (MSDN): Name of the computer to which WMI sends events. By convention of Microsoft standard consumers, the script consumer cannot be run remotely. Third-party consumers can also use this property. This property is inherited from __EventConsumer.
#				${NewConsumer}.{MachineName} = ${ComputerName}

				# If the ${ScriptFile} parameter is specified, then set the ScriptFile property on ActiveScriptEventConsumer
				# IMPORTANT: Even if ${ScriptFile} is $null, DO NOT define the WMI property, otherwise WMI will think the value is defined
				if (${ScriptFile})
				{
					${NewConsumer}.{ScriptFilename} = ${ScriptFile}
					Write-Verbose -Message "${CmdletName}: Defined the ScriptFilename property"
				}
				else
				{
					Write-Verbose -Message "${CmdletName}: `${ScriptFile} parameter is null; using ScriptText instead"
				}

				# The ScriptingEngine on ActiveScriptEventConsumer should always be set to "VBscript"
				# I am not aware of any other supported values at this point -- the only other option I could think of might be "jscript"
				# (MSDN): Name of the scripting engine to use, for example, "VBScript". This property cannot be NULL.
				${NewConsumer}.{ScriptingEngine} = ${ScriptingEngine}
				Write-Verbose -Message "${CmdletName}: Defined the ScriptingEngine property"
				
				# Define the MaximumQueueSize property on ActiveScriptEventConsumer
				# (MSDN): Maximum queue, in bytes, for the Active Script Event consumer. This property is inherited from __EventConsumer.
				if (${MaximumQueueSize})
				{
					${NewConsumer}.{MaximumQueueSize} = ${MaximumQueueSize}
					Write-Verbose -Message "${CmdletName}: Defined the MaximumQueueSize property"
				}
				else
				{
					Write-Verbose -Message "${CmdletName}: `${MaximumQueueSize} is null. Skipping ..."
				}
				

				# ONLY set the ActiveScriptEventConsumer.ScriptText property if it is defined.
				# TODO: Make sure that ${ScriptFile} and ${ScriptText} parameters do not conflict with each other
				if (${ScriptText} -and -not ${ScriptFile})
				{
					${NewConsumer}.{ScriptText} = ${ScriptText}
					Write-Verbose -Message "${CmdletName}: Defined the ScriptText property"
				}
				# Warn user if ${ScriptText} is empty. If it is defined, but empty, the event consumer will yield no action.
				#elseif (${ScriptText} -eq '') { Write-Warning '${ScriptText} was defined, but is empty. No action will occur for this event consumer.' }
				else
				{
					Write-Verbose "${CmdletName}: `${ScriptText} parameter is null OR ScriptFile property has already been specified on `${NewConsumer}."
				}

				# Set the friendly name of the new ActiveScriptEventConsumer.
				# Note: The Name property is the key for the ActiveScriptEventConsumer class
				${NewConsumer}.{Name} = ${Name}
				${PutResult} = ${NewConsumer}.Put()
				Write-Verbose -Message "${CmdletName}: Completed instantiating new ActiveScriptEventConsumer: $(${PutResult}.{Path})"
				
				# Retrieve and write new WMI instance to pipeline
				Write-Output -InputObject $([wmi]"$(${PutResult}.{Path})")
			}
			#endregion ActiveScriptEventConsumer

			#region CommandLineEventConsumer
			# If the consumer type is a command line, then we will create an instance of CommandLineEventConsumer
			# (MSDN): http://msdn.microsoft.com/en-us/library/aa389231(v=VS.85).aspx
			'CommandLine'
			{
				# Create a new instance of CommandLineEventConsumer
				${NewConsumer} = ([wmiclass]"\\${ComputerName}\root\subscription:CommandLineEventConsumer").CreateInstance()

				# If ${CommandLineTemplate} parameter is defined, use it.
				# (MSDN): Standard string template that specifies the process to be started. This property can be NULL, and the ExecutablePath property is used as the command line.
				if (${CommandLineTemplate})
				{
					${NewConsumer}.{CommandLineTemplate} = ${CommandLineTemplate}
					Write-Verbose -Message "${CmdletName}: Defined the CommandLineTemplate property: ${CommandLineTemplate}"
				}
				else
				{
					Write-Verbose -Message "${CmdletName}: `${CommandLineTemplate} parameter is not defined. Using ${ExecutablePath} parameter instead."
				}
				
				
				# Define MaximumQueueSize property
				if (${MaximumQueueSize})
				{
					${NewConsumer}.{MaximumQueueSize} = ${MaximumQueueSize}
					Write-Verbose "${CmdletName}: Setting MaximumQueueSize to: ${MaximumQueueSize}"
				}
				else
				{
					Write-Verbose -Message "${CmdletName}: MaximumQueueSize was not specified"
				}
				
				# Define WorkingDirectory
				if (${WorkingDirectory})
				{
					${NewConsumer}.{WorkingDirectory} = ${WorkingDirectory}
					Write-Verbose -Message "${CmdletName}: Set WorkingDirectory property to ${WorkingDirectory}"
				}
				else
				{
					Write-Verbose -Message "${CmdletName}: WorkingDirectory parameter was not set."
				}
				
				# If ${Name} parameter is defined, then set it, otherwise provider will automatically assign a GUID as the name
				# (MSDN): Unique name of a consumer.
				if (${Name})
				{
					${NewConsumer}.{Name} = ${Name}
					Write-Verbose -Message "${CmdletName}: `${Name} parameter defined on consumer: ${Name}"
				}
				else
				{
					Write-Verbose -Message "${CmdletName}: `${Name} parameter not defined. Using random GUID for name."
					Write-Warning -Message "${CmdletName}: `${Name} parameter not specified. It is highly recommended to use name"
				}
				
				if (${ExecutablePath})
				{
					${NewConsumer}.{ExecutablePath} = ${ExecutablePath}
					Write-Verbose -Message "${CmdletName}: ExecutablePath property set to: ${ExecutablePath}"
				}
				else
				{
					Write-Verbose -Message "${CmdletName}: `${ExecutablePath} is not defined. Using `${CommandLineTemplate} instead."
				}

				# Write the WMI instance to the provider
				${PutResult} = ${NewConsumer}.Put();
				Write-Verbose -Message "Completed instantiating new CommandLineEventConsumer: $(${PutResult}.{Path})"
				Write-Output -InputObject $([wmi]"$(${PutResult}.{Path})");
			}
			#endregion CommandLineEventConsumer

			#region SMTPEventConsumer
			# If the consumer type is SMTP, then we will create an instance of SMTPEventConsumer
			# (MSDN): http://msdn.microsoft.com/en-us/library/aa393629(VS.85).aspx
			'SMTP'
			{
				# Create new instance of SMTPEventConsumer
				${NewConsumer} = ([wmiclass]"root\subscription:SMTPEventConsumer").CreateInstance()

				# If ${Name} parameter is defined, then set it, otherwise provider will automatically assign a GUID as the name
				# (MSDN): Unique name of a consumer.
				if (${Name})
				{
					${NewConsumer}.{Name} = ${Name}
					Write-Verbose -Message "${CmdletName}: Defined the Name property"
				}
				else
				{
					Write-Verbose -Message '${Name} parameter not defined. Using random GUID for name.'
				}
				
				# Define the BccLine property on SMTPEventConsumer
				# (MSDN): A list of addresses, separated by a comma or semicolon, in the format of a standard string template to which the message is sent as a blind carbon copy.
				if (${BccLine}) {
					${NewConsumer}.{BccLine} = ${BccLine}
					Write-Verbose -Message "${CmdletName}: Defined the BccLine property"
				}
				else
				{
					Write-Verbose -Message "${CmdletName}: `${BccLine} is $null, skipping property"
				}
				
				# Define the CcLine property on SMTPEventConsumer
				# (MSDN): A list of addresses, separated by a comma or semicolon, in the format of a standard string template to which the message is sent as a carbon copy.
				if (${CcLine}) {
					${NewConsumer}.{CcLine} = ${CcLine}
					Write-Verbose -Message "${CmdletName}: Defined the CcLine property"
				}
				else
				{
					Write-Verbose -Message "${CmdletName}: `${CcLine} parameter is $null, skipping property"
				}
				
				# Define the FromLine property on SMTPEventConsumer
				# (MSDN): From line of an email message in the format of a standard string template. If NULL, a From line is constructed in the form of WinMgmt@MachineName.
				# (MSDN): Windows Server 2003:  If NULL, FromLine is constructed as "WMI@MachineName". If not NULL, then what is specified in the FromLine property is used, and the consumer sets "WMI@MachineName" as the Sender in the SMTP header of the message. This sender cannot be controlled by any property of the SMTPEventConsumer.
				# (MSDN): Windows XP:  If NULL, FromLine is constructed as "WinMgmt@MachineName via WMI auto-mailer".
				if (${FromLine}) {
					${NewConsumer}.{FromLine} = ${FromLine}
					Write-Verbose -Message "${CmdletName}: Defined the FromLine property"
				}
				else
				{
					Write-Verbose -Message "${CmdletName}: `${FromLine} is $null, skipping property"
				}
				
				# Define the Message property on SMTPEventConsumer
				# (MSDN): Standard string template that contains the body of an email message.
				if (${Message}) {
					${NewConsumer}.{Message} = ${Message}
					Write-Verbose -Message 'Defined the Message property'
				}
				else { Write-Verbose -Message '${Message} is $null, skipping property' }
				
				# Define the ReplyToLine property on SMTPEventConsumer
				# (MSDN): Reply-to line of an email message in the format of a standard string template. If NULL, no Reply-to line is used.
				if (${ReplyToLine}) {
					${NewConsumer}.{ReplyToLine} = ${ReplyToLine}
					Write-Verbose -Message 'Defined the ${ReplyToLine} property'
				}
				else { Write-Verbose '${ReplyToLine} is $null, skipping property' }
				
				# Define the SMTPServer property on SMTPEventConsumer
				# (MSDN): Name of the SMTP server through which an email is sent. Permissible names are an IP address, or a DNS or NetBIOS name. This property cannot be NULL.
				if (${SMTPServer}) {
					${NewConsumer}.{SMTPServer} = ${SMTPServer}
					Write-Verbose -Message 'Defined the SMTPServer property'
				}
				else { Write-Verbose '${SMTPServer} is $null, skipping property' }
				
				# Define the Subject property on SMTPEventConsumer
				# (MSDN): Standard string template that contains the subject of an email message.
				if (${Subject}) {
					${NewConsumer}.{Subject} = ${Subject}
					Write-Verbose -Message 'Defined the ${Subject} property'
				}
				else { Write-Verbose -Message '${Subject} is $null, skipping property' }
				
				# Define the ToLine property on SMTPEventConsumer
				# (MSDN): Standard string template that contains the subject of an email message.
				if (${ToLine}) {
					${NewConsumer}.{ToLine} = ${ToLine}
					Write-Verbose -Message 'Defined the ToLine property'
				}
				else { Write-Verbose -Message '${ToLine} is $null, skipping property' }

				# Write new instance of SMTPEventConsumer back to WMI provider
				${PutResult} = ${NewConsumer}.Put()
				Write-Verbose -Message 'Completed creation of SMTPEventConsumer.'
				
				Write-Output -InputObject ([wmi]"$(${PutResult}.{Path})")
			}
			#endregion SMTPEventConsumer

			#region LogFileEventConsumer
			# (DONE) TODO: Add support for LogFileEventConsumer
			# If the consumer type is a command line, then we will create an instance of LogFileEventConsumer
			# Documentation: http://msdn.microsoft.com/en-us/library/aa392277(VS.85).aspx
			'LogFile'
			{
				${NewConsumer} = ([wmiclass]"\\${ComputerName}\root\subscription:LogFileEventConsumer").CreateInstance()
				Write-Verbose -Message "${CmdletName}: Created new instance of LogFileEventConsumer";
				
				if (${Name})
				{
					${NewConsumer}.{Name} = ${Name}
					Write-Verbose -Message "${CmdletName}: Defined the Name property of LogFileEventConsumer instance.";
				}
				else
				{
					Write-Warning "${CmdletName}: `${Name} parameter not specified. Using random GUID as consumer's name.";
				}
				
				# Documentation: Name of a file that includes the path to which the log entries are appended. If the file does not exist, LogFileEventConsumer attempts to create it. The consumer fails when the path does not exist, or when the user who creates the consumer does not have write permissions for the file or path.
				if (${FileName})
				{
					${NewConsumer}.{FileName} = ${FileName}
					Write-Verbose -Message "${CmdletName}: Defined the FileName property of the LogFileEventConsumer instance."
				}
				# If ${FileName} is $null, then we have a problem
				else
				{
					Write-Error -Message '${FileName} parameter is $null.'
				}
				
				# Documentation: If TRUE, the log file is a Unicode text file. If FALSE, the log file is a multibyte code text file. If the file exists, this property is ignored and the current file setting is used. For example, if IsUnicode is FALSE, but the existing file is a Unicode file, then Unicode is used. If IsUnicode is TRUE, but the file is multibyte code, then multibyte code is used.
				if (${IsUnicode})
				{
					${NewConsumer}.{IsUnicode} = ${IsUnicode}
					Write-Verbose -Message "${CmdletName}: Set the IsUnicode property on LogFileEventConsumer instance";
				}
				else
				{
					Write-Warning -Message "${CmdletName}: `${IsUnicode} parameter was not specified. This warning can generally be safely ignored.";
				}
				
				if (${MaximumFileSize})
				{
					${NewConsumer}.{MaximumFileSize} = ${MaximumFileSize}
					Write-Verbose -Message "${CmdletName}: Defined the MaximumFileSize propert of the LogFileEventConsumer instance."
				}
				else
				{
					Write-Verbose -Message "${CmdletName}: `${MaximumFileSize} parameter not specified. Default is 65,535."
				}
				
				if (${Text})
				{
					${NewConsumer}.{Text} = ${Text}
					Write-Verbose -Message "${CmdletName}: Defined the Text property on the LogFileEventConsumer instance."
				}
				else
				{
					Write-Error -Message "${CmdletName}: `${Text} parameter is $null. The Text property MUST be specified on instances of LogFileEventConsumer."
				}
				
				${PutResult} = ${NewConsumer}.Put()
				Write-Verbose -Message "${CmdletName}: Called Put() method on new instance of LogFileEventConsumer"
				
				Write-Output -InputObject ([wmi]"$(${PutResult}.{Path})")
			}
			#endregion LogFileEventConsumer

			# (DONE) TODO: Add support for NTEventLogEventConsumer
			#region NTEventLogEventConsumer
			# If the consumer type is a command line, then we will create an instance of NTEventLogEventConsumer
			# Documentation: http://msdn.microsoft.com/en-us/library/aa392715(v=VS.85).aspx
			'EventLog'
			{
				${NewConsumer} = ([wmiclass]"\\${ComputerName}\root\subscription:NTEventLogEventConsumer").CreateInstance()
				Write-Verbose -Message "${CmdletName}: Created new instance of NTEventLogEventConsumer"
				
				# Define the Name of the NTEventLogEventConsumer
				if (${Name})
				{
					${NewConsumer}.{Name} = ${Name}
					Write-Verbose -Message "${CmdletName}: Defined the Name property of NTEventLogEventConsumer instance."
				}
				else
				{
					Write-Warning "${CmdletName}: `${Name} parameter not specified. Using random GUID as consumer's name."
				}
				
				# Specify the event type: Information, Error, Warning, etc.
				# See the BEGIN { ... } block for a cross-reference, or winnt.h
				if (${EventType})
				{
					${NewConsumer}.EventType = ${EventTypes}.$EventType
					Write-Verbose -Message "${CmdletName}: Defined the EventType (${EventType},$(${EventTypes}.$EventType))on NTEventLogEventConsumer"
				}
				else
				{
					Write-Verbose -Message "${CmdletName}: `${EventType} parameter is $null. The default event type is 1 (Error)."
				}
				
				# EventId has a Not_Null WMI qualifier assigned to it -- user must define this value
				# Alternative: Specify a default event ID, so user doesn't have to specify this parameter?
				if (${EventId})
				{
					${NewConsumer}.EventId = ${EventId}
					Write-Verbose -Message "${CmdletName}: Defined the EventID (${EventId}) property"
				}
				else
				{
					Write-Warning -Message "${CmdletName}: `${EventId} parameter is `$null; An EventID must be specified."
				}
				
				# Documentation: Array of standard string templates that is used as the insertion string for an event log record.
				if (${InsertionStringTemplates})
				{
					${NewConsumer}.InsertionStringTemplates = ${InsertionStringTemplates}
					Write-Verbose -Message 'Defined the InsertionStringTemplates property'
				}
				else
				{
					Write-Warning -Message "${CmdletName}: `${InsertionStringTemplates} property is $null; This property must be defined."
				}
				
				if (${UNCServerName})
				{
					${NewConsumer}.UncServerName = ${UNCServerName}
					Write-Verbose "${CmdletName}: Set the UNCServerName property on instance of NTEventLogEventConsumer"
				}
				else
				{
					Write-Verbose -Message "${CmdletName}: `${UNCServerName} not specified."
				}
				
				if (${SourceName})
				{
					${NewConsumer}.SourceName = ${SourceName}
					Write-Verbose "${CmdletName}: Set the SourceName property on instance of NTEventLogEventConsumer"
				}
				else
				{
					Write-Warning -Message "${CmdletName}: `${SourceName} parameter not specified."
				}

				if (${Category})
				{
					${NewConsumer}.Category = ${Category}
					Write-Verbose "${CmdletName}: Set the Category property on instance of NTEventLogEventConsumer"
				}
				else
				{
					Write-Warning -Message "${CmdletName}: `${Category} parameter not specified."
				}
				
				# TEST CODE ONLY
				# TODO (DONE): IMPORTANT: Remove test code
				# ${NewConsumer}.SourceName = 'blah'
				# ${NewConsumer}.Category = 1
				# END TEST CODE ONLY
				
				${PutResult} = ${NewConsumer}.Put()
				
				if ($?)
				{
					if ($Error[0].Details.Message -eq 'Illegal null value ')
					{
						Write-Error -Message "One or more mandatory properties were not specified for NTEventLogEventConsumer."
					}
				}
				Write-Verbose "${CmdletName}: Wrote NTEventLogEventConsumer instance to provider."
				
				Write-Output -InputObject $([wmi]"$(${PutResult}.{Path})")
			}
			#endregion NTEventLogEventConsumer
			
			# If, somehow, an invalid ${ConsumerType} is specified, then throw an exception.
			# This shouldn't be possible, because the parameter is being validated against a set.
			default
			{
				throw "Unrecognized WMI event consumer type. Please use one of the following five values: Script, CommandLine, SMTP, LogFile, EventLog"
			}
			
		} #END switch

		# Check to ensure that 
		if ({PutResult}.{Path})
		{
			Write-Error -Message "Failed to commit WMI event consumer instance to provider."
		}
	}
	#endregion New-WmiEventConsumer process block
	
	#region New-WmiEventConsumer End block
	# This is the end block for New-WmiEventConsumer
	end
	{
		Write-Verbose -Message "${CmdletName}: Running END block"
	}
	#endregion New-WmiEventConsumer End block
}
#endregion New-WmiEventConsumer

# Export the advanced function for use in the module
Export-ModuleMember -Function New-WmiEventConsumer

# Set and export an alias for the advanced function
Set-Alias -Name nwmic -Value New-WmiEventConsumer
Export-ModuleMember -Alias nwmic