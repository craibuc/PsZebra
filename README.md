# PsZebra
PowerShell module to interact with Zebra printers.

## Installation

## Usage

### Out-Printer

```powershell
'^FT78,76^A0N,28,28^FH\^FDHello, World!^FS' | Out-ZebraPrinter -IpAddress 10.10.10.10 -Port 9100
```

## Contributors

- [Craig Buchanan](https://github.com/craibuc/)

## Reference

- [ZPL Command Information and Details](https://www.zebra.com/us/en/support-downloads/knowledge-articles/zpl-command-information-and-details.html)
