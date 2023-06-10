# Dynamic MOTD

This is a dynamic motd that allows you to create custom scripts that will generate output to motd. It is similar to what Ubuntu uses except that this is written in pure bash along with all of the pre-built system state scripts. The complete set of scripts provided here mimics Ubuntu's system info python collection that is used on their server versions, but also allows you to add additional information that will integrate into the same list. This will also work on both local Shell/TTY login as well as SSH remote login.

This is not distro depended. It should work on most distro's, and I say most because I cannot test and garantee every single one with certainty. 


### Example

```sh
Manjaro Linux (Linux 6.0.19 x86_64)
AMD Ryzen 5 3600 6-Core Processor
15915 MiB of memory

  System information as of sat jun 10 21:59:55 2023

      .--.     
     |o_o |     _   _
     |:_/ |    | | (_)_ __  _   ___  __ 
    //   \ \   | | | | '_ \| | | \ \/ /
   (|     | )  | |_| | | | | |_| |>  <  
  /'\_   _/`\  |___|_|_| |_|\__._/_/\_\
  \___)=(___/  

  Last Boot           2023-06-10 12:39
  System load         0.02↑
  Memory usage        17%
  Swap usage          0%
  Temperature         32.0°C
  Processes           484
  Active users        3
  IPv4 for enp1s0     192.168.1.2 

13 updates can be applied immediately.
To see these additional updates run: checkupdates

┌─┘root@desktop└─ /~
└─╼ #
```


### Install

This is easy. Just download the repo and run the `install.sh` script. It will deal with everything.


### Create custom scripts

Create an `.sh` file in the `/etc/rc.motd.d/` directory. It will display whatever the script outputs. 

The output from `motd` is assembled using 3 destinct blocks that any script can use to define where the output is to be displayed, `@head`, `@body` and `@list`. 

The `@list` is a one-line output that is split into two parts `Header: Content`. This will be displayed in the list below other list content that came before it. 

The `@head` and `@body` are multi-line blocks and will continue until a new block is defined. Each time the same block is defined, a new block wrapper will start. The `@body` is the default if nothing is defined. 

```sh
#!/bin/bash

echo "This is a body text."
echo "It will be displayed below the list."

echo "@list A list header: Some data for it"
echo "@list Another header: Some more data"

echo "@head"
echo "This is head text."
echo "This is displayed before any list and body content."

echo "@body"
echo "This is another body text."
echo "It will be displayed below the first one."
```

```
This is head text.
This is displayed before any list and body content.

  A list header     Some data for it
  Another header    Some more data
  
This is a body text.
It will be displayed below the list.

This is another body text.
It will be displayed below the first one.

┌─┘root@desktop└─ /~
└─╼ #
```

