#!/bin/bash

# Get the current script directory
script_dir=$(dirname "$0")

# Predefined intervals
intervals=("1m")

# Prompt the user to enter multiple trading pair symbols
echo "Enter the trading pair symbols separated by spaces (e.g., ETHUSDT BTCUSDT SOLUSDT):"
read -p "Trading pair symbols: " -a symbols

# Check if the symbols array is empty
if [ ${#symbols[@]} -eq 0 ]; then
    echo "You must provide at least one trading pair symbol."
    exit 1
fi

# Convert all symbols to uppercase
for i in "${!symbols[@]}"; do
    symbols[$i]=$(echo "${symbols[$i]}" | tr '[:lower:]' '[:upper:]')
done

# Create an array to store folder names for each symbol
folder_names=()

# Ask for folder names corresponding to each symbol
for symbol in "${symbols[@]}"; do
    read -p "Enter the folder name where you want to download data for $symbol: " folder_name
    folder_names+=("$folder_name")
done

# Prompt the user to choose single or multiple date range
read -p "Do you want to download data for a single date or multiple dates? (s/m): " date_choice

# Normalize the user input to lowercase for easier checking
date_choice=$(echo "$date_choice" | tr '[:upper:]' '[:lower:]')

# Function to validate date format
validate_date() {
    if ! date -j -f "%Y-%m-%d" "$1" +%Y-%m-%d >/dev/null 2>&1; then
        echo "Invalid date format. Please enter the date in YYYY-MM-DD format."
        exit 1
    fi
}

# Initialize start and end dates based on user input
if [ "$date_choice" == "s" ]; then
    read -p "Enter the date (YYYY-MM-DD): " date
    validate_date "$date"
    start_date=$date
    end_date=$date
elif [ "$date_choice" == "m" ]; then
    read -p "Enter the start date (YYYY-MM-DD): " start_date
    validate_date "$start_date"
    read -p "Enter the end date (YYYY-MM-DD): " end_date
    validate_date "$end_date"
else
    echo "Invalid choice. Please run the script again and select 's' for single or 'm' for multiple."
    exit 1
fi

# Convert start and end dates to seconds since epoch for comparison
start_epoch=$(date -j -f "%Y-%m-%d" "$start_date" +%s)
end_epoch=$(date -j -f "%Y-%m-%d" "$end_date" +%s)

# Loop over each symbol
for i in "${!symbols[@]}"; do
    symbol="${symbols[$i]}"
    folder_name="${folder_names[$i]}"

    # Create the download folder inside the same directory as the script
    download_path="$script_dir/$folder_name"
    mkdir -p "$download_path"

    # Loop over each interval (predefined)
    for interval in "${intervals[@]}"; do
        # Create a folder for each symbol/interval combination
        output_folder="$download_path"
        mkdir -p "$output_folder"
        
        # Set the base URL using the provided symbol and interval
        base_url="https://data.binance.vision/data/futures/um/daily/klines/$symbol/$interval"

        # Reset the start_epoch for each symbol/interval loop
        current_epoch=$start_epoch
        
        # Iterate over each day between the start date and end date
        while [ "$current_epoch" -le "$end_epoch" ]; do
            # Extract year, month, and day for URL construction
            year=$(date -j -f "%s" "$current_epoch" +%Y)
            month=$(date -j -f "%s" "$current_epoch" +%m)
            day=$(date -j -f "%s" "$current_epoch" +%d)

            # Construct the filename
            file_name="$symbol-$interval-$year-$month-$day.zip"

            # Construct the full URL
            url="$base_url/$file_name"

            # Download the file using curl into the appropriate folder
            echo "Downloading $url for $symbol ($interval)..."
            curl -s "$url" -o "$output_folder/$file_name"

            # Increment the date by one day (86400 seconds)
            current_epoch=$(($current_epoch + 86400))
        done

        echo "Download for $symbol ($interval) completed. Files are saved in $output_folder."
    done
done

echo "All downloads completed."
