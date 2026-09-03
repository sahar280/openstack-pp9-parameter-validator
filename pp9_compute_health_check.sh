#!/bin/bash

# Command to execute (replace with your command)
command_output=$(sudo cat /usr/share/cbis/nuage-version)
echo $command_output
# Expected text
expected_text="<EXPECTED_NUAGE_VERSION>"
# Compare the command output with the expected text
if [ "$command_output" = "$expected_text" ]; then
    echo "Nuage version is correct"
else
    echo "Nuage version is not correct"
fi

command_output=$(cat /etc/cpuset.env | grep "CPUSET_ENABLE")
echo $command_output
# Expected text
expected_text=": \${CPUSET_ENABLE:=1}"  # Updated for escaping
# Compare the command output with the expected text
if [ "$command_output" = "$expected_text" ]; then
    echo "CPUSET enabled"
else
    echo "CPUSET disabled"
fi

command_output=$(ovs-appctl -V | grep ovs )
echo $command_output
# Expected text
expected_text="ovs-appctl (Open vSwitch) <EXPECTED_OVS_VERSION>"

# Compare the command output with the expected text
if [ "$command_output" = "$expected_text" ]; then
    echo "Correct Ovs Version"
else
    echo "Incorrect Ovs Version"
fi

command_output=$(cat /etc/systemd/system.conf | grep -i cpu | head -n 1)
echo $command_output
# Expected text
expected_text="CPUAffinity=<SYSTEM_CPU_LIST>"  # Updated for escaping

# Compare the command output with the expected text
if [ "$command_output" = "$expected_text" ]; then
    echo "Correct CPU Affinity"
else
    echo "Incorrect CPU Affinity"
fi

command_output=$(sudo cat /etc/nova/nova.conf | grep -i vcpu)
echo $command_output
# Expected text
expected_text="vcpu_pin_set = <VCPU_PIN_SET>"  # Updated for escaping
# Compare the command output with the expected text
if [ "$command_output" = "$expected_text" ]; then
    echo "Correct CPU set" 
else
    echo "Incorrect CPU set"
fi

# Capture the output of 'taskset -cp "$(pidof ovs-vswitchd)"' command
command_output=$(taskset -cp "$(pidof ovs-vswitchd)")

# Extract the part after ":" from the command output
command_output=$(echo "$command_output" | awk -F': ' '{print $2}')
echo $command_output
# Define the expected output
expected_output="<OVS_AFFINITY_LIST>"
if [ "$command_output" = "$expected_output" ]; then
    echo "Correct affinity list"
else
    echo "Incorrect affinity list"
fi

# Capture the output of '/etc/fast-path.env' and save it to a file
cat /etc/fast-path.env > output.txt
reference_file="temp_reference.txt"
# Create the temporary reference file with the reference text, removing leading/trailing spaces
echo ": \${FP_OFFLOAD:=off}" | sed 's/ //g' > "$reference_file"
echo ": \${FP_MASK:=<FAST_PATH_CPU_MASK>}" | sed 's/ //g' >> "$reference_file"
echo ": \${DPVI_MASK:=<DPVI_CPU_MASK>}" | sed 's/ //g' >> "$reference_file"
echo ": \${FPNSDK_OPTIONS:=<FAST_PATH_NSDK_OPTIONS>}" | sed 's/ //g' >> "$reference_file"
echo ": \${VM_MEMORY:=<VM_MEMORY_ALLOCATION>}" | sed 's/ //g' >> "$reference_file"
echo ": \${FP_OPTIONS:=<FAST_PATH_OPTIONS>}" | sed 's/ //g' >> "$reference_file"
echo ": \${FP_PORTS:= <PCI_PORT_LIST>}" | sed 's/ //g' >> "$reference_file"
echo ": \${NB_MBUF:=<MBUF_ALLOCATION>}" | sed 's/ //g' >> "$reference_file"
# Sort both files according to the data before ":="
sort -t= -k2 -o output.txt output.txt
sort -t= -k2 -o "$reference_file" "$reference_file"
sed -i 's/ //g' output.txt
# Compare the sorted contents of the reference file and the output file
if diff -q -B "$reference_file" output.txt > /dev/null; then
    echo "Correct Fast Path parameters"
else
    echo "Incorrect Fast Path parameters"
fi
# Remove the temporary reference file and output file
rm -f "$reference_file" output.txt


# Get the count of lines containing "dpvi-poll"
count=$(ps aux | grep -i 'dpvi-poll' | grep -v 'grep' | wc -l)
# Check if the count is equal to 6
if [ "$count" -eq "<EXPECTED_DPVI_POLL_COUNT>" ]; then
    echo "Correct DPVI polls"
else
    echo "Incorrect DPVI polls"
fi

response=$(sudo ovs-vsctl show | grep is_connected)
echo $response
# Check if the response contains "true"
if echo "$response" | grep -q "true"; then
    echo "Response is true"
else
    echo "Response is false"
fi

# Command to execute (replace with your command)
command_output=$(cat /etc/default/openvswitch|grep BRIDGE_MTU=)
echo $command_output
# Expected text
expected_text="BRIDGE_MTU=<EXPECTED_MTU>"
# Compare the command output with the expected text
if [ "$command_output" = "$expected_text" ]; then
    echo "Correct MTU"
else
    echo "Incorrect MTU"
fi

# Command to execute (replace with your command)
command_output=$(getenforce)
echo $command_output
# Expected text
expected_text="Permissive"
# Compare the command output with the expected text
if [ "$command_output" = "$expected_text" ]; then
    echo "getenforce Permissive"
else
    echo "getenforce not permissive"
fi
