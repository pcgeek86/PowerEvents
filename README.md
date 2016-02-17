**IMPORTANT**: To get started:

1. Please read the documentation included in the module folder
2. Watch the [YouTube videos](https://www.youtube.com/playlist?list=PLDbRgZ0OOEpVsGfj4SMGG6quUK9BRPuTF)
3. Review the sample code in the \Samples folder

# What is PowerEvents?

PowerEvents is a Windows PowerShell module designed to facilitate the ease of creating, updating, and deleting WMI (Windows Management Instrumentation) permanent event registrations. PowerEvents makes it easy to create WMI event filters (define the events you want to capture) and event consumers (responders to events), and then bind them together to initiate the flow of events. By leveraging permanent event registrations, you can perform advanced monitoring functions on a workstation or server, that would otherwise require implementation of an enterprise monitoring product. Because WMI is incredibly vast in the information it provides, very detailed monitoring can be performed using almost any of the WMI objects that exist on a computer.

# What are WMI Permanent Event Registrations?

A little-known capability of the WMI service, is its capability to create a permanent registration (listener) for events, and then automatically respond to those events. At a very basic level, it's "if X happens, do Y" but in this case, it's all built into WMI, without the need for any additional software.

# What Events Can I Monitor with PowerEvents?

WMI contains a vast amount of information about the Windows operating system, the hardware underneath it, and applications that extend WMI.

Here are a very few examples of events that you can monitor in WMI:

- Microsoft Active Directory
  - Changes in group policy configuration on GP clients
  - Users created or deleted
  - Computer accounts moved
- Microsoft System Center Configuration Manager
  - Package created, deleted, or modified
  - Advertisement created, deleted, or modified
  - Collection created, deleted, or modified
- Monitor Disk Events
  - USB flash (UFD) or eSATA drive plugged in or removed
  - Detect shrink or expansion of partitions
- Monitor Processes
  - Start/stop events
  - Change in process priority
  - Working set (memory utilization) increase/decrease or exceeds "X" value
  - I/O operations increase or exceed a certain value
- Windows Services
  - Start / stop events
  - New service installed or removed
  - Service start type changed
- Device changes
  - Detect addition or removal of devices
- Print jobs
  - Detect new job or finished job
  - Changes in job status
- Software & Patches
  - Software installed or removed
  - New patches installed
- Operating System
  - New reliability records created
  - New game registered with Windows 7 Games Explorer
- User Events
  - User logon / logoff
  - Changes to user attributes
- Network
  - IP address changed
  - Default gateway changed
  - Network adapter added or removed
  - Server Message Block (SMB) session created or ended
- ODBC Data Sources
  - Created or removed
  - Driver installed
  - Configuration changed
- Threads
  - Creation or termination
  - Thread state changes
- Microsoft Distributed File System (DFS)
  - Last replication time changes
  - Errors during replication
  - Volume serial # changes

# Why Should I use PowerEvents?

Because it's awesome, and it helps you monitor for low-level system events that were previously quite challenging to find! The capabilities of this module are quite vast, only limited by the information available in WMI. Because many applications extend WMI through WMI providers, these can be not just managed, but also extensively monitored. Additionally, the Windows operating system itself makes extensive use of WMI to provide system information to applications. Through this, you can discover and monitor almost anything you'd want to know about your workstation or server!

- Microsoft Active Directory (AD)
- SQL Server
- Distributed FileSystem (DFS)
- Microsoft DNS
- System Center Configuration Manager (SCCM or ConfigMgr)
- Internet Information Services (IIS) 6 / 7
- Windows XP / Vista / 7
- Windows Server 2003 / 2008 / 2008 R2

# About the Author

Twitter: https://twitter.com/pcgeek86

Website: https://trevorsullivan.net
