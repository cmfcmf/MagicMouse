# MagicMouse

A Chrome browser... in Squeak!

## Dependencies

```
MCMcmUpdater updateFromRepository: 'http://www.squeaksource.com/OSProcess'.

(Installer repository: 'http://source.squeak.org/FFI')
    install: 'FFI-Pools';
    install: 'FFI-Kernel'.

Installer monticello http: 'http://www.squeaksource.com';
     project: 'ProcessWrapper';
     install: 'ProcessWrapper-Core'.
```