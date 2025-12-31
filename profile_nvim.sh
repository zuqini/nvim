#!/bin/bash
#
# Profile Neovim startup time by running nvim multiple times and calculating
# statistics (min, max, median, mean, variance, std dev). Results are saved
# to a timestamped directory along with individual startup logs.
#
# Usage: ./profile_nvim.sh [count]
#   count: number of times to run nvim (default: 10)

set -e

count="${1:-10}"
timestamp=$(date +%Y%m%d_%H%M%S)
output_dir="profile_result_$timestamp"
result_file="$output_dir/profile_result.txt"
times_file="$output_dir/.times.tmp"

if ! [[ "$count" =~ ^[0-9]+$ ]] || [ "$count" -lt 1 ]; then
    echo "Usage: $0 <count>"
    echo "  count: number of times to run nvim (positive integer)"
    exit 1
fi

mkdir -p "$output_dir"
: > "$times_file"

echo "Profiling nvim startup $count times..."
echo

for i in $(seq 1 "$count"); do
    log_file="$output_dir/startuptime_$i.log"

    nvim --startuptime "$log_file" +'autocmd UIEnter * ++once qa!'

    sleep 0.3

    startup_time=$(grep -e "NVIM STARTED" "$log_file" | tail -1 | awk '{print $1}')

    if [ -n "$startup_time" ]; then
        echo "$startup_time" >> "$times_file"
        printf "Run %3d: %s ms\n" "$i" "$startup_time"
    else
        echo "Run $i: Failed to parse startup time"
    fi
done

echo
echo "Calculating statistics..."

{
    echo "=== Neovim Startup Time Profile ==="
    echo "Date: $(date)"
    echo "Runs: $count"
    echo
    echo "--- Individual Times (ms) ---"
    n=1
    while read -r t; do
        printf "Run %3d: %s\n" "$n" "$t"
        n=$((n + 1))
    done < "$times_file"
    echo
    echo "--- Statistics ---"

    sort -n "$times_file" | awk '
    BEGIN { n = 0; sum = 0 }
    {
        times[NR] = $1
        sum += $1
        n++
        if (NR == 1) { min = $1; max = $1 }
        if ($1 < min) min = $1
        if ($1 > max) max = $1
    }
    END {
        if (n == 0) {
            print "No data"
            exit
        }
        mean = sum / n

        if (n % 2 == 1) {
            median = times[(n + 1) / 2]
        } else {
            median = (times[n / 2] + times[n / 2 + 1]) / 2
        }

        variance = 0
        for (i = 1; i <= n; i++) {
            variance += (times[i] - mean) ^ 2
        }
        variance = variance / n
        stddev = sqrt(variance)

        printf "Count:    %d\n", n
        printf "Min:      %.3f ms\n", min
        printf "Max:      %.3f ms\n", max
        printf "Median:   %.3f ms\n", median
        printf "Mean:     %.3f ms\n", mean
        printf "Variance: %.3f ms²\n", variance
        printf "Std Dev:  %.3f ms\n", stddev
    }'
} | tee "$result_file"

rm -f "$times_file"

echo
echo "Results saved to: $result_file"
echo "Individual logs in: $output_dir/"
