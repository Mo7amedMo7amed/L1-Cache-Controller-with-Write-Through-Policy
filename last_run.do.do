# Modelsim Restart script
# written Sat Oct 21 02:28:31 +0300 2023
#         Stardate 77802.1

onerror {resume}

vsim -voptargs=+acc -l top


# Restore wave window wave0
view -create wave0
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Memory signals}
add wave -noupdate -divider {Cache signals}
add wave -noupdate -divider {Memory signals}
add wave -noupdate -divider {Cache signals}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 us}


# File breakpoints

# Signal breakpoints


echo Last Now: 0
# run 0

