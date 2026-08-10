import glob
import csv
import json
import os

def convert():
    assets_dir = os.path.join(os.path.dirname(__file__), 'assets', 'otheroffices')
    csv_pattern = os.path.join(assets_dir, '*.csv')
    csv_files = sorted(glob.glob(csv_pattern))
    
    print(f"Found {len(csv_files)} CSV files in {assets_dir}:")
    for f in csv_files:
        print(f"  - {os.path.basename(f)}")

    records = []
    seen = set()

    for file_path in csv_files:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as fp:
            reader = csv.DictReader(fp)
            for row in reader:
                clean_row = {k.strip(): v.strip() for k, v in row.items() if k}
                
                sortplan_id = clean_row.get('Sortplan Id', '')
                l1_name = clean_row.get('L1 Office Name', '')
                l2_name = clean_row.get('L2 Office Name', '')
                hub_level = clean_row.get('Hub Level', '')
                circle_name = clean_row.get('Circel Name', clean_row.get('Circle Name', ''))
                from_pin = clean_row.get('From Pin', '')
                to_pin = clean_row.get('To Pin', '')
                
                item = {
                    'sortplanId': sortplan_id,
                    'l1OfficeName': l1_name,
                    'l2OfficeName': l2_name,
                    'hubLevel': hub_level,
                    'circleName': circle_name,
                    'fromPin': from_pin,
                    'toPin': to_pin
                }
                
                tup = (sortplan_id, l1_name, l2_name, hub_level, circle_name, from_pin, to_pin)
                if tup not in seen:
                    seen.add(tup)
                    records.append(item)

    out_path = os.path.join(assets_dir, 'other_offices.json')
    with open(out_path, 'w', encoding='utf-8') as fp:
        json.dump(records, fp, separators=(',', ':'))

    print(f"\nSuccessfully written {len(records)} records to {out_path}")
    print(f"File size: {os.path.getsize(out_path) / (1024*1024):.2f} MB")

if __name__ == '__main__':
    convert()
