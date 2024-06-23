task :feed_transactions_to_sidekiq, [:csv, :batch_size] => :environment do |task, args|
    args.with_defaults(:csv => '1000_transactions.csv', :batch_size => 1000)
    filename = "/rails/#{args[:csv]}"

    batchCount = 0
    batch = []

    # @TODO add ability to skip first N rows
    CSV.foreach(filename) do |row|
        next if row[0] === 'branch'

        batchCount += 1
        batch << row
        
        if batchCount % args[:batch_size] === 0
            UpsertTransactionJob.perform_async(batch)

            puts batchCount.to_fs(:delimited)

            batch = []
        end
    end

    UpsertTransactionJob.perform_async(batch)

    puts batchCount.to_fs(:delimited)
end
