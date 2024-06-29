task :generate_transaction_aggregations => :environment do |task|
    start_date = Date.parse('2024-01-01')
    end_date = Date.today
    number_of_months = (end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month) + 1

    def mapAgg(agg, report, data_key)
        agg.each do |key, value|
            date, branch = key
            string_date = date.strftime('%Y-%m-%d')

            report[:data][string_date] ||= {}
            report[:data][string_date][branch] ||= {}
            report[:data][string_date][branch][data_key] ||= 0.00
            report[:data][string_date][branch][data_key] += value.to_f
        end
    end

    number_of_months.times.each_with_object([]) do |count, array|
        loop_date = start_date.beginning_of_month + count.months
        report = {month: loop_date, data: {}}

        transactionCounts = Transaction.where(:timestamp => loop_date.beginning_of_day..loop_date.end_of_month.end_of_day).group(:timestamp, :branch).count
        balances = Transaction.where(:timestamp => loop_date.beginning_of_day..loop_date.end_of_month.end_of_day).group(:timestamp, :branch).sum(:amount)

        mapAgg(transactionCounts, report, :transactionCount)
        mapAgg(balances, report, :balance)
        
        report[:data] = report[:data].sort_by { |key| key }.to_h

        Report.create(report)

        puts "Created report for #{loop_date.strftime('%Y-%m-%d')}"
    end
end
