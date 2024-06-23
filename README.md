# Ruby on Rails 100M bank transactions import & reporting

## Usage

```bash
# start project
docker compose up -d

# generate csv file with 100M randomized transactions
# measure the duration
#
# on the authors development machine, the execution time and resource usage was as follows:
# - 1K rows: ~0.7 second
# - 1M rows: ~2.7 seconds
# - 100M rows: ~3.15 minutes
#
# for storage reasons, only the 1000_transactions.csv file is included in this git repository
# the 1M file is 21MB and 100M file is 2GB
time docker compose exec rails bin/rails 'generate_transactions_csv[100000000]'
```

### URLs

- Web http://localhost:3000
