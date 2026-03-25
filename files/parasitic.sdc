################################################################################
#
# Design name:  top
#
# Created by icc2 write_sdc on Mon Dec  9 15:12:55 2024
#
################################################################################

set sdc_version 2.1
set_units -time ns -resistance MOhm -capacitance fF -voltage V -current uA

################################################################################
#
# Units
# time_unit               : 1e-09
# resistance_unit         : 1000000
# capacitive_load_unit    : 1e-15
# voltage_unit            : 1
# current_unit            : 1e-06
# power_unit              : 1e-12
################################################################################


# Mode: func
# Corner: fast
# Scenario: func_fast

# /home/924314024/ENGR852/outputs/tmp11.sdc, line 9
create_clock -name ideal_clock1 -period 0.9 -waveform {0 0.45} [get_ports \
    {clock}]
set_propagated_clock [get_clocks {ideal_clock1}]
# Warning: Libcell power domain derates are skipped!

# Set latency for io paths.
# -origin user
set_clock_latency -min 0.012455 [get_clocks {ideal_clock1}]
# -origin user
set_clock_latency -max 0.0124931 [get_clocks {ideal_clock1}]
# Set propagated on clock sources to avoid removing latency for IO paths.
set_propagated_clock  [get_ports {clock}]
