class UpsertTransactionJob
  include Sidekiq::Job

  def perform(*args)
    puts 'it works!'
    puts args
  end
end
