class InsertTransactionJob
  include Sidekiq::Job

  def perform(*args)
    # insert the whole batch in a single query
    # this does not trigger any callbacks or validations
    Transaction.insert_all(args[0].each.map{|raw| {
      branch: raw[0],
      timestamp: Date.parse(raw[1]),
      amount: raw[2],
    } })
  end
end
