#!/usr/bin/env bash

# Disable hugepages
sudo bash -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled"
