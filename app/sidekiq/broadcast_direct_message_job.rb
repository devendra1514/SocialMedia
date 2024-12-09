class BroadcastDirectMessageJob
  def perform(*args)
    user_id, data = args
    Api::V1::DirectMessageChannel.broadcast_to("api_v1_user_#{user_id}", data)
  end
end
