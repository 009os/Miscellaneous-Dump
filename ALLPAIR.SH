#!/bin/bash

# Get the current script directory
script_dir=$(dirname "$0")

# Predefined intervals
intervals=("1m" "3m" "5m" "15m" "30m" "1h" "2h" "4h" "6h" "8h" "12h" "1d")

# Date for which we want to download the klines (22 October 2024)
target_date="2024-10-22"

# Extract year, month, and day from target date
year=$(date -j -f "%Y-%m-%d" "$target_date" +%Y)
month=$(date -j -f "%Y-%m-%d" "$target_date" +%m)
day=$(date -j -f "%Y-%m-%d" "$target_date" +%d)

# List of coin pairs
symbols=(
    "FLUXUSDT" "1000CATUSDT" "COTIUSDT" "CRVUSDT" "LDOUSDT" "XLMUSDT" "1MBABYDOGEUSDT" 
    "MEMEUSDT" "NULSUSDT" "MEWUSDT" "SCRUSDT" "SOLUSDT" "CATIUSDT" "BANANAUSDT"
    "ARPAUSDT" "RENDERUSDT" "APEUSDT" "TLMUSDT" "WLDUSDT" "LINKUSDT" "VIDTUSDT"
    "ADAUSDT" "MANTAUSDT" "JASMYUSDT" "VETUSDT" "THETAUSDT" "ETHUSDT" "POPCATUSDT"
    "BOMEUSDT" "IOUSDT" "PEOPLEUSDT" "BBUSDT" "SUIUSDT" "ONDOUSDT" "VOXELUSDT" 
    "HIGHUSDT" "LOKAUSDT" "CHESSUSDT" "RPLUSDT" "ARUSDT" "GRTUSDT" "1000PEPEUSDT"
    "ENAUSDT" "1000SHIBUSDT" "ZRXUSDT" "JTOUSDT" "TONUSDT" "TNSRUSDT" "LISTAUSDT"
    "FETUSDT" "NEOUSDT" "GHSTUSDT" "STXUSDT" "ATOMUSDT" "DARUSDT" "GALAUSDT"
    "ARBUSDT" "ORDIUSDT" "1000SATSUSDT" "1000BONKUSDT" "SYSUSDT" "SAGAUSDT"
    "BIGTIMEUSDT" "POLUSDT" "SYNUSDT" "HMSTRUSDT" "HIFIUSDT" "PENDLEUSDT" "WUSDT"
    "RAREUSDT" "HBARUSDT" "1000RATSUSDT" "BNBUSDT" "POLYXUSDT" "TIAUSDT" "TAOUSDT"
    "CFXUSDT" "REEFUSDT" "EIGENUSDT" "BCHUSDT" "LOOMUSDT" "FTMUSDT" "UNIUSDT"
    "RUNEUSDT" "UXLINKUSDT" "ARKMUSDT" "NFPUSDT" "BTCUSDT" "BRETTUSDT" "FIOUSDT"
    "BSWUSDT" "CHZUSDT" "DOGEUSDT" "OPUSDT" "KDAUSDT" "QUICKUSDT" "NEIROUSDT"
    "XRPUSDT" "MKRUSDT" "NEARUSDT" "SUNUSDT" "ALPACAUSDT" "KASUSDT" "WIFUSDT"
    "NMRUSDT" "AAVEUSDT" "RSRUSDT" "NOTUSDT" "SEIUSDT" "AVAXUSDT" "AERGOUSDT"
    "FILUSDT" "DOGSUSDT" "MBOXUSDT" "OMUSDT" "ICPUSDT" "PIXELUSDT" "ZROUSDT"
    "TURBOUSDT" "TRXUSDT" "CELOUSDT" "1000FLOKIUSDT" "DOTUSDT" "GUSDT" "AEVOUSDT"
    "LTCUSDT" "INJUSDT" "STRKUSDT" "PYTHUSDT" "IMXUSDT" "FIDAUSDT" "REIUSDT"
    "DIAUSDT" "COSUSDT" "APTUSDT" "VANRYUSDT" "MYROUSDT"
)

# Create a folder named klines to store all the downloaded files
folder_name="$script_dir/klines"
mkdir -p "$folder_name"

# Loop over each symbol
for symbol in "${symbols[@]}"; do
    # Loop over each interval (predefined)
    for interval in "${intervals[@]}"; do
        # Set the base URL using the provided symbol and interval
        base_url="https://data.binance.vision/data/futures/um/daily/klines/$symbol/$interval"

        # Construct the filename
        file_name="$symbol-$interval-$year-$month-$day.zip"

        # Construct the full URL
        url="$base_url/$file_name"

        # Download the file using curl into the klines folder
        echo "Downloading $url for $symbol ($interval)..."
        curl -s "$url" -o "$folder_name/$file_name"
    done

    echo "Download for $symbol completed."
done

echo "All downloads for October 22, 2024, completed. Files are saved in $folder_name."
