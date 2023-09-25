#!/usr/bin/env bash

# Disable hugepages
echo "Disable transparent_hugepage"
sudo bash -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled"
