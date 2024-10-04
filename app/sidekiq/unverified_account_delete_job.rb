class UnverifiedAccountDeleteJob
  include Sidekiq::Job

  def perform(*args)
    User.where(verified: false)
      .where('created_at <= ?', Time.current - 24.hours)
      .in_batches(of: 500) do |users_batch|

      users_batch.destroy_all
    end
  end
end
