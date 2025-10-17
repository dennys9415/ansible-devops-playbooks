#!/usr/bin/env python3

import argparse
import json
import subprocess
import sys
from pathlib import Path

def run_ansible_inventory(inventory_path):
    """Run ansible-inventory command and return JSON output"""
    try:
        result = subprocess.run(
            ['ansible-inventory', '-i', inventory_path, '--list'],
            capture_output=True,
            text=True,
            check=True
        )
        return json.loads(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Error running ansible-inventory: {e}")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON output: {e}")
        sys.exit(1)

def analyze_inventory(inventory_data):
    """Analyze inventory data and generate report"""
    report = {
        'hosts': {},
        'groups': {},
        'summary': {
            'total_hosts': 0,
            'total_groups': 0,
            'hosts_by_group': {}
        }
    }
    
    # Process hosts
    for hostname, host_data in inventory_data.items():
        if hostname in ['_meta', 'all']:
            continue
            
        if 'hosts' in host_data:
            # This is a group
            report['groups'][hostname] = {
                'hosts': host_data['hosts'],
                'vars': host_data.get('vars', {}),
                'children': host_data.get('children', [])
            }
            report['summary']['hosts_by_group'][hostname] = len(host_data['hosts'])
        else:
            # This is a host
            report['hosts'][hostname] = {
                'vars': host_data.get('vars', {}),
                'groups': []
            }
    
    # Find groups for each host
    for group_name, group_data in report['groups'].items():
        for hostname in group_data['hosts']:
            if hostname in report['hosts']:
                report['hosts'][hostname]['groups'].append(group_name)
    
    report['summary']['total_hosts'] = len(report['hosts'])
    report['summary']['total_groups'] = len(report['groups'])
    
    return report

def print_report(report, output_format='text'):
    """Print inventory analysis report"""
    if output_format == 'json':
        print(json.dumps(report, indent=2))
        return
    
    # Text format
    print("=" * 60)
    print("ANSIBLE INVENTORY ANALYSIS REPORT")
    print("=" * 60)
    
    print(f"\nSUMMARY:")
    print(f"  Total Hosts: {report['summary']['total_hosts']}")
    print(f"  Total Groups: {report['summary']['total_groups']}")
    
    print(f"\nHOSTS BY GROUP:")
    for group, count in report['summary']['hosts_by_group'].items():
        print(f"  {group}: {count} hosts")
    
    print(f"\nDETAILED HOST INFORMATION:")
    for hostname, host_info in report['hosts'].items():
        print(f"\n  Host: {hostname}")
        print(f"    Groups: {', '.join(host_info['groups'])}")
        if host_info['vars']:
            print(f"    Variables: {len(host_info['vars'])} defined")
    
    print(f"\nGROUP STRUCTURE:")
    for group_name, group_info in report['groups'].items():
        print(f"\n  Group: {group_name}")
        if group_info['children']:
            print(f"    Children: {', '.join(group_info['children'])}")
        if group_info['vars']:
            print(f"    Variables: {len(group_info['vars'])} defined")

def main():
    parser = argparse.ArgumentParser(description='Ansible Inventory Scanner')
    parser.add_argument('inventory', help='Path to inventory file or directory')
    parser.add_argument('--format', choices=['text', 'json'], default='text',
                       help='Output format (default: text)')
    
    args = parser.parse_args()
    
    inventory_path = Path(args.inventory)
    if not inventory_path.exists():
        print(f"Error: Inventory path '{args.inventory}' does not exist")
        sys.exit(1)
    
    inventory_data = run_ansible_inventory(str(inventory_path))
    report = analyze_inventory(inventory_data)
    print_report(report, args.format)

if __name__ == '__main__':
    main()