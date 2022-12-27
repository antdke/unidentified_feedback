class PagesController < ApplicationController
  def home
    @pay_link_url = StripeService.create_pay_link(session[:feedback_id])
  end

  def thanks
  end

  def payment_received
    @feedback_id = params[:feedback_id]
    # when user gets to this page, send email to me
    AdminMailer.with(feedback_id: @feedback_id).pinned_tweet_purchased_email.deliver_later
    redirect_to thanks_path
  end

  def feedback_in_queue
    # present user with estimated time until feedback is tweeted
    if Feedback.count > 0
      tweet_job_scheduled_at_time = Feedback.find(session[:feedback_id]).delayed_job_scheduled_at.to_i
      @estimated_minutes_until_tweet = (tweet_job_scheduled_at_time - Time.new.to_i).fdiv(60).ceil
    end
  end
  
  
end
