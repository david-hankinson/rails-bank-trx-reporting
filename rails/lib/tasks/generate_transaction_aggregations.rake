task :generate_transaction_aggregations => :environment do |task|
    start_date = Date.parse('2024-01-01')
    end_date = Date.today
    number_of_months = (end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month) + 1

    def mapAgg(agg, report, data_key)
        agg.each do |key, value|
            date, branch = key
            string_date = date.strftime('%Y-%m-%d')

            report[:data][:days][string_date] ||= {}
            report[:data][:days][string_date][branch] ||= {}
            report[:data][:days][string_date][branch][data_key] ||= 0.00
            report[:data][:days][string_date][branch][data_key] += value.to_f
        end
    end

    number_of_months.times.each_with_object([]) do |count, array|
        loop_date = start_date.beginning_of_month + count.months
        report = {month: loop_date, data: {agg: {}, days: {}}}

        transactionCounts = Transaction.where(:timestamp => loop_date.beginning_of_day..loop_date.end_of_month.end_of_day).group(:timestamp, :branch).count
        balances = Transaction.where(:timestamp => loop_date.beginning_of_day..loop_date.end_of_month.end_of_day).group(:timestamp, :branch).sum(:amount)

        mapAgg(transactionCounts, report, :transactionCount)
        mapAgg(balances, report, :balance)
        
        report[:data][:days] = report[:data][:days].sort_by { |key| key }.to_h
        report[:data][:days].each do |key, day|
            day.each do |branch, data|
                report[:data][:agg][branch] ||= {}
                report[:data][:agg][branch][:transactionCount] ||= 0
                report[:data][:agg][branch][:transactionCount] += data[:transactionCount]

                unless report[:data][:agg][branch].key?(:min)
                    report[:data][:agg][branch][:min] = data[:balance] || 0.0
                else
                    report[:data][:agg][branch][:min] = [report[:data][:agg][branch][:min], data[:balance]].min
                end

                unless report[:data][:agg][branch].key?(:max)
                    report[:data][:agg][branch][:max] = data[:balance] || 0.0
                else
                    report[:data][:agg][branch][:max] = [report[:data][:agg][branch][:max], data[:balance]].max
                end

                unless report[:data][:agg][branch].key?(:avg)
                    report[:data][:agg][branch][:avg] = data[:balance] || 0.0
                else
                    report[:data][:agg][branch][:avg] = ([report[:data][:agg][branch][:avg], data[:balance]].sum.to_f / 2).round(2)
                end
            end
        end

        Report.create(report)

        puts "Created report for #{loop_date.strftime('%Y-%m-%d')}"
    end
end
