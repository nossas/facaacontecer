# coding: utf-8
module ProjectDecorator
  
  def backers_count
    t('backers_html', count: subscribers.count) 
  end


  def reached
    t('goal.reached_of_html', 
           current: number_to_currency(revenue, precision: 0), 
           goal: number_to_currency(goal, :precision => 0)
      )
  end

  def days_remaining
    total_days = days 
    now = ((total_days - end_date) * 100)/total_days
    date = end_date == 1 ? t('goal.last_day_remaining_html') : t('goal.days_remaining_html', count: end_date)

    content_tag(
      :div, content_tag(:div, nil, id: :p_progress, style: "width: #{now}%"),
      id: :p_progress_bg, class: :small
    ) + date
    
  end

  def progress
    current = self.subscribers.size
    goal    = 1000.00
    now = (current * 100)/goal

    content_tag(
      :div, content_tag(:div, nil, id: :progress, style: "width: #{now}%"), 
      id: :progress_bg, class: :small
    ) +
    t('goal.people_so_far_html', days: current)
  end


  def video_embed
    content_tag(:iframe, nil, type: 'text/html', frameborder: 0, width: 512, height: 305, src: video)
  end


  def short_description
    truncate description, length: 160
  end


  def call_to_action
    link_to t('home.call_to_action'), new_project_subscriber_path(self), class: 'blue_button reserve'
  end
end
