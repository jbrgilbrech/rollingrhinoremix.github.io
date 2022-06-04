#### Name

Windows - Start Quick Assist Session | v1.1 JCCG

#### commandType

windows

#### Command

```
install-module RunAsUser -force
$Command = {

C:\Windows\System32\quickassist.exe

}
```

#### Description

Executes 'Windows 10 Quick Assist' application as the currently logged on user. The command will fail if no user is logged in.

#### *Import This Command*

To import this command into your JumpCloud tenant run the below command using the [JumpCloud PowerShell Module](https://github.com/TheJumpCloud/support/wiki/Installing-the-JumpCloud-PowerShell-Module)

```
Import-JCCommand -URL 'https://git.io/Jv5eg'
```
