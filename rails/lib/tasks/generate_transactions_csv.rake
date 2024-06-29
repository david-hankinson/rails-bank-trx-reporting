task :generate_transactions_csv, [:rows] => :environment do |task, args|
    args.with_defaults(:rows => 10)
    filename = "#{args[:rows]}_transactions.csv"
    branches = %w(AB BC SK MB ON QC)

    dates = []
    (Date.new(2024, 1, 1)..Date.today).each do |date|
        dates << date.strftime("%Y-%m-%d")
    end

    amounts = []
    1000.times do
        amounts << format("%.2f", rand(-500.00..1000.00))
    end

    CSV.open("/rails/#{filename}", "w") do |csv|
        csv << ["branch", "timestamp", "amount"]

        args[:rows].to_i.times do |index|
            csv << [branches.sample, dates.sample, amounts.sample]

            puts index.to_fs(:delimited) if index > 0 && index % 100000 === 0
        end
    end
  
    puts "CSV file './rails/#{filename}' generated successfully!"
end
