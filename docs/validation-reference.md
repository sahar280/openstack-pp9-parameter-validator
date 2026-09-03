# Validation Reference

This document explains the original script's output without changing its logic.

| Result area | Success message | Failure message |
|---|---|---|
| Nuage version | `Nuage version is correct` | `Nuage version is not correct` |
| CPUSET | `CPUSET enabled` | `CPUSET disabled` |
| OVS version | `Correct Ovs Version` | `Incorrect Ovs Version` |
| CPU affinity | `Correct CPU Affinity` | `Incorrect CPU Affinity` |
| Nova CPU set | `Correct CPU set` | `Incorrect CPU set` |
| OVS affinity | `Correct affinity list` | `Incorrect affinity list` |
| Fast path | `Correct Fast Path parameters` | `Incorrect Fast Path parameters` |
| DPVI polls | `Correct DPVI polls` | `Incorrect DPVI polls` |
| OVS connection | `Response is true` | `Response is false` |
| Bridge MTU | `Correct MTU` | `Incorrect MTU` |
| SELinux mode | `getenforce Permissive` | `getenforce not permissive` |

The script also prints selected raw command values before some result messages.
Do not publish real execution output without removing production identifiers.
