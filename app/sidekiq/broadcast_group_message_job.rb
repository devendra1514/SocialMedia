class BroadcastGroupMessageJob
  def perform(*args)
    group_id, data = args
    Api::V1::GroupMessageChannel.broadcast_to("api_v1_group_#{group_id}", data)
  end
end
