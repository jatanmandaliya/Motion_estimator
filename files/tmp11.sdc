###################################################################

# Created by write_sdc on Mon Dec  9 13:46:35 2024

###################################################################
set sdc_version 2.0

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current uA
create_clock [get_ports clock]  -name ideal_clock1  -period 0.9  -waveform {0 0.45}
