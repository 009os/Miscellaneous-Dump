#!/bin/bash

# Define the coin symbol, interval, and specific date range
symbol="BTCUSDT"
interval="1s"
start_date="2024-11-26"
end_date="2024-11-26"

# Create nested folders: one for the symbol and another inside it for the interval
output_folder="${symbol}/${interval}"
mkdir -p "$output_folder"

# Convert start and end dates to seconds since epoch for iteration
start_epoch=$(date -j -f "%Y-%m-%d" "$start_date" +%s)
end_epoch=$(date -j -f "%Y-%m-%d" "$end_date" +%s)

# Set the base URL using the provided symbol and interval
base_url="https://data.binance.vision/data/futures/um/daily/klines/$symbol/$interval"

# Iterate over each day between the start date and end date
while [ "$start_epoch" -le "$end_epoch" ]; do
    # Extract year, month, and day for URL construction
    year=$(date -j -f "%s" "$start_epoch" +%Y)
    month=$(date -j -f "%s" "$start_epoch" +%m)
    day=$(date -j -f "%s" "$start_epoch" +%d)

    # Construct the filename
    file_name="$symbol-$interval-$year-$month-$day.zip"

    # Construct the full URL
    url="$base_url/$file_name"

    # Download the file using curl into the appropriate folder
    echo "Downloading $url..."
    curl -s "$url" -o "$output_folder/$file_name"

    # Increment the date by one day (86400 seconds)
    start_epoch=$(($start_epoch + 86400))
done

echo "Download completed for BTCUSDT data on $start_date. Files are saved in $output_folder."