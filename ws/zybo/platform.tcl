# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home/oli/work/FHNW/CAS-MED/SoC/05_VersionControl/Samples/VitisZip/Before/ws/zybo/platform.tcl
# 
# OR launch xsct and run below command.
# source /home/oli/work/FHNW/CAS-MED/SoC/05_VersionControl/Samples/VitisZip/Before/ws/zybo/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {zybo}\
-hw {/home/oli/work/FHNW/CAS-MED/SoC/05_VersionControl/Samples/VitisZip/Before/bd_wrapper.xsa}\
-proc {ps7_cortexa9_0} -os {standalone} -out {/home/oli/work/FHNW/CAS-MED/SoC/05_VersionControl/Samples/VitisZip/Before/ws}

platform write
platform generate -domains 
platform active {zybo}
bsp reload
bsp config stdin "ps7_uart_1"
bsp config sleep_timer "ps7_globaltimer_0"
bsp write
bsp reload
catch {bsp regenerate}
domain create -name {free_rtos} -os {freertos} -proc {ps7_cortexa9_1} -arch {32-bit} -display-name {free_rtos} -desc {} -runtime {cpp}
platform generate -domains 
platform write
domain -report -json
bsp reload
bsp config tick_rate "1000"
bsp write
bsp reload
catch {bsp regenerate}
domain active {standalone_domain}
bsp write
platform generate
platform clean
platform generate
platform clean
platform generate
platform clean
platform active {zybo}
domain active {zynq_fsbl}
domain active {standalone_domain}
platform generate
bsp reload
bsp reload
bsp reload
domain active {free_rtos}
bsp reload
bsp reload
platform clean
platform generate
platform clean
platform clean
platform generate
