module Api::AppHelper
  def get_time(time, type = 'ago')
    return "Invalid time" unless time.is_a?(Time)

    ist_time_now = Time.current.in_time_zone("Asia/Kolkata")
    ist_time = time.in_time_zone("Asia/Kolkata")

    difference_in_seconds = ist_time_now - ist_time

    if type == 'ago'
      case difference_in_seconds
      when 0..59
        "#{difference_in_seconds.to_i} seconds ago"
      when 60..3599
        "#{(difference_in_seconds / 60).to_i} minutes ago"
      when 3600..86_399
        "#{(difference_in_seconds / 3600).to_i} hours ago"
      when 86_400..432_000
        "#{(difference_in_seconds / 86_400).to_i} days ago"
      else
        ist_time.strftime(difference_in_seconds <= 31_536_000 ? "%d %B" : "%d %B %Y")
      end
    else
      current_year = ist_time_now.year
      current_day = ist_time_now.day
      current_month = ist_time_now.month
      if ist_time.day == current_day && ist_time.month == current_month && ist_time.year == current_year
        ist_time.strftime("%I:%M %p")
      elsif ist_time.year == current_year
        ist_time.strftime("%d %b %I:%M %p")
      elsif ist_time.year != current_year
        ist_time.strftime("%d %b %y %I:%M %p")
      end
    end
  end
end
