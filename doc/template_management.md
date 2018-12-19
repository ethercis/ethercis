# Template Maintenance

## Manages Referential Integrity

### Operational Templates List

#### Windows

	dir /b /a-d C:\Users\christian\Documents\EtherCIS\home\etc\knowledge\operational_templates\*.opt >\Development\test\operational_templates_list.txt

#### Linux

	find /etc/opt/ecis/knowledge/operational_templates/ -maxdepth 1 -type f -printf "%f\n" >/tmp/operational_templates_list.txt