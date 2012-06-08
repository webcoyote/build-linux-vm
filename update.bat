@echo off

:: make folder to share data between host computer and guest VMs
if not exist C:\vm_data\NUL mkdir c:\vm_data

:: install/update chef cookbook
call librarian-chef update %*
