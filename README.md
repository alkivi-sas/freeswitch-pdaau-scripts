# freeswitch-PDAAU-scripts

LUA script to map french emergency number to real one.

## Description

Using insee_code and short number, this lua code / library will transfer the call to the real number.

## Getting Started

### Dependencies

* Module mod_lua installed and enabled on freeswitch
* The list of pdaa/caau sources (default path /var/lib/freeswitch/pdaau-sources)
  * The root folder should contain only 3 digits folder (001 002 ... 976 201 and 202 for special cases)
  * Root folder can be changed using ENV variable PDAAU_ROOT_DIR
* insee_code assigned to caller_id (TODO freeswitch receipe

### Installing

* Put pdaau.lua in the share folder (i.e /usr/local/share/lua/5.2/)
* Change freeswitch.lua according to your need
* Install the scripts in the freeswitch script folder (/usr/share/freeswitch/scripts)

### Usage

* Here is an extension that does the work
```
code blocks for commands
```

## Authors

[Anthony Martinet](https://github.com/martintamare) - [Alkivi](https://github.com/alkivi-sas)

## Version History

* 0.1
    * Initial Release

## License

This project is licensed under the LGPL-3 License - see the LICENSE file for details